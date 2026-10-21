; Print the third MultiPlayer 5 warning line, centered.
PrintMP5Line3:						; called from ShowMP5Warning
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintMP5Line3Pos>>16
	sta.b a1+2
	lda.w #PrintMP5Line3Pos
	sta.b a1
	jsl.l print						; print PrintMP5Line3Pos
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra PrintCentered
