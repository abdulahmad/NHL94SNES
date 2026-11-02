; The zero result of the Mul16x8Hi forms: $09 = 0, pull Y
Mul16x8Hi_Zero:						; called from Mul16x8HiS, Mul16x8HiU, Mul16x8HiXS, Mul16x8HiXS_TestX
	stz.b r2+1
	ply
	rtl
