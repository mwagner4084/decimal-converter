	.file "func/convert.S"
	.text
.global convert
convert:
	; Check if base is a power of 2 (2, 4, 8, 16, 32, 64)
	mov r14, r12        ; Copy base to another register for manipulation
	call #log_2         ; Calculate log base 2 of the base
	cmp #8, r15         ; Compare result with 8 (log2(256) = 8)
	jeq base_256_call   ; If equal, it's base 256
	jnc other_base_call ; If carry is not set, it's not a power of 2

power2_base_call:
	call #power2_base   ; Call power2_base function
	jmp done            ; Jump to done after function call

base_256_call:
	call #base_256      ; Call base_256 function
	jmp done            ; Jump to done after function call

other_base_call:
	call #other_base    ; Call other_base function

done:
	ret                 ; Return from function
