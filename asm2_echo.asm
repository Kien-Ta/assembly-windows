option casemap:none

WriteFile proto
GetStdHandle proto
ExitProcess proto
ReadFile proto

.data?
	buffer	db	512	dup(?)

.const
	getstdout	equ		-11
	getstdin	equ		-10
	NULL		equ		0
	TRUE		equ		1

.code
main proc
	push	rbp
	mov		rbp, rsp
	
	sub		rsp, 32
	mov		rcx, getstdin
	call	GetStdHandle
	add		rsp, 32

	push	0
	sub		rsp, 32
	mov		rcx, rax
	lea		rdx, buffer
	mov		r8, 512
	mov		r9, NULL
	call	ReadFile
	add		rsp, 40

	sub		rsp, 32
	mov		rcx, getstdout
	call	GetStdHandle
	add		rsp, 32

	push	0
	sub		rsp, 32
	mov		rcx, rax
	lea		rdx, buffer
	mov		r8, 512
	mov		r9, 0
	call	WriteFile
	add		rsp, 40

	xor		rcx, rcx
	call	ExitProcess

	leave
	ret
main endp
end