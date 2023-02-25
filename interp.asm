section .text
global _start
_start:
	mov rbx, memoryStart
	mov rcx, codeStart

execLoop:
	cmp rcx, codeEnd
	je	exit
	mov al, [rcx]
	cmp al, '+'
	je plus
	cmp al, '-'
	je minus
	cmp al, '.'
	je period
	cmp al, ','
	je comma
	cmp al, '['
	je openBracket
	cmp al, ']'
	je closeBracket
	cmp al, '<'
	je leftAngle
	cmp al, '>'
	je rightAngle

	inc rcx
	jmp execLoop

exit:
	mov rax, 1
	mov rbx, 0
	int 0x80

plus:
	mov al, [rbx]
	inc al
	mov [rbx], al
	inc rcx
	jmp execLoop

minus:
	mov al, [rbx]
	dec al
	mov [rbx], al
	inc rcx
	jmp execLoop

period:
	push rcx
	push rbx
	mov rcx, rbx
	mov rdx, 1
	mov rax, 4
	mov rbx, 1
	int 0x80
	pop rbx
	pop rcx
	inc rcx
	jmp execLoop

comma:
	push rcx
	push rbx
	mov rcx, rbx
	mov rdx, 1
	mov rax, 3
	mov rbx, 0
	int 0x80
	pop rbx
	pop rcx
	inc rcx
	jmp execLoop

openBracket:
	mov al, [rbx]
	cmp al, 0
	je	openBracketZeroCase

	push rcx
	inc rcx
	jmp execLoop
openBracketZeroCase:
	mov rdx, 1
	inc rcx
openBracketLoop:
	cmp rcx, codeEnd
	je	exit
	mov al, [rcx]
	cmp al, '['
	je	openBracketCase1
	cmp al, ']'
	je	openBracketCase2
	inc rcx
	jmp openBracketLoop
openBracketCase1:
	inc rdx
	inc rcx
	jmp openBracketLoop
openBracketCase2:
	dec rdx
	inc rcx
	cmp rdx, 0
	je	execLoop
	jmp openBracketLoop

closeBracket:
	mov al, [rbx]
	cmp al, 0
	je	closeBracketZeroCase
	pop rcx
	jmp execLoop
closeBracketZeroCase:
	pop rax
	inc rcx
	jmp execLoop

leftAngle:
	dec rbx
	cmp rbx, memoryStart
	jl	leftAngleLoopAround
	inc rcx
	jmp execLoop
leftAngleLoopAround:
	mov rbx, memoryEnd-1
	inc rcx
	jmp execLoop

rightAngle:
	inc rbx
	cmp rbx, memoryEnd
	je	rightAngleLoopAround
	inc rcx
	jmp execLoop
rightAngleLoopAround:
	mov rbx, memoryStart
	inc rcx
	jmp execLoop

section .data
codeStart:
	db ">++++++++[<+++++++++>-]<.>++++[<+++++++>-]<+.+++++++..+++.>>++++++[<+++++++>-]<++.------------.>++++++[<+++++++++>-]<+.<.+++.------.--------.>>>++++[<++++++++>-]<+." ;; hello world
codeEnd:

memoryStart:
	times 30000 db 0
memoryEnd:

singleCharMsg:
db 0
