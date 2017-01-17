; name goes here
; date of initial writing
; revision history
;
; name of program
; purpose
;

global main
section .data

section .text

main:
	; your code goes here
	
	
	; last line of code
	jmp exit
	
exit:
	mov eax, 01h 	; exitC)
	mov ebx, 0h 	; errno

	int 80h

