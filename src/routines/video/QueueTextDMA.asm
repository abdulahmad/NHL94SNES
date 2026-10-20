; Queue the changed part of the text map for transfer to video memory
QueueTextDMA:						; called from BadPasswordPrompt, DrawOtherScoresPage, DrawPenaltyPage...
	lda.w textdirtylo
	bmi .rtl
	tay
	asl a
	adc.w #textmap
	sta.b p0
	lda.w #textmap>>16
	sta.b p0+2
	lda.w textdirtyhi
	beq .rtl
	sec
	sbc.w textdirtylo
	inc a
	asl a
	tax
	jsl.l DMAToVRAM
	lda.w #$FFFF
	sta.w textdirtylo
	stz.w textdirtyhi
.rtl:								; return
	rtl
