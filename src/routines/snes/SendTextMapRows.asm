; Send rows 1-12 of the text map to video memory
SendTextMapRows:					; called from DrawMatchupPictures, SelectLinePlayer, ShooterSelectList
	lda.w #$007E
	sta.b p0+2
	lda.w #$3834
	sta.b p0
	ldy.w #$0020
	ldx.w #$0300
	jsl.l DMAToVRAM
	rtl
