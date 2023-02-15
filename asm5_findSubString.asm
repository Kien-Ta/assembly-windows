option casemap:none

WriteFile proto
GetStdHandle proto
ExitProcess proto
ReadFile proto
SetConsoleMode proto

.data
    error   db  "Loi dau vao", 0
    len_s   QWORD   0
    len_t   QWORD   0
    i       BYTE    0
    j       BYTE    0
    num     QWORD   0
    incre   QWORD   10
    linenew     db      13, 10, 0
    spac        db      32

    leng    QWORD   0

    hInput  QWORD   0
    bToRead QWORD   0

    hOutput QWORD   0
    sl      QWORD   0

    temp_addr   QWORD 0

.data?
    source  db  512 dup(?)
    target  db  512 dup(?)
    lps     db  512 dup(?)
    result  db  512 dup(?)
    temp    db  1   dup(?)

    temp2   db  512 dup(?)

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
    lea     rcx, source
    mov     temp_addr, rcx
    call    StdIn
    add     rsp, 32
    mov     len_s, rax

    sub     rsp, 32
    lea     rcx, target
    mov     temp_addr, rcx
    call    StdIn
    add     rsp, 32
    mov     len_t, rax

    cmp     len_s, 0
    je      printerror
    cmp     len_t, 0
    je      printerror
    cmp     len_s, 100
    jg      printerror
    cmp     len_t, 10
    jg      printerror

    mov     rax, len_s
    cmp     rax, len_t
    jl      printerror

    sub     rsp, 32
    call    CreateLps
    add     rsp, 32

    mov     rax, 0
    mov     rbx, 0
    lea     rsi, result

whiletrue:
	cmp	    rax, len_s
	jnl	    endwhile

	mov	cl, source[rax]


	cmp	    cl, target[rbx]
	jne	    else1

	inc	    rax
	inc	    rbx


	cmp	    rbx, len_t
	jne	    whiletrue
	
	mov	    rcx, rax
	sub	    rcx, rbx

if3:
	cmp	    rcx, 0
	je	    else3
	
	mov	    [rsi], cl
	jmp	    if2_cont

else3:
	mov	    rcx, 255
	mov	    [rsi], cl

if2_cont:
	inc	    rsi
	inc	    num
	jmp	    whiletrue
	

else1:
	
if4:
	cmp	    rbx, 0
	je	    else4

if5:
	cmp	    rbx, 1
	je	    else5

	mov	    bl, lps[rbx - 1]
	jmp 	whiletrue	

else5:
	mov	    bl, 0
	jmp	    whiletrue

else4:
	inc	    rax
	jmp	    whiletrue

endwhile:

    mov     rax, num
    sub     rsp, 32
    call    Display
    add     rsp, 32

    sub     rsp, 32
    mov     rcx, getstdout
    call    GetStdHandle
    add     rsp, 32

    push    0
    sub     rsp, 32
    mov     rcx, rax
    lea     rdx, total_str
    mov     r8, leng
    mov     r9, NULL
    call    WriteFile
    add     rsp, 40

    sub     rsp, 32
    mov     rcx, getstdout
    call    GetStdHandle
    add     rsp, 32

    push    0
    sub     rsp, 32
    mov     rcx, rax
    lea     rdx, linenew
    mov     r8, 3
    mov     r9, NULL
    call    WriteFile
    add     rsp, 40

    lea     rsi, result

whiletrue2:
    cmp     num, 0
    je      endwhile2

    xor     rax, rax
    mov     al, BYTE PTR [rsi]

    cmp     rax, 255
    jne     continuewhile
    mov     temp, '0'

    sub     rsp, 32
    mov     rcx, getstdout
    call    GetStdHandle
    add     rsp, 32

    push    0
    sub     rsp, 32
    mov     rcx, rax
    lea     rdx, temp
    mov     r8, 1
    mov     r9, NULL
    call    WriteFile
    add     rsp, 40
    jmp     incsomestuff

continuewhile:
    sub     rsp, 32
    call    Display
    add     rsp, 32

    sub     rsp, 32
    mov     rcx, getstdout
    call    GetStdHandle
    add     rsp, 32

    push    0
    sub     rsp, 32
    mov     rcx, rax
    lea     rdx, total_str
    mov     r8, leng
    mov     r9, NULL
    call    WriteFile
    add     rsp, 40

incsomestuff:
    dec     num
    add     rsi, 1

    sub     rsp, 32
    mov     rcx, getstdout
    call    GetStdHandle
    add     rsp, 32

    push    0
    sub     rsp, 32
    mov     rcx, rax
    lea     rdx, spac
    mov     r8, 1
    mov     r9, NULL
    call    WriteFile
    add     rsp, 40

    jmp     whiletrue2

endwhile2:
    jmp     exitnow


printerror:
    sub     rsp, 32
    lea     rcx, error
    mov     temp_addr, rcx
    call    StdOut
    add     rsp, 32

exitnow:
    xor     rcx, rcx
    call    ExitProcess

    leave
    ret
main endp

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

	leave
	ret
Display endp

CreateLps proc
    push    rbp
    mov     rbp, rsp

    mov     lps[0], 255

    mov     rbx, 0
    mov     rax, 1

whiletrue3:
    cmp     rax, len_t
    jnl     endwhile

    mov     cl, target[rax]

    cmp     cl, target[rbx]
    jne     elseCreateLps
    inc     rbx
    mov     lps[rax], bl
    inc     rax
    jmp     whiletrue3

elseCreateLps:
    cmp     rbx, 0
    je      elseCreateLps2
    mov     bl, lps[rbx - 1]

    jmp     whiletrue3

elseCreateLps2:
    mov     lps[rax], 0
    inc     rax
    jmp     whiletrue3

endwhile:

    leave
    ret
CreateLps endp

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