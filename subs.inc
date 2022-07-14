SYS_READ equ 0
SYS_WRITE equ 1

%macro print 2
	push rax
	push rcx
	mov rsi, %1
	mov rdx, %2
	call io_print
	pop rcx
	pop rax
%endmacro

%macro input 2
	push rax
	push rcx

	mov rsi, %1
	mov rdx, %2
	call io_input

	pop rcx
	pop rax
%endmacro

%macro exit 0
	call sys_exit
%endmacro

%macro print_auto 1
	push rax
	push rcx
	mov rax, %1
	push rax
	
	mov rbx, 0
	mov rcx, 0
_print_auto_loop:
	inc rax
	inc rbx
	mov cl, [rax]
	cmp cl, 0
	jne _print_auto_loop
	
	mov rsi, %1
	mov rdx, rbx
	call io_print

	pop rcx
	pop rax
%endmacro

io_print:
	mov rax, 1
	mov rdi, 1
	syscall
	ret
io_input:
	mov rax, 0
	mov rdi, 0
	syscall
	ret

sys_exit:
	mov rax, 60
	mov rdi, 0
	syscall
