; Send rows 1-12 of the text map to video memory
SendTextMapRows:					; called from DrawMatchupPictures, SelectLinePlayer, ShooterSelectList
	lda.w #textmap>>16
	sta.b p0+2
	lda.w #textmap+$40
	sta.b p0
	ldy.w #$0020
	ldx.w #$0300
	jsl.l DMAToVRAM
	rtl
