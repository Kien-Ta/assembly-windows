option casemap:none

include asm14_addin.inc

WinMain proto

.data
	WindowWidth		QWORD	300
	WindowHeight	QWORD	300
	linenew			db		13, 10, 0
	ClassName		db		"WinClass", 0
	AppName			db		"Bouncin' Boll", 0

	size_of_qword	QWORD	8
	ballX			QWORD	100
	ballY			QWORD	100
	radius			QWORD	30
	dir				QWORD	0
	idx				dq		1, -1, -1, 1
	idy				dq		1, 1, -1, -1

	lower		QWORD	0
	upper		QWORD	0
	range		QWORD	0

.data?
	hInstance	QWORD	?
	CommandLine	QWORD		?

	msg		db	48	dup(?)
	wc			WNDCLASSEXA	<>
	hWnd	QWORD	?
	uMsg	QWORD	?
	lParam	QWORD	?
	wParam	QWORD	?

	hwnd	QWORD	?

	hdc1	QWORD	?
	ps		PAINTSTRUCT	<>
	rect	RECT	<>

	hPen	QWORD	?
	hBrush	QWORD	?
	lb		LOGBRUSH	<>

.const
	NULL	equ	0
	TRUE	equ	1

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

; insert random direction
	mov		lower, 0
	mov		upper, 3
	sub		rsp, 32
	call	rand
	add		rsp, 32
	mov		dir, rax

	mov		rax, WindowWidth
	sub		rax, radius
	sub		rax, 30
	mov		upper, rax
	mov		rax, radius
	add		rax, 5
	mov		lower, rax
	sub		rsp, 32
	call	rand
	add		rsp, 32
	mov		ballX, rax

	mov		rax, WindowHeight
	sub		rax, radius
	sub		rax, 45
	mov		upper, rax
	mov		rax, radius
	add		rax, 5
	mov		lower, rax
	sub		rsp, 32
	call	rand
	add		rsp, 32
	mov		ballY, rax

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

	cmp		uMsg, WM_DESTROY
	je		WMDESTROY

	cmp		uMsg, WM_PAINT
	je		WMPAINT

	cmp		uMsg, WM_CREATE
	je		WMCREATE

	cmp		uMsg, WM_TIMER
	je		WMTIMER

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
	mov		r8, 6
	mov		r9, 0
	sub		rsp, 32
	call	SetTimer
	add		rsp, 32

	jmp		WndProcEnd

WMPAINT:
	mov		rcx, hWnd
	lea		rdx, rect
	sub		rsp, 32
	call	GetWindowRect
	add		rsp, 32

	xor		rax, rax

	mov		eax, rect.right
	sub		eax, rect.left
	mov		WindowWidth, rax

	mov		eax, rect.bottom
	sub		eax, rect.top
	mov		WindowHeight, rax

	mov		rcx, hWnd
	lea		rdx, ps
	sub		rsp, 32
	call	BeginPaint
	add		rsp, 32

	mov		rax, ps.hdc
	mov		hdc1, rax

; check if meet edge
	mov		rax, ballX
	sub		rax, radius
	cmp		rax, 0
	jle		meetLeftEdge

	mov		rax, ballY
	sub		rax, radius
	cmp		rax, 0
	jle		meetUpperEdge

	mov		rax, ballX
	mov		rbx, WindowWidth
	sub		rbx, radius
	sub		rbx, 15
	sub		rax, rbx
	cmp		rax, 0
	jge		meetRightEdge

	mov		rax, ballY
	mov		rbx, WindowHeight
	sub		rbx, radius
	sub		rbx, 40
	sub		rax, rbx
	cmp		rax, 0
	jge		meetBottomEdge

	jmp		moveByDirection

meetLeftEdge:
	cmp		dir, 1
	je		leftEdge1
	cmp		dir, 2
	jne		moveByDirection
	mov		dir, 3
	jmp		moveByDirection
leftEdge1:
	mov		dir, 0
	jmp		moveByDirection

meetUpperEdge:
	cmp		dir, 2
	je		upperEdge2
	cmp		dir, 3
	jne		moveByDirection
	mov		dir, 0
	jmp		moveByDirection
upperEdge2:
	mov		dir, 1
	jmp		moveByDirection

meetRightEdge:
	cmp		dir, 0
	je		rightEdge0
	cmp		dir, 3
	jne		moveByDirection
	mov		dir, 2
	jmp		moveByDirection
rightEdge0:
	mov		dir, 1
	jmp		moveByDirection

meetBottomEdge:
	cmp		dir, 0
	je		bottomEdge0
	cmp		dir, 1
	jne		moveByDirection
	mov		dir, 2
	jmp		moveByDirection
bottomEdge0:
	mov		dir, 3
	jmp		moveByDirection

moveByDirection:
	mov		rax, dir
	mul		size_of_qword
	lea		rsi, idx
	add		rsi, rax
	xor		rdx, rdx
	mov		rdx, QWORD PTR [rsi]
	add		ballX, rdx

	mov		rax, dir
	mul		size_of_qword
	lea		rsi, idy
	add		rsi, rax
	xor		rdx, rdx
	mov		rdx, QWORD PTR [rsi]
	add		ballY, rdx

	sub		rsp, 32
	call	drawBall
	add		rsp, 32

	mov		rcx, hWnd
	lea		rdx, ps
	sub		rsp, 32
	call	EndPaint
	add		rsp, 32

	jmp		WndProcEnd

WMTIMER:
	mov		rcx, hWnd
	mov		rdx, NULL
	mov		r8, TRUE
	sub		rsp, 32
	call	InvalidateRect
	add		rsp, 32

	jmp		WndProcEnd

WMDESTROY:
	mov		rcx, hWnd
	mov		rdx, 1
	sub		rsp, 32
	call	KillTimer
	add		rsp, 32

	mov		rcx, NULL
	sub		rsp, 32
	call	PostQuitMessage
	add		rsp, 32

WndProcEnd:
	xor		rax, rax

	leave
	ret
WndProc endp

drawBall proc
	push	rbp
	mov		rbp, rsp

	mov		rcx, PS_SOLID
	mov		rdx, 0
	mov		r8, COLOR_BLACK
	sub		rsp, 32
	call	CreatePen
	add		rsp, 32
	mov		hPen, rax

	mov		lb.lbStyle, BS_SOLID
	mov		lb.lbColor, COLOR_RED
	mov		lb.lbHatch, NULL

	lea		rcx, lb
	sub		rsp, 32
	call	CreateBrushIndirect
	add		rsp, 32
	mov		hBrush, rax

	mov		rcx, hdc1
	mov		rdx, hPen
	sub		rsp, 32
	call	SelectObject
	add		rsp, 32

	mov		rcx, hdc1
	mov		rdx, hBrush
	sub		rsp, 32
	call	SelectObject
	add		rsp, 32

	mov		rcx, hdc1
	mov		rax, ballX
	sub		rax, radius
	mov		rdx, rax
	mov		rax, ballY
	sub		rax, radius
	mov		r8, rax
	mov		rax, ballX
	add		rax, radius
	mov		r9, rax
	mov		rax, ballY
	add		rax, radius
	push	rax
	sub		rsp, 32
	call	Ellipse
	add		rsp, 40
	
	leave
	ret
drawBall endp

rand proc
	push	rbp
	mov		rbp, rsp

	mov		rax, upper
	sub		rax, lower
	inc		rax
	mov		range, rax

	rdtsc

	xor		rdx, rdx
	div		range

	mov		rax, rdx
	add		rax, lower

	leave
	ret
rand endp

end