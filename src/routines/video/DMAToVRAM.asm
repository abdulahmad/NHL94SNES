; DMA X bytes from [p0] to video memory at Y
DMAToVRAM:							; called from DrawMatchupPictures, DrawOtherScoresPage, DrawPenaltyPage...
	lda.w IniDispShadow-1
	bpl QueueVRAMDMA
	stx.w DAS1L
	lda.b p0
	sta.w A1T1L
	lda.w #DMA_VRAMWORD
	sta.w DMAP1
	cpy.w #$0000
	bmi .1
	sty.w VMADDL
	sty.b r3
.1:									; A1B1 = p0+2, MDMAEN = $02, return
	sep #$20
	lda.b p0+2
	sta.w A1B1
	lda.b #$02
	sta.w MDMAEN
	rep #$20
	txa
	lsr a
	adc.b r3
	tay
	rtl
