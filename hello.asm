	;;  This is just for demonstration purposes
	;;  This isn't even close to an acceptable format for an actual assignment, I'm sure.
	

%include "Along32.inc"                ; Don't forget this. You will regret it.
	
section .data
	hello: db 'Hello world', 10,0 ; 10 is the newline character.
section .text
	global _start

_start:
	mov edx, hello
	call WriteString
	
	mov eax, 1
	mov ebx, 2
	mov ecx, 3
	mov edx, 4
	
	call DumpRegs
	
	mov eax, 1		      ; System Exit
	int 0x80
	

	
	
