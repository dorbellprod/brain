;;
;			BRAINFUCK INTERPRETER
;;
;		Registers:
;			RAX				Instruction pointer
;			RBX				Working address
;			RCX				Tape pointer
;;
%include "./subs.inc"

section .data
	test_program db "-[------->+<]>-.-[->+++++<]>++.+++++++..+++.[->+++++<]>+.------------.>-[--->+<]>-.[---->+++++<]>-.---.+++++++++++++.-------------.--[--->+<]>.[--->+<]>-.", 0

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
	cmp byte [rax], 18				; Skip if whitespace.
	jl _iterate
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
	cmp byte [rax], ','
	je _input
	cmp byte [rax], '['
	je _loop_open
	cmp byte [rax], ']'
	je _loop_close

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

_wrap_up:
	mov rcx, tape_last
	jmp _iterate

_wrap_down:
	mov rcx, tape
	jmp _iterate

_plus:
	inc byte [rcx]
	jmp _iterate

_minus:
	dec byte [rcx]
	jmp _iterate

_print:
	print rcx, 1
	jmp _iterate

_input:
	push rax
	push rcx

	input rcx, 1

	pop rcx
	pop rax

	jmp _iterate
_loop_open:
	mov rbx, 0							; Clear RBX for no reason
	push rax 								; Push current pointer address
	inc qword [rsp]					; ... + 1, meaning next instruction
	jmp _iterate
	
_loop_close:
	pop rbx									; Pop last loop addr into rbx
	cmp byte [rcx], 0				; Check current cell
	je _iterate							; If not 0, execute loop reset

	mov rax, rbx						; Set IP to popped address
	push rbx								; Push popped address
	jmp loop								; Continue interpreting
_iterate:
	inc rax
	cmp byte [rax], 0
	je stop
	jmp loop
stop:
	exit
