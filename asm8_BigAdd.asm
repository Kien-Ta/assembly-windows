option casemap:none

WriteFile proto
GetStdHandle proto
ExitProcess proto
ReadFile proto
SetConsoleMode proto

.data
	error  db  "Loi dau vao", 0
    exp    db  "1", 0
    num1   QWORD    1
    num2   QWORD    1
    len1   QWORD    0
    len2   QWORD    0
    carry  BYTE     0
    flag   BYTE     0
    err_check   BYTE    0

    temp_addr   QWORD   0

    first   QWORD   0
    second  QWORD   0

    leng    QWORD   0

    hInput  QWORD   0
    bToRead QWORD   0

    hOutput QWORD   0
    sl      QWORD   0

.data?
    num_1   db  512 dup(?)
    num_2   db  512 dup(?)

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
    lea     rcx, num_1
    mov     temp_addr, rcx
    call    StdIn
    add     rsp, 32
    mov     len1, rax

    sub     rsp, 32
    lea     rcx, num_2
    mov     temp_addr, rcx
    call    StdIn
    add     rsp, 32
    mov     len2, rax

    cmp     len1, 0
    je      someerror
    cmp     len2, 0
    je      someerror
    cmp     len1, 20
    jg      someerror
    cmp     len2, 20
    jg      someerror
    cmp     err_check, 1
    je      someerror

    mov     rax, len1
    cmp     rax, len2
    jle     add1
    mov     flag, 1
    sub     rsp, 32
    call    BigAdd
    add     rsp, 32
    jmp     continue

add1:
    mov     rcx, len1
    mov     rdx, len2
    mov     len1, rdx
    mov     len2, rcx
    sub     rsp, 32
    call    BigAdd
    add     rsp, 32
    
continue:
    
    cmp     carry, 1
    jne     checkflag
    sub     rsp, 32
    lea     rcx, exp
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

checkflag:
    cmp     flag, 1
    je      print1
    sub     rsp, 32
    lea     rcx, num_2
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32
    jmp     leavenow

print1:
    sub     rsp, 32
    lea     rcx, num_1
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    jmp     leavenow

someerror:
    sub     rsp, 32
    lea     rcx, error
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

leavenow:
    xor     rcx, rcx
    call    ExitProcess

    leave
    ret
main endp

BigAdd proc
    push    rbp
    mov     rbp, rsp

    cmp     flag, 1
    jne     switch
    lea     rsi, num_1
    lea     rdi, num_2
    
    jmp     calculate

switch:
    lea     rsi, num_2
    lea     rdi, num_1

calculate:
    mov     first, rsi
    mov     second, rdi

    add     rsi, len1
    dec     rsi
    add     rdi, len2
    dec     rdi

B1:
    mov     cl, [rsi]
    add     cl, [rdi]
    sub     cl, 96

    cmp     carry, 1
    jne     checkoverflow
    add     cl, 1
    mov     carry, 0

checkoverflow:
    cmp     cl, 9
    jle     contcalc
    mov     carry, 1
    sub     cl, 10

contcalc:
    add     cl, '0'
    mov     [rsi], cl
    dec     rsi
    dec     rdi

    cmp     rsi, first
    jl      contcalc2
    cmp     rdi, second
    jl      contcalc2
    jmp     B1

contcalc2:
    
whiletrue:
    cmp     rsi, first
    jl      endwhile
    cmp     carry, 1
    jne     endwhile

    mov     cl, [rsi]
    add     cl, 1
    mov     carry, 0

    cmp     cl, 58
    jl      contcalc3
    sub     cl, 10
    mov     carry, 1

contcalc3:
    mov     [rsi], cl
    dec     rsi
    jmp     whiletrue

endwhile:

    leave
    ret
BigAdd endp

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