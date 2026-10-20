; A * X into $08-$0B, X signed
Mul16XS:							; called from dopass_count, pucknorm_move
	phy
	tay
	beq Mul16_Zero
Mul16XS_TestX:						; called from Mul16S
	sta.b r0
	txa
	beq Mul16_Zero
	bpl Mul16U_Go
	eor.w #$FFFF					; negate: two's complement
	inc a
Mul16XS_Neg:						; called from Mul16S
	jsl.l Mul16U_Pre
	jmp.w Mul16x8XS_negres
