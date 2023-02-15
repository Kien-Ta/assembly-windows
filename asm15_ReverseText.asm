option casemap:none

include asm15_addin.inc

WinMain proto

.data
	WindowWidth		QWORD	700
	WindowHeight	QWORD	150
	linenew			db		13, 10, 0
	ClassName		db		"WinClass", 0
	AppName			db		"Reverso", 0
	EditClassName	db		"edit", 0
	Tester			db		"Test", 0

.data?
	hInstance	QWORD	?
	CommandLine	QWORD		?
	text_input	db	512	dup(?)
	textbox		QWORD	?
	textfield	QWORD	?

	msg		db	48	dup(?)
	wc			WNDCLASSEXA	<>
	hWnd	QWORD	?
	uMsg	QWORD	?
	lParam	QWORD	?
	wParam	QWORD	?

	hwnd	QWORD	?

.const
	NULL		equ	0
	TRUE		equ	1

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

	xor		rcx, rcx
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

reverseString proc
	push	rbp
	mov		rbp, rsp

	lea		rcx, text_input
	mov		rsi, rcx
	mov		rdi, rcx
	sub		rdi, 2

find_end:
	add		rdi, 2
	mov		cx, [rdi]
	cmp		cx, 0
	jne		find_end
	sub		rdi, 2

swap:
	cmp		rsi, rdi
	jge		finished

	mov		cx, [rsi]
	mov		dx, [rdi]
	mov		[rsi], dx
	mov		[rdi], cx

	add		rsi, 2
	sub		rdi, 2
	jmp		swap

finished:
	leave
	ret
reverseString endp

WndProc proc
	push	rbp
	mov		rbp, rsp

	mov		hWnd, rcx
	mov		uMsg, rdx
	mov		wParam, r8
	mov		lParam, r9

	cmp		uMsg, WM_CREATE
	je		WMCREATE

	cmp		uMsg, WM_DESTROY
	je		WMDESTROY

	cmp		uMsg, WM_COMMAND
	je		WMCOMMAND

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
	mov		rcx, WS_EX_CLIENTEDGE
	mov		rdx, offset EditClassName
	mov		r8, NULL
	mov		r9, WS_BORDER or WS_CHILD or WS_VISIBLE
	push	NULL
	push	hInstance
	push	NULL
	push	hWnd
	push	30
	push	600
	push	10
	push	40
	sub		rsp, 32
	call	CreateWindowExA
	add		rsp, 96
	mov		textbox, rax

	mov		rcx, WS_EX_CLIENTEDGE
	mov		rdx, offset EditClassName
	mov		r8, NULL
	mov		r9, WS_BORDER or WS_CHILD or WS_VISIBLE or ES_READONLY
	push	NULL
	push	hInstance
	push	1
	push	hWnd
	push	30
	push	600
	push	50
	push	40
	sub		rsp, 32
	call	CreateWindowExA
	add		rsp, 96
	mov		textfield, rax

	jmp		WndProcEnd

WMCOMMAND:
	mov		rax, wParam
	shr		rax, 16
	cmp		ax, EN_CHANGE
	jne		WndProcEnd

	mov		rcx, textbox
	lea		rdx, text_input
	mov		r8, 512
	sub		rsp, 32
	call	GetWindowTextW
	add		rsp, 32

	sub		rsp, 32
	call	reverseString
	add		rsp, 32

	mov		rcx, textfield
	lea		rdx, text_input
	sub		rsp, 32
	call	SetWindowTextW
	add		rsp, 32

	jmp		WndProcEnd

WMDESTROY:
	mov		rcx, NULL
	call	PostQuitMessage


WndProcEnd:
	xor		rax, rax

	leave
	ret
WndProc endp

end