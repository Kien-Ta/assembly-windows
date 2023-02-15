option casemap:none

WriteFile proto
GetStdHandle proto
ExitProcess proto
ReadFile proto
SetConsoleMode proto

.data
	open		db	"May tinh", 13, 10, \
					"1. Cong", 13, 10, \
					"2. Tru (khong ho tro so am)", 13, 10, \
					"3. Nhan", 13, 10, \
					"4. Chia (khong ho tro so thap phan)", 13, 10, 0
	sohang1		db	"Nhap so hang 1: ", 0
	sohang2		db	"Nhap so hang 2: ", 0
    error	db  "Loi dau vao, xin nhap lai", 13, 10, 0
	finish	db	"Ket thuc chuong trinh", 0
    
    result db  "Ket qua: ", 0

    linenew db  13, 10, 0
    nlow     QWORD   0
    nhigh    QWORD   0
    
    num1        QWORD   0
	num2		QWORD	0
    len1        QWORD   0
	len2		QWORD	0
    err_check   BYTE    0
    incre       QWORD   10
    divd        QWORD   2
	choice		BYTE	0

    shadow      QWORD   0

    temp_addr   QWORD   0

    leng    QWORD   0

    hInput  QWORD   0
    bToRead QWORD   0

    hOutput QWORD   0
    sl      QWORD   0

.data?
    num_1   db  512 dup(?)
	num_2	db	512	duo(?)
    temp    db  1   dup(?)

    total_str   db  512 dup(?)

.const
    getstdout   equ -11
    getstdin    equ -10
    NULL        equ 0
    TRUE        equ 1
    ENABLE_LINE_INPUT       equ 02h   
    ENABLE_ECHO_INPUT       equ 04h
    ENABLE_PROCESSED_INPUT  equ 01h

.code
main proc
    push    rbp
    mov     rbp, rsp

start:
    jmp     W0

checking0:
    sub     rsp, 32
    lea     rcx, error
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32
    jmp     W0

checking1:
    sub     rsp, 32
    lea     rcx, error
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32
    jmp     W1

checking2:
    sub     rsp, 32
    lea     rcx, error
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32
    jmp     W2

W0:
    sub     rsp, 32
    lea     rcx, open
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, choice
    mov     temp_addr, rcx
    call    StdIn
    add     rsp, 32

    mov     len1, rax
    cmp     len1, 0
    je      finished
    cmp     len1, 1
    jne     checking0
    cmp     choice, '1'
    jl      checking0
    cmp     choice, '4'
    jg      checking0

W1:
    mov     err_check, 0

    sub     rsp, 32
    lea     rcx, sohang1
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, num_1
    mov     temp_addr, rcx
    call    StdIn
    add     rsp, 32

    mov     len1, rax
    cmp     len1, 0
    je      checking1
    cmp     err_check, 1
    je      checking1

W2:
    mov     err_check, 0

    sub     rsp, 32
    lea     rcx, sohang2
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, num_2
    mov     temp_addr, rcx
    call    StdIn
    add     rsp, 32

    mov     len2, rax
    cmp     len2, 0
    je      checking2
    cmp     err_check, 1
    je      checking2
    
    sub     rsp, 32
    lea     rcx, num_1
    mov     temp_addr, rcx
    call    StrToInt
    add     rsp, 32
    mov     num1, rax

    sub     rsp, 32
    lea     rcx, num_2
    mov     temp_addr, rcx
    call    StrToInt
    add     rsp, 32
    mov     num2, rax

    cmp		choice, '1'
	je		Calc1
	cmp		choice, '2'
	je		Calc2
	cmp		choice, '3'
	je		Calc3
	
	call	Division
	jmp		Show
	
Calc1:
	call 	Addition
	jmp		Show
Calc2:	
	call	Subtraction
	jmp		Show
Calc3:
	call	Multiplication

Show:
    sub     rsp, 32
    lea     rcx, result
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    cmp     nhigh, 0
    je      continue
    sub     rsp, 32
    mov     rax, nhigh
    call    Display
    add     rsp, 32

continue:
    sub     rsp, 32
    mov     rax, nlow
    call    Display
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, linenew
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, linenew
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32
    jmp     W0

