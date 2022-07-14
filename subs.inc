
%macro print 2
	push rax
	push rcx
	mov rsi, %1
	mov rdx, %2
	call io_print
	pop rcx
	pop rax
%endmacro

%macro exit 0
	call sys_exit
%endmacro
io_print:
	mov rax, 1
	mov rdi, 1
	syscall
	ret

sys_exit:
	mov rax, 60
	mov rdi, 0
	syscall

