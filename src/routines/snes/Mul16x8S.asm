; X (16 bits) * A (8 bits) into $08-$0A, both signed
Mul16x8S:							; called from checkplcoll, doplayeracc, wallcoll
	phy
	tay
	beq Mul16x8_Zero
	bpl Mul16x8XS_neg
	eor.w #$FFFF					; negate: two's complement
	inc a
	tay
	txa
	beq Mul16x8_Zero
	bpl Mul16x8XS_mul
	eor.w #$FFFF					; negate: two's complement
	inc a
	jmp.w Mul16x8U_go
org $809002
