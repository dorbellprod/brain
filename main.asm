;;
;			BRAINFUCK INTERPRETER
;;
;		Registers:
;			RAX				Instruction pointer
;			BL				Working byte
;			RCX				Tape pointer
;;
%include "./subs.inc"

section .data
	msg db "WORKS!!", 10
	msg_2 db "BRUHH!!", 10
	debug_len equ $-msg

	test_program db "<+++++++++++++++++++++++++++++++++.>++++++++++.", 0

section .bss
	tape resb 		30000
	tape_last equ tape + 29999
section .text
	global _start
_start:
	mov rax, tape
	mov rbx, 30000
init_loop:
	mov [rax], byte 0
	dec rbx
	cmp rbx, 0
	jne init_loop

; -- Interpreter --
interpreter:
	mov rax, test_program
	mov rcx, tape

loop:
	cmp byte [rax], '>'
	je _right
	cmp byte [rax], '<'
	je _left

	cmp byte [rax], '+'
	je _plus
	cmp byte [rax], '-'
	je _minus
	cmp byte [rax], '.'
	je _print

	jmp stop

_right:
	inc rcx
	cmp rcx, qword tape_last + 1
	je _wrap_down
	jmp _iterate
_left:
	dec rcx
	cmp rcx, qword tape - 1
	je _wrap_up
	jmp _iterate

; TODO: Debug wrap labels, ensure they work.
_wrap_up:
	mov rcx, tape_last
	jmp _iterate
_wrap_down:
	mov rcx, tape
	jmp _iterate
_plus:
	inc byte [rcx]
	mov bl, byte [rcx]
	jmp _iterate
_minus:
	dec byte [rcx]
	mov bl, byte [rcx]
	jmp _iterate
_print:
	mov bl, byte [rcx]
	print rcx, 1
	jmp _iterate
_iterate:
	inc rax
	cmp byte [rax], 0
	je stop
	jmp loop
stop:
	exit

; ---** SUBROUTINES **--- ; 
; ----------------------- ;


debug_log:
	print msg, 8
	ret

debug_log_2:
	print msg_2, 8
	ret
; ----------------------- ; 
; ----------------------- ;
