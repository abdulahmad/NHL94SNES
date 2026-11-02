; Send the text map to video memory
SendTextMap:						; called from AskExitGame, DrawHorTeams, DrawPlayerCard, LineEditorExit...
	lda.w #textmap>>16
	sta.b p0+2
	lda.w #textmap
	sta.b p0
	ldy.w #$0000
	ldx.w #$0800
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	rtl
