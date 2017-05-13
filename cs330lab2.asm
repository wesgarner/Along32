; Wes Garner
; 01/23/2017
; v1.2
;
; CS 330 - Assignment 2
; Average number computation on N amount of integers:
;
; Revision History:
; Added comments
; Corrected negative number equation
;

%include	"Along32.inc"
global _start

section .data
	msg0:	db	"This application will average a set of integers. Input 0 to move on to the next step.", 10, 0
	msg1:	db	"Enter an integer: ", 0
	msg2:	db	"Average: ", 0
	msg3:	db	"Subtract this remainder: ", 0
	msg4:	db	" / ", 0
	msg5:	db	"Number of integers: ", 0
	count:	dd	0
	total:	dd	0
	remain:	dd	0

section .text

_start:
	; Begin loop of requesting integers to average
	mov edx,msg0
	call WriteString
	jmp requestint

	jmp exit
	
requestint:
	; Request integer and check to see if 0 (continue if so)
	mov edx,msg1
	call WriteString
	call ReadInt
	cmp eax,0
	je continue

	; Add integer to total
	mov edx,[total]
	add edx,eax
	mov [total],edx
	
	; Add +1 to count
	mov eax,[count]
	add eax,1
	mov [count],eax
	mov eax,[count]

	; Repeat
	jmp requestint

continue:
	; Calculate the average
	mov eax,[total]
	mov ebx,[count]
	xor edx, edx ; Clear edx register so that divide can complete properly
	cdq ; Convert 32-bit integer to 64-bit eax:edx for signed equation
	idiv ebx
	mov [total],eax
	mov [remain],edx
	
	; Send results to console
	mov edx,msg5 ; Number of integers
	call WriteString
	mov eax,[count]
	call WriteInt
	call Crlf
	mov edx,msg2 ; Results
	call WriteString
	mov eax,[total]
	call WriteInt
	call Crlf

	; If there is a remainder, show a note about the remainder
	mov eax,[remain]
	cmp eax,0
	jne remainder
	
	jmp exit

remainder:
	; Display note that there was a remainder that needs to be subtracted
	mov edx,msg3
	call WriteString
	mov eax,[remain]
	call WriteInt
	mov edx,msg4
	call WriteString
	mov eax,[count]
	call WriteInt
	call Crlf

	jmp exit


exit:
	mov eax, 01h 	; exitC)
	mov ebx, 0h 	; errno

	int 80h
