; so qua lon van se sai
option casemap:none

WriteFile proto
GetStdHandle proto
ExitProcess proto
ReadFile proto
SetConsoleMode proto

.data
	linenew     db      13, 10, 0
    def      BYTE    1
    num      QWORD   0
    fib_n    QWORD   1
    fib_np   QWORD   1
    result   QWORD   1
    incre    QWORD   10
    error    db      "Loi dau vao", 0

    temp_addr   QWORD   0

    leng    QWORD   0

    hInput  QWORD   0
    bToRead QWORD   0

    hOutput QWORD   0
    sl      QWORD   0

.data?
    num_in  db  512 dup(?)
    temp    db  1   dup(?)

    total_str   db  512 dup(?)

.const
    getstdout   equ -11
    getstdin    equ -10
    NULL        equ 0
    TRUE        equ 1
    ENABLE_LINE_INPUT       equ 2h   
    ENABLE_ECHO_INPUT       equ 4h
    ENABLE_PROCESSED_INPUT  equ 1h

.code
main proc
    push    rbp
    mov     rbp, rsp

    sub     rsp, 32
    lea     rcx, num_in
    mov     temp_addr, rcx
    call    StdIn
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, num_in
    mov     temp_addr, rcx
    call    StrToInt
    add     rsp, 32

    mov     num, rax

    sub     rsp, 32
    call    Fibo
    add     rsp, 32

    xor     rcx, rcx
    call    ExitProcess

    leave
    ret
main endp

Fibo proc
    push    rbp
    mov     rbp, rsp

    mov     rax, 0
    mov     rcx, 1

whiletrue:
    cmp     rcx, num
    jg      endwhile

    cmp     rcx, 1
    je     calc
    cmp     rcx, 2
    je     calc

    mov     rbx, fib_np
    mov     fib_n, rbx
    mov     rbx, result
    mov     fib_np, rbx
    mov     rbx, fib_n
    add     result, rbx

    mov     rax, result
    push    rcx
    sub     rsp, 32
    call    Display
    add     rsp, 32
    pop     rcx
    jmp     if_cont

calc:
    mov     al, def
    push    rcx
    sub     rsp, 32
    call    Display
    add     rsp, 32
    pop     rcx

if_cont:
    inc     rcx
    push    rcx

    sub     rsp, 32
    lea     rcx, linenew
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    pop     rcx
    jmp     whiletrue

endwhile:
    leave
    ret
Fibo endp

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
endwhile2:

    cmp     rax, 100
    jge     someerror
    cmp     rax, 0
    je      someerror

    jmp     leavenow

someerror:
    sub     rsp, 32
    lea     rcx, error
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    xor     rcx, rcx
    call    ExitProcess

leavenow:
    leave
    ret
StrToInt endp

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