; A * X into $08-$0B, both signed
Mul16S:								; called from CalcAngleOffset, PenBoxSpot, PulseColour, checkgoal, dosh...
	phy
	tay
	beq Mul16_Zero
	bpl Mul16XS_TestX
	eor.w #$FFFF					; negate: two's complement
	inc a
	tay
	sta.b r0
	txa
	beq Mul16_Zero
	bpl Mul16XS_Neg
	eor.w #$FFFF					; negate: two's complement
	inc a
	bra Mul16U_Go
