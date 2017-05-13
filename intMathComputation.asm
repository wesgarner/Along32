; Wes Garner
; 01/20/2017
; v1.2
;
; CS 330 - Assignment 1
; Math computation on two integers:
; A*B - (A+B) / (A-B)
;
; Revision History:
; 1.1 - Added divide by zero error
; 1.2 - Added how to work with remainder
;

%include	"Along32.inc"
global _start

section .data
	msg1:	db	"Enter first integer: ", 0
	msg2:	db	"Enter second integer: ", 0
	msg3:	db	"Result: ", 0
	msg4:	db	"Error: Unable to complete computation as would cause a divide by zero", 10, 0
	msg5:	db	"Subtract this remainder: ", 0
	msg6:	db	" / ", 0
	num1:	dd	0
	num2:	dd	0
	res1:	dd	0
	res2:	dd	0
	res3:	dd	0
	res4:	dd	0
	final:	dd	0
	remain:	dd	0

section .text

_start:
	; Request first integer
	mov edx,msg1
	call WriteString
	call ReadInt
	mov [num1],eax

	; Request second integer
	mov edx,msg2
	call WriteString
	call ReadInt
	mov [num2],eax

	; Complete mathematics
	; Arithmetic: A*B (stored into res1)
	mov eax,[num1]
	mov edx,[num2]
	mul edx
	mov [res1],eax

	; Arithmetic: A+B (stored into res2)
	mov eax,[num1]
	add eax,[num2]
	mov [res2],eax

	; Arithmetic: A-B (stored into res3)
	mov eax,[num1]
	sub eax,[num2]
	mov [res3],eax

	; Ensure (A-B) != 0
	cmp eax,0
	je divzero
	
	; Arithmetic: (A+B) / (A-B) ... aka res2/res3 (stored into res4)
	xor edx, edx
	mov eax,[res2]
	mov ebx,[res3]
	idiv ebx
	mov [res4],eax
	mov [remain],edx

	; Arithmetic: A*B - (A+B) / (A-B) ... aka res1-res4 (stored into final)
	mov eax,[res1]
	sub eax,[res4]
	mov [final],eax

	; Write result to console
	mov edx,msg3
	call WriteString
	mov eax,[final] ; Though unnecessary as still stored in aex, done just for ease of understanding
	call WriteInt
	call Crlf

	; If there is a remainder, show a note about the remainder
	mov eax,[remain]
	cmp eax,0
	jne remainder
		
	jmp exit
	
divzero:
	; Display error as completion would cause divide by zero
	mov edx,msg4
	call WriteString

	jmp exit

remainder:
	; Display note that there was a remainder that needs to be subtracted
	; Remainder is: remain/res3(A-B) and should be subtracted from final
	mov edx,msg5
	call WriteString
	mov eax,[remain]
	call WriteInt
	mov edx,msg6
	call WriteString
	mov eax,[res3]
	call WriteInt
	call Crlf

	jmp exit

exit:
	mov eax, 01h 	; exitC)
	mov ebx, 0h 	; errno

	int 80h
