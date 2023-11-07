	.file "func/rshift.S"
	.text
.global rshift
rshift:
	; Assuming r15 is the value and r14 is the amount to shift
rshift_loop:
	cmp #0, r14         ; Check if the shift amount is 0
	jeq rshift_done     ; If it is, we are done
	rar r15             ; Right arithmetic shift
	dec r14             ; Decrement the shift amount
	jmp rshift_loop     ; Continue the loop

rshift_done:
	ret                 ; Return from function
