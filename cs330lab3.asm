; Wes Garner
; 02/10/2017
; v1.4
;
; CS 330 - Assignment 3
; Bit detection (LSB/MSB/Total bits set)
;
; Revision History:
; Added comments
; Rewrote from division to carry bit on shift
; Implemented MSB
; Implemented bit count
; Implemented error check for HEX 0
;

%include	"Along32.inc"
global _start

section .data
	msg0:	db	"Please enter a hexadecimal number: ", 0
	msg1:	db	"Least significant bits: ", 0
	msg2:	db	"Most significant bits: ", 0
	msg3:	db	"Total number of bits set: ", 0
	msg4:	db	"Binary representation: ", 0
	msg5:	db	"Error: Please enter a valid hex number greater than 0", 10, 0

	hex:	dd	0
	bit:	dd	32
	lsb:	dd	0
	msb:	dd	0
	tot:	dd	0

section .text

_start:
	; Request hex number
	mov edx,msg0
	call WriteString
	call ReadHex
	cmp eax, 0
	je errorexit ; error check if user typed in 0
	mov [hex],eax ; copy the hex value for MSB loop to be done after LSB loop

	xor ecx, ecx ; clear ecx before running loop count
	jmp lsbloop

lsbloop:
	; Shift the binary value to the right in order to detect the carry flag (right most being 0 or 1)
	shr eax, 1
	jc lsbend ; if carry bit is set, go to LSB end
	
	; Add 1 to the counter then restart loop
	add ecx, 1
	jmp lsbloop

lsbend:
	; Once a 1 has been detected (when odd), reset hex and continue to MSB loop
	mov eax,[hex]
	mov [lsb], ecx ; copy LSB count for results at end
	xor ecx, ecx ; clear ecx to be used for msbloop
	jmp msbloop

msbloop: 
	; Shift the binary value to the left in order to detect the carry flag (left most being 0 or 1)
	shl eax, 1
	jc msbend ; if carry bit is set, go to MSB end
	
	; Add 1 to the counter then restart loop
	add ecx, 1
	jmp msbloop

msbend:
	; Once a 1 has been detected (when odd), reset hex and continue to total bit count
	mov eax,[hex]
	mov [msb], ecx ; copy MSB count for results at end
	xor ecx, ecx ; clear ecx to use for next count
	mov edx, [bit] ; create new count to be used to count all 32 bits
	jmp totbits

totbits:
	; Shift the binary value right to detect carry flag then continue loop until all 32 bits are detected
	shr eax, 1
	jc totcnt
	jmp totloop ; restart loop and check if all bits complete

	
totcnt:
	; Bit was set so add to count and send back to loop starter
	add ecx, 1
	jmp totloop

totloop:
	; Decrease bits and check if done
	mov [tot], ecx ; copy total count
	sub edx, 1 ; subtract from 32
	cmp edx, 0 ; check to see if all bits are complete
	je exit
	
	jmp totbits ; restart loop as not complete

errorexit:
	; Invalid hex number was entered, exiting but also giving results to screen since should be valid as 0s
	mov edx, msg5
	call WriteString
	jmp exit

exit:
	; Announce results

	; Send binary equivalent to screen
	mov edx, msg4
	call WriteString
	mov eax, [hex]
	call WriteBin
	call Crlf

	; Least significant
	mov edx, msg1
	call WriteString
	mov eax, [lsb]
	call WriteDec
	call Crlf

	; Most significant
	mov edx, msg2
	call WriteString
	mov eax, [msb]
	call WriteDec
	call Crlf

	; Total number of bits set
	mov edx, msg3
	call WriteString
	mov eax, [tot]
	call WriteDec
	call Crlf

	mov eax, 01h 	; exitC)
	mov ebx, 0h 	; errno

	int 80h
