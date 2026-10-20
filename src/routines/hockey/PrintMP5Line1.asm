; Print the first MultiPlayer 5 warning line, centered.
PrintMP5Line1:						; called from ShowMP5Warning
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintMP5Line1Pos>>16
	sta.b a1+2
	lda.w #PrintMP5Line1Pos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra PrintCentered
