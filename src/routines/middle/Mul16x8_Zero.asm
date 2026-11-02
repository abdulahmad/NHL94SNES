; Product 0 into $08-$0A
Mul16x8_Zero:						; called from Mul16x8S, Mul16x8U, Mul16x8XS, Mul16x8XS_neg
	stz.b r2
	stz.b r2+2
	ply
	rtl
