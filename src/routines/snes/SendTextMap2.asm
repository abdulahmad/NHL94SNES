; Send the second text map to video memory
SendTextMap2:						; called from DrawPlayerCard, LoadPlayerCardScreen, LoadScoutingScreen...
	lda.w #textmap2>>16
	sta.b p0+2
	lda.w #textmap2
	sta.b p0
	ldy.w #$0400
	ldx.w #$0800
	jsl.l DMAToVRAM
	rtl
