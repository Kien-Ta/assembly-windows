option casemap:none

WriteFile proto
GetStdHandle proto
ExitProcess proto
ReadFile proto

.data
	num1	QWORD	0
	num2	QWORD	0
	total	QWORD	0
	incre	QWORD	10
	leng	QWORD	0
	error	db		"Loi dau vao", 0
	len		equ		$ - error

.data?
	num1_str    db   33 dup(?)
    num2_str    db   33 dup(?)
    total_str   db   33 dup(?)
    temp        db   1 dup(?)

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
	lea		rdx, num1_str
	mov		r8, 512
	mov		r9, NULL
	call	ReadFile
	add		rsp, 40

	sub		rsp, 32
	mov		rcx, getstdin
	call	GetStdHandle
	add		rsp, 32
	
	push	0
	sub		rsp, 32
	mov		rcx, rax
	lea		rdx, num2_str
	mov		r8, 512
	mov		r9, NULL
	call	ReadFile
	add		rsp, 40

	lea		rsi, num1_str
	push	rax
	push	rcx
	xor		rax, rax
	xor		rcx, rcx

whiletrue:
	mov		cl, [rsi]
	cmp		cl, 13
	je		outloop

	cmp		cl, 47
	jng		someerror
	cmp		cl, 58
	jnl		someerror

	mul		incre
	sub		cl, '0'
	add		rax, rcx

	inc		rsi
	jmp		whiletrue

someerror:
	sub		rsp, 32
	mov		rcx, getstdout
	call	GetStdHandle
	add		rsp, 32

	push	0
	sub		rsp, 32
	mov		rcx, rax
	lea		rdx, error
	mov		r8, 512
	mov		r9, NULL
	call	WriteFile
	add		rsp, 40

	jmp		endprogram


outloop:
	mov		num1, rax
	pop		rcx
	pop		rax

	lea		rsi, num2_str
	push	rax
	push	rcx
	mov		rax, 0
	mov		rax, 0

whiletrue2:
	mov		cl, [rsi]
	cmp		cl, 13
	je		outloop2

	cmp		cl, 47
	jng		someerror2
	cmp		cl, 58
	jnl		someerror2

	mul		incre
	sub		cl, '0'
	add		rax, rcx

	inc		rsi
	jmp		whiletrue2

someerror2:
	sub		rsp, 32
	mov		rcx, getstdout
	call	GetStdHandle
	add		rsp, 32

	push	0
	sub		rsp, 32
	mov		rcx, rax
	lea		rdx, error
	mov		r8, 512
	mov		r9, NULL
	call	WriteFile
	add		rsp, 40

	jmp		endprogram

outloop2:
	mov		num2, rax
	pop		rcx
	pop		rax

	mov		rcx, num1
	mov		rdx, num2
	add		rdx, rcx
	mov		total, rdx

	mov		rax, total
	mov		rbx, 10

	sub		rsp, 32
	call	Display
	add		rsp, 32

	sub		rsp, 32
	mov		rcx, getstdout
	call	GetStdHandle
	add		rsp, 32

	push	0
	sub		rsp, 32
	mov		rcx, rax
	lea		rdx, total_str
	mov		r8, len
	mov		r9, NULL
	call	WriteFile
	add		rsp, 40
	
endprogram:
	xor		rcx, rcx
	call	ExitProcess

	leave
	ret

main endp

Display proc
	push	rbp
	mov		rbp, rsp

	lea		rsi, total_str
	xor		rcx, rcx
	
continue:
	xor		rdx, rdx

	div		rbx
	inc		rcx
	push	rdx

	mov		leng, rcx

	cmp		rax, 0
	je		done
	jmp		continue
	
done:
	pop		rdx
	add		rdx, '0'
	mov		QWORD PTR [rsi], rdx
	inc		rsi
	loop	done

	leave
	ret
Display endp

end