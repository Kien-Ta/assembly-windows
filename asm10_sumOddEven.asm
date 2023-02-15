option casemap:none

WriteFile proto
GetStdHandle proto
ExitProcess proto
ReadFile proto
SetConsoleMode proto

.data
    error  db  "Loi dau vao", 0
    endin  db  "Ket thuc nhap", 0
    result db  "Ket qua", 0
    sum_odd     db  "Tong cac so le: ", 0
    sum_even    db  "Tong cac so chan: ", 0
    linenew db  13, 10, 0
    sum_odd_low     QWORD   0
    sum_odd_high    QWORD   0
    sum_even_low    QWORD   0
    sum_even_high   QWORD   0
    num         QWORD   0
    len1        QWORD   0
    err_check   BYTE    0
    incre       QWORD   10
    divd        QWORD   2

    temp_addr   QWORD   0

    leng    QWORD   0

    hInput  QWORD   0
    bToRead QWORD   0

    hOutput QWORD   0
    sl      QWORD   0

    addr_high   QWORD   0
    addr_low    QWORD   0

.data?
    num_1   db  512 dup(?)
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

W1:
    mov     err_check, 0

    sub     rsp, 32
    lea     rcx, num_1
    mov     temp_addr, rcx
    call    StdIn
    add     rsp, 32
    mov     len1, rax

    cmp     len1, 0
    jne     W2

    sub     rsp, 32
    lea     rcx, endin
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, linenew
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    jmp     W5


W2:
    cmp     err_check, 1
    jne     W3

    sub     rsp, 32
    lea     rcx, error
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, linenew
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    jmp     W1

W3:
    sub     rsp, 32
    lea     rcx, num_1
    mov     temp_addr, rcx
    call    StrToInt
    add     rsp, 32

    mov     num, rax

    mov     rdx, 0
    div     divd

    cmp     rdx, 0
    je      W4

    mov     rax, sum_odd_low
    add     rax, num
    mov     sum_odd_low, rax

    jmp     W1

W4:
    mov     rax, sum_even_low
    add     rax, num
    mov     sum_even_low, rax

    jmp     W1


W5:
    sub     rsp, 32
    lea     rcx, result
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, linenew
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, sum_odd
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

	sub	    rsp, 32
	mov     rax, sum_odd_low
	call	Display
	add	    rsp, 32

    sub     rsp, 32
    lea     rcx, linenew
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, sum_even
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32
    
	sub	    rsp, 32
	mov     rax, sum_even_low
	call	Display
	add	    rsp, 32

    sub     rsp, 32
    lea     rcx, linenew
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    xor     rcx, rcx
    call    ExitProcess

    leave
    ret
main endp

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