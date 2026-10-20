; A * X, 8 by 8 bits, both signed, into A
Mul8S:								; called from ReplayMode, checkgoalp, chk4shot, doplayeracc, playeracc...
	phy
	tay
	bpl Mul8XS_x
	txa
	bpl Mul8S_swap
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.w WRMPYA
	tya
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.w WRMPYB
	bra Mul8U_res
