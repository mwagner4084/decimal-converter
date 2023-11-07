	.file "func/log_2.S"
	.text
.global log_2
log_2:
	; Assuming r15 has the value for which we need to find log base 2
	clr r12             ; Clear r12 to use as a counter
log_2_loop:
	cmp #1, r15         ; Compare the value with 1
	jz log_2_done       ; If it's 1, we're done
	rar r15             ; Right arithmetic shift
	inc r12             ; Increment the counter
	jmp log_2_loop      ; Continue the loop

log_2_done:
	mov r12, r15        ; Move the result to r15
	ret                 ; Return from function
