option casemap:none

WriteFile proto
GetStdHandle proto
ExitProcess proto
ReadFile proto
SetConsoleMode proto

.data
    temp_addr   QWORD   0

    hInput  QWORD   0
    bToRead QWORD   0

    hOutput QWORD   0
    sl      QWORD   0

.data?
	text	db	512	dup(?)

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
    lea     rcx, text
    mov     temp_addr, rcx
    call    StdIn
    add     rsp, 32

    sub     rsp, 32
    call    Rev
    add     rsp, 32

    sub     rsp, 32
    lea     rcx, text
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

    xor     rcx, rcx
    call    ExitProcess

    leave
    ret
main endp

Rev proc
    push    rbp
    mov     rbp, rsp

    lea     rsi, text
    lea     rdi, text
    dec     rdi

find_end:
    inc     rdi
    mov     cl, [rdi]
    cmp     cl, 0
    jne     find_end
    dec     rdi

swap:
    cmp     rsi, rdi
    jge     finished

    mov     cl, [rsi]
    mov     dl, [rdi]
    mov     [rsi], dl
    mov     [rdi], cl

    inc     rsi
    dec     rdi
    jmp     swap

finished:
    leave
    ret
Rev endp


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