; Wes Garner
; 03/14/2017
; v1.0
;
; CS 330 - Assignment 5
; Quadratic Formula
;
; Revision History:
; Added comments
;

%include	"Along32.inc"
extern		printf

global _start

section .data
	msg1:	db	"Please enter A: ", 0
	msg2:	db	"Please enter B: ", 0
	msg3:	db	"Please enter C: ", 0

	vara:	dd	0
	varb:	dd	0
	varc:	dd	0

	varx1:	dd	0 ; (-b-sqrt(b*b-4*a*c))/(2*a)
	varx2:	dd	0 ; (-b+sqrt(b*b-4*a*c))/(2*a)
	todo:	dw	0

section .text

_start:
	; Gather variables A, B, C
	mov edx, msg1
	call WriteString
	call ReadInt
	mov [vara], eax

	mov edx, msg2
	call WriteString
	call ReadInt
	mov [varb], eax

	mov edx, msg3
	call WriteString
	call ReadInt
	mov [varc], eax

	; Calculate 2*a
	;fild qword [vara]
	;mov word[todo], 2
	;fimul word[todo]
	;fstp qword[varx1]

	push dword[vara]
	;push dword[varx1]
	call printf

exitmsg:
	; Announce results
	mov edx, msg2
	mov ebx, 0
	mov eax, 0
	call WriteString

exit:
	mov eax, 01h 	; exitC)
	mov ebx, 0h 	; errno

	int 80h

