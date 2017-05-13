; Wes Garner
; 02/24/2017
; v1.2
;
; CS 330 - Assignment 4
; Integer array sort
;
; Revision History:
; Original version - linear search
; Fixed negative numbers via dword push/pop
; Corrected bad variable in .data causing memory overflow
; Added comments
;

; TA: Asli acamlica@uab.edu

%include	"Along32.inc"
%define ARRAY_SIZE 150

global _start

section .data
	msg0:	db	"Please enter an array of numbers to sort (end with 0): ", 0
	msg1:	db	"Continuing with calculation", 10, 0
	msg2:	db	"Sorted Array: ", 0
	msg3:	db	"Error: No values were entered", 10, 0
	msg4:	db	"Error: Too many values to calculate", 10, 0

	count:	db	0

section .bss
	array	resd	ARRAY_SIZE

section .text

_start:
	mov ecx, 0 ; ensure register is set to 0 so can increment
	jmp startloop

startloop:
	; Request numbers
	mov edx, msg0
	call WriteString
	call ReadInt

	cmp eax, 0
	je endloop ; end the loop if 0 is entered

	inc ecx
	cmp ecx, ARRAY_SIZE
	jg arrayoverflow ; too many values were entered

	; The total number of integers entered is incremented by 1
	; Since we are working with array 0...N, must be decremented to store then incremented
	dec ecx
	mov [array + 8*ecx], eax ; store number into array
	inc ecx

	jmp startloop

endloop:
	; Ending the loop as 0 was entered
	; Error check
	cmp ecx, 0
	je arrayempty ; no values were entered

	mov [count], ecx ; set variable to total number of integers
	call Crlf
	mov edx, msg1
	call WriteString


	jmp linsort ; perform linear sort


linsort:
	mov ebx, 1 ; set j to 1
	mov ecx, [count]

linloop1:
	cmp ecx, ebx
	je exitloop ; exit loops if all integers have been sorted

	mov eax, [array + 8*ebx] ; key

	mov edx, ebx
	dec edx ; i is j-1

linloop2: 
	cmp edx, -1
	je finloop2 ; if i<0, exit while loop
	cmp eax, [array + 8*edx]
	jg finloop2 ; if key is less than equal to array value

	push dword [array + 8*edx]
	inc edx ; move position to one spot higher
	pop dword [array + 8*edx]
	dec edx ; return i to normal value
	dec edx ; decrease by one and repeat loop
	
	jmp linloop2

finloop2:
	inc edx ; move key position up 1
	mov [array + 8*edx], eax
	
	inc ebx
	jmp linloop1

exitloop:
	; Announce results
	mov edx, msg2
	call WriteString

	; Loop the sorted string
	mov ecx, 0 ; counter until equals count

intloop:
	cmp ecx, [count]
	je exit ; exit once all integers have been sent to screen
	
	mov eax, [array + 8*ecx]
	call WriteInt

	inc ecx
	jmp intloop

arrayempty:
	mov edx, msg3
	call WriteString
	jmp exit

arrayoverflow:
	mov edx, msg4
	call WriteString
	jmp exit

exit:
	call Crlf
	mov eax, 01h 	; exitC)
	mov ebx, 0h 	; errno

	int 80h
