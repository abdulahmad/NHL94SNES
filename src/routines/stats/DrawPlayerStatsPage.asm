; Player stats: print the header and send the header rows and the visible rows of the stats page buffer
; (scroll curitem) to VRAM
DrawPlayerStatsPage:				; called from PlayerStatsScreen, PlayerStatsScreen_column...
	lda.b d1
	pha
	lda.w statcolumn
	beq .t1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayerGAPtShPmTxt>>16
	sta.b a1+2
	lda.w #PlayerGAPtShPmTxt
	sta.b a1
	jsl.l print						; print PlayerGAPtShPmTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w listrows
	sta.b d1
	dec.b d1
	lda.w #textmap>>16
	sta.b p0+2
	lda.w #textmap+$1C0
	sta.b p0
	ldy.w #$00E0
	ldx.w #$00C0
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	bra .1

.t1:								; statcolumn = 0: a1 = GoalieGaShPtgTxt, call print, a1 = pulled value...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #GoalieGaShPtgTxt>>16
	sta.b a1+2
	lda.w #GoalieGaShPtgTxt
	sta.b a1
	jsl.l print						; print GoalieGaShPtgTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w listend
	sta.b d1
	lda.w #textmap>>16
	sta.b p0+2
	lda.w #textmap+$1C0
	sta.b p0
	ldy.w #$00E0
	ldx.w #$04C0
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
.1:									; xba, lsr a, adc #$2780, ...
	lda.w curitem
	xba
	lsr a
	adc.w #statspage
	sta.b p0
	lda.w #statspage>>16
	sta.b p0+2
	lda.b d1
	xba
	lsr a
	adc.w #$0040
	tax
	ldy.w #$0160
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	pla
	sta.b d1
	rtl
