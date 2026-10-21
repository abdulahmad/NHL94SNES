; Send rows 1-12 of the second text map to video memory
SendTextMap2Rows:					; called from DrawMatchupPictures, SelectLinePlayer, ShooterSelectList
	lda.w #textmap2>>16
	sta.b p0+2
	lda.w #textmap2+$40
	sta.b p0
	ldy.w #$0420
	ldx.w #$0300
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	rtl
