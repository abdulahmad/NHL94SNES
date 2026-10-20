; X * A (low byte) / 256 into A and $09, X signed
Mul16x8HiXS:						; called from updateplayers
	phy
	tay
	beq Mul16x8Hi_Zero
Mul16x8HiXS_TestX:					; called from Mul16x8HiS
	txa
	beq Mul16x8Hi_Zero
	bpl Mul16x8HiU_Go
	eor.w #$FFFF					; negate: two's complement
	inc a
Mul16x8HiXS_Neg:					; called from Mul16x8HiS
	jsl.l Mul16x8HiU_Pre
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b r2+1
	ply
	rtl
