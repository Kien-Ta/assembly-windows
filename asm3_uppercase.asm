option casemap:none

WriteFile proto
GetStdHandle proto
ExitProcess proto
ReadFile proto

.data?
	buffer		db	512	dup(?)
	result		db	512	dup(?)

.const
	getstdout	equ	-11
	getstdin	equ	-10
	NULL		equ	0
	TRUE		equ	1

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

	lea		rsi, buffer
	lea		rdi, result

whiletrue:
	mov		dl, [rsi]
	cmp		dl, 13
	jne		check
	
	mov		dl, 0
	mov		[rdi], dl
	jmp		outloop

check:
	cmp		dl, 96
	jng		increment
	cmp		dl, 123
	jnb		increment
	sub		dl, 32

increment:
	mov		[rdi], dl

	inc		rsi
	inc		rdi
	jmp		whiletrue

outloop:
	sub		rsp, 32
	mov		rcx, getstdout
	call	GetStdHandle
	add		rsp, 32

	push	0
	sub		rsp, 32
	mov		rcx, rax
	lea		rdx, result
	mov		r8, 512
	mov		r9, NULL
	call	WriteFile
	add		rsp, 40

	xor		rcx, rcx
	call	ExitProcess

	leave
	ret

main endp
end