finished:
    sub     rsp, 32
    lea     rcx, finish
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    xor     rcx, rcx
    call    ExitProcess

    leave
    ret
main endp

Addition proc
    push    rbp
    mov     rbp, rsp

    mov     rax, num1
    mov     rdx, num2
    add     rax, rdx
    mov     nlow, rax

    mov     nhigh, 0
    
    leave
    ret
Addition endp

Subtraction proc
    push    rbp
    mov     rbp, rsp

	mov		rax, num1
	mov		rdx, num2
	sub		rax, rdx
	
	mov		nlow, rax

    mov     nhigh, 0
	
    leave
	ret
Subtraction endp

Multiplication proc
    push    rbp
    mov     rbp, rsp

	mov		rax, num1
	mov		rdx, num2
	
	mul		rdx

	mov		nlow, rax
	mov		nhigh, rdx

    leave
	ret
Multiplication endp

Division proc
    push    rbp
    mov     rbp, rsp

	mov		rax, num1
	mov		rcx, num2

	div		rcx

	mov		nlow, rax
	mov		nhigh, 0

    leave
	ret
Division endp

StrToInt proc
    push    rbp
    mov     rbp, rsp

    mov     rsi, temp_addr
    mov     rax, 0
    mov     rcx, 0

whiletrue2:
    mov     cl, [rsi]
    
    cmp     cl, 0
    je      endwhile2

    cmp     cl, 47
    jng     someerror
    cmp     cl, 58
    jnl     someerror

    mul     incre
    sub     cl, '0'
    add     rax, rcx
    inc     rsi
    jmp     whiletrue2


someerror:
    sub     rsp, 32
    lea     rcx, error
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    xor     rcx, rcx
    call    ExitProcess

endwhile2:

leavenow:
    leave
    ret


StrToInt endp

Display proc
    push	rbp
	mov		rbp, rsp

	lea		rdi, total_str
	xor		rcx, rcx
	
continue:
	xor		rdx, rdx

	div		incre
	inc		rcx
	push	rdx

	mov		leng, rcx

	cmp		rax, 0
	je		done
	jmp		continue
	
done:
	pop		rdx
	add		rdx, '0'
	mov		QWORD PTR [rdi], rdx
	inc		rdi
	loop	done

    sub     rsp, 32
    lea     rcx, total_str
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

	leave
	ret

Display endp

StdIn proc
    push    rbp
    mov     rbp, rsp

    sub     rsp, 32
    mov     rcx, getstdin
    call    GetStdHandle
    add     rsp, 32
    
    mov     hInput, rax

    sub     rsp, 32
    mov     rcx, hInput
    mov     rdx, ENABLE_LINE_INPUT
    or      rdx, ENABLE_ECHO_INPUT
    or      rdx, ENABLE_PROCESSED_INPUT
    call    SetConsoleMode
    add     rsp, 32

    push    0
    sub     rsp, 32
    mov     rcx, hInput
    mov     rdx, temp_addr
    mov     r8, 512
    lea     r9, bToRead
    call    ReadFile
    add     rsp, 40

    mov     rsi, temp_addr
    dec     rsi
L1:
    inc     rsi
    mov     al, BYTE PTR [rsi]

    cmp     al, 47
    jng     testagain
    cmp     al, 58
    jnl     testagain
    jmp     cont

testagain:
    cmp     al, 13
    je      cont
    mov     err_check, 1
    leave
    ret

cont:
    cmp     BYTE PTR [rsi], 13
    jne     L1

    mov     BYTE PTR [rsi], 0

    mov     rax, bToRead
    sub     rax, 2

    leave
    ret
StdIn endp

StdOut proc
    push    rbp
    mov     rbp, rsp

    sub     rsp, 32
    mov     rcx, getstdout
    call    GetStdHandle
    add     rsp, 32

    mov     hOutput, rax

    mov     rsi, temp_addr
    dec     rsi
    mov     rcx, 0
L2:
    inc     rsi
    inc     rcx
    cmp     BYTE PTR [rsi], 0
    jne     L2

    mov     sl, rcx

    push    0
    sub     rsp, 32
    mov     rcx, hOutput
    mov     rdx, temp_addr
    mov     r8, sl
    mov     r9, NULL
    call    WriteFile
    add     rsp, 40

    leave
    ret
StdOut endp

end