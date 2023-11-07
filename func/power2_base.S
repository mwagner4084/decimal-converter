	.file "func/power2_base.S"
	.text
.global	power2_base
power2_base:
	; Assuming r13 is the buffer index, r14 is the base, r15 is the decimal number
	; and r4 is used for temporary storage
	mov #0, r13         ; Initialize buffer index to 0
power2_base_loop:
	cmp #0, r15         ; Check if the decimal number is 0
	jeq power2_base_done; If it is, we are done
	mov r14, r4         ; Copy the base to r4
	call #log_2         ; Calculate log base 2 of the base
	mov r15, r12        ; Copy the decimal number to r12
	and r4, r12         ; r12 = r12 & r4 (mask)
	rra r4              ; r4 = r4 >> 1 (shift to get the mask)
	ror r15             ; r15 = r15 >> r4 (shift right by mask bits)
	; Convert masked value to ASCII and store in buffer
	; (Assuming ascii table is stored at label ascii_table)
	add r12, r12        ; Double the masked value to use as an offset
	mov @r12, r12       ; Load the ASCII character from the table
	mov.b r12, 0(r13)   ; Store the ASCII character in the buffer
	inc r13             ; Increment the buffer index
	jmp power2_base_loop; Repeat the loop

power2_base_done:
	ret                 ; Return from function
