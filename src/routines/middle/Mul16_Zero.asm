; The zero result of the Mul16 forms: $08-$0B = 0, pull Y
Mul16_Zero:							; called from Mul16S, Mul16U, Mul16XS, Mul16XS_TestX
	stz.b r2
	stz.b r2+2
	ply
	rtl
