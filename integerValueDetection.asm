; Wes Garner
; 04/02/2017
; v1.1
;
; CS 330 - Assignment 6
; Detect pos/neg/zero numbers
;
; Revision History:
; Added comments
; Fixed zero logic code
;
; Note: Used code from assignment 3 to find most significant bit

%include	"Along32.inc"
global _start

section .data
	msg0:	db	"Please enter a number: ", 0
	msg1:	db	"Number of positive numbers: ", 0
	msg2:	db	"Number of negative numbers: ", 0
	msg3:	db	"Number of zeros: ", 0

	bit:	dd	32
	pos:	dd	0
	neg:	dd	0
	zero:	dd	0
	count:	dd	0

section .text

_start:
	; Request integer
	jmp startloop

startloop:
	mov edx, msg0
	call WriteString
	call ReadInt
	
	mov edx, [bit]
	shl eax, 1
	jc negnum ; if carry bit is set, number is negative
	jmp checknum ; if carry bit is not set, check to see if number is positive or 0

checknum:
	; Decrease bits and check if done
	dec edx ; subtract from 32
	cmp edx, 0 ; check to see if all bits are complete
	je zeronum
	
	jmp shiftbit ; restart loop as not complete

shiftbit:
	; Shift the binary value right to detect carry flag then continue loop until all 32 bits are detected
	shr eax, 1
	jc posnum
	jmp checknum ; restart loop and check if all bits complete

posnum:
	mov ebx, [pos]
	inc ebx
	mov [pos], ebx
	mov ecx, 0 ; reset 0 counter
	jmp startloop

negnum:
	mov ebx, [neg]
	inc ebx
	mov [neg], ebx
	mov ecx, 0 ; reset 0 counter
	jmp startloop
	

zeronum:
	cmp ecx, 1
	je stoploop ; if two 0's have been input, stop the loop
	inc ecx ; ecx is 1, if runs again then loop is complete

	mov ebx, [zero]
	inc ebx
	mov [zero], ebx
	jmp startloop

stoploop:
	mov ebx, [zero]
	dec ebx ; decrease the number of 0's detected as the combo of two in a row is to be ignored
	mov [zero], ebx
	jmp exit

exit:
	; Announce results

	; Number of positive numbers
	mov edx, msg1
	call WriteString
	mov eax, [pos]
	call WriteDec
	call Crlf

	; Number of negative numbers
	mov edx, msg2
	call WriteString
	mov eax, [neg]
	call WriteDec
	call Crlf

	; Number of zeros
	mov edx, msg3
	call WriteString
	mov eax, [zero]
	call WriteDec
	call Crlf

	mov eax, 01h 	; exitC)
	mov ebx, 0h 	; errno

	int 80h
