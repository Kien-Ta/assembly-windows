option casemap:none					; phan biet chu hoa/thuong

GetStdHandle proto					; khai bao nguyen mau ham
WriteFile proto
ExitProcess proto

.data								; section du lieu duoc khoi tao
	text	db	"Hello World!", 0	; khoi tao string
	msg_len	equ	$ - text			; do dai string khoi tao

.const								; section bien hang
	NULL	equ 0					
	STD_OUTPUT_HANDLE	equ	-11

.code								; section chua ma lenh thuc tin
main proc
	push	rbp						; stack frame moi 
	mov		rbp, rsp

	sub		rsp, 32					; shadow space - x64 calling convention
	mov		rcx, STD_OUTPUT_HANDLE	; thu tu rcx - rdx - r8 - r9, con lai de len stack
	call	GetStdHandle			; lay handle dau vao (console)
	add		rsp, 32					; khoi phuc lai stack

	push	0
	sub		rsp, 32	
	mov		rcx, rax
	lea		rdx, text
	mov		r8, msg_len
	mov		r9, NULL
	call	WriteFile				; in string ra console
	add		rsp, 40

	xor		rcx, rcx
	call	ExitProcess				; ket thuc chuong trinh

	leave
	ret
main endp
end
	