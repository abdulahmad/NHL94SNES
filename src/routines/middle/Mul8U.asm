; A * X, 8 by 8 bits, unsigned, into A
Mul8U:								; called from CalcAttrib, CalcPuckDistances, DrawPlayerPicture, InProgr...
	phy
Mul8U_mul:							; called from Mul8XS_x
	sep #$30
	sta.w WRMPYA
	stx.w WRMPYB
	rep #$30
Mul8U_res:							; called from Mul8S
	nop
	lda.w RDMPYL
	ply
	rtl
