option casemap:none

include	asm16_addin.inc

WinMain proto

.data
	tester	db	"Hallo", 0
	;hwndMain	QWORD	0
	linenew	db	13, 10, 0
	len		QWORD	0
	;Edge	db	"EdgeUiInputTopWndClass", 0
	Chromium	db	"Chrome_WidgetWin_1", 0
	FireFox		db	"MozillaWindowClass", 0

	WindowHeight	QWORD	150
	WindowWidth		QWORD	700
	ClassName		db		"WinClass", 0
	AppName			db		"Anti Browser", 0


.data?
	temp	db	512	dup(?)
	hInstance	QWORD	?
	CommandLine	QWORD	?
	msg		db	48	dup(?)
	wc		WNDCLASSEXA <>
	hWnd	QWORD	?
	uMsg	QWORD	?
	lParam	QWORD	?
	wParam	QWORD	?
	hWndBrowser	QWORD	?
	hwnd	QWORD	?

.const
	stdout			equ	-11
	WM_DESTROY		equ 02h
	WM_QUIT			equ	012h
	WM_CLOSE		equ	010h
	WM_NCDESTROY	equ	082h
	NULL			equ	0
	TRUE			equ 1

.code
main proc
	push	rbp
	mov		rbp, rsp

	mov		rcx, NULL
	sub		rsp, 32
	call	GetModuleHandleA
	add		rsp, 32
	mov		hInstance, rax

	sub		rsp, 32
	call	GetCommandLineA
	add		rsp, 32
	mov		CommandLine, rax

	mov		rcx, hInstance
	mov		rdx, NULL
	mov		r8, CommandLine
	mov		r9, SW_SHOWNORMAL
	sub		rsp, 32
	call	WinMain
	add		rsp, 32

	mov		rcx, 0
	call	ExitProcess

	leave
	ret
main endp


WinMain proc
	push	rbp
	mov		rbp, rsp

	push	rcx
	pop		wc.hInstance
	mov		wc.cbSize, SIZEOF WNDCLASSEXA
	mov		wc.style, CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNWINDOW
	lea		rax, WndProc
	mov		wc.lpfnWndProc, rax
	mov		wc.cbClsExtra, NULL
	mov		wc.cbWndExtra, NULL
	
	mov		wc.hIcon, NULL
	mov		wc.hIconSm, NULL
	mov		rcx, NULL
	mov		rdx, IDC_ARROW
	sub		rsp, 32
	call	LoadCursorA
	add		rsp, 32
	mov		wc.hCursor, rax
	mov		wc.hbrBackground, COLOR_WINDOW + 1
	mov		wc.lpszMenuName, NULL
	lea		rax, ClassName
	mov		wc.lpszClassName, rax

	lea		rcx, wc
	sub		rsp, 32
	call	RegisterClassExA
	add		rsp, 32

	mov		rcx, WS_EX_COMPOSITED
	mov		rdx, offset ClassName
	mov		r8, offset AppName
	mov		r9, WS_OVERLAPPEDWINDOW
	push	NULL
	push	wc.hInstance
	push	NULL
	push	NULL
	push	WindowHeight
	push	WindowWidth
	push	CW_USEDEFAULT
	push	CW_USEDEFAULT
	sub		rsp, 32
	call	CreateWindowExA
	add		rsp, 96

	mov		hwnd, rax

	mov		rcx, hwnd
	mov		rdx, SW_SHOWNORMAL
	sub		rsp, 32
	call	ShowWindow
	add		rsp, 32

	mov		rcx, hwnd
	sub		rsp, 32
	call	UpdateWindow
	add		rsp, 32

msg_loop:
	lea		rcx, msg
	mov		rdx, NULL
	mov		r8, 0
	mov		r9, 0
	sub		rsp, 32
	call	GetMessageA
	add		rsp, 32
	cmp		rax, 0
	je		done

	lea		rcx, msg
	sub		rsp, 32
	call	TranslateMessage
	add		rsp, 32

	lea		rcx, msg
	sub		rsp, 32
	call	DispatchMessageA
	add		rsp, 32

	jmp		msg_loop

done:
	mov		rcx, 0
	leave
	ret

WinMain endp


WndProc proc
	push	rbp
	mov		rbp, rsp

	mov		hWnd, rcx
	mov		uMsg, rdx
	mov		wParam, r8
	mov		lParam, r9

	cmp		uMsg, WM_CREATE
	je		WMCREATE

	cmp		uMsg, WM_TIMER
	je		WMTIMER

	cmp		uMsg, WM_DESTROY
	je		WMDESTROY

Default:
	mov		rcx, hWnd
	mov		rdx, uMsg
	mov		r8, wParam
	mov		r9, lParam
	sub		rsp, 32
	call	DefWindowProcA
	add		rsp, 32

	leave
	ret

WMCREATE:
	mov		rcx, hWnd
	mov		rdx, 1
	mov		r8, 5000
	mov		r9, 0
	sub		rsp, 32
	call	SetTimer
	add		rsp, 32

	jmp		WndProcEnd

WMTIMER:
	lea		rcx, antiBrowser
	mov		rdx, 0
	sub		rsp, 32
	call	EnumWindows
	add		rsp, 32

	jmp		WndProcEnd

WMDESTROY:
	mov		rcx, hWnd
	mov		rdx, 1
	sub		rsp, 32
	call	KillTimer
	add		rsp, 32

	mov		rcx, 0
	sub		rsp, 32
	call	PostQuitMessage
	add		rsp, 32

WndProcEnd:
	xor		rax, rax
	leave
	ret

WndProc endp

antiBrowser proc
	push	rbp
	mov		rbp, rsp
	
	mov		hWndBrowser, rcx

	mov		rcx, hWndBrowser
	sub		rsp, 32
	call	IsWindowVisible
	add		rsp, 32
	cmp		rax, 0
	je		finished

	mov		rcx, hWndBrowser
	lea		rdx, temp
	mov		r8, 100
	sub		rsp, 32
	call	GetClassNameA
	add		rsp, 32

	mov		len, 0
	lea		rax, temp
	dec		rax
findLength:
	inc		rax
	inc		len
	cmp		BYTE PTR [rax], 0
	jne		findLength

	lea		rcx, temp
	lea		rdx, FireFox
checkFF:
	xor		rax, rax
	mov		al, 0
	cmp		al, BYTE PTR [rcx]
	je		byeFF
	mov		al, BYTE PTR [rcx]
	cmp		al, BYTE PTR [rdx]
	jne		andChrom
	inc		rcx
	inc		rdx
	jmp		checkFF

byeFF:
	mov		rcx, hWndBrowser
	mov		rdx, WM_CLOSE
	mov		r8, 0
	mov		r9, 0
	sub		rsp, 32
	call	SendMessageA
	add		rsp, 32
	jmp		finished

andChrom:
	lea		rcx, temp
	lea		rdx, Chromium
checkChrom:
	xor		rax, rax
	mov		al, 0
	cmp		al, BYTE PTR [rcx]
	je		byeChrom
	mov		al, BYTE PTR [rcx]
	cmp		al, BYTE PTR [rdx]
	jne		finished
	inc		rcx
	inc		rdx
	jmp		checkChrom
byeChrom:
	mov		rcx, hWndBrowser
	mov		rdx, WM_CLOSE
	mov		r8, 0
	mov		r9, 0
	sub		rsp, 32
	call	SendMessageA
	add		rsp, 32


finished:
	mov		rax, 1
	leave
	ret

antiBrowser endp

end