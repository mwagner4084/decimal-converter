	.file "func/other_base.S"
	.text
.global	other_base
other_base:
	; Assuming r13 is the buffer index, r14 is the base, r15 is the decimal number
	; and r4 is used for temporary storage
	mov #0, r13         ; Initialize buffer index to 0
other_base_loop:
	cmp #0, r15         ; Check if the decimal number is 0
	jeq other_base_done ; If it is, we are done
	mov r15, r4         ; Copy the decimal number to r4
	mod r14, r4         ; r4 = r4 % r14 (remainder)
	div r14, r15        ; r15 = r15 / r14 (quotient)
	; Convert remainder to ASCII and store in buffer
	; (Assuming ascii table is stored at label ascii_table)
	add r4, r4          ; Double the remainder to use as an offset
	mov @r4, r4         ; Load the ASCII character from the table
	mov.b r4, 0(r13)    ; Store the ASCII character in the buffer
	inc r13             ; Increment the buffer index
	jmp other_base_loop ; Repeat the loop

other_base_done:
	ret                 ; Return from function
