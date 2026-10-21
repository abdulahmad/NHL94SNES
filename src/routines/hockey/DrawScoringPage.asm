; Draw the visible scoring rows, or No Scoring when the list is empty.
DrawScoringPage:					; called from ScrollScoringDown, ScrollScoringUp, ShowScoringSummary
	lda.w listend
	cmp.w #$0000
	beq .t1
.1:									; xba, lsr a, lsr a, ...
	lda.w listtop
	asl a
	adc.w listtop
	xba
	lsr a
	lsr a
	adc.w #statspage
	sta.b p0
	lda.w #statspage>>16
	sta.b p0+2
	lda.w listrows
	asl a
	adc.w listrows
	xba
	lsr a
	lsr a
	tax
	ldy.w #$0160
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	rts

.t1:								; listend = $0000: a1 = NoScoring, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #NoScoring>>16
	sta.b a1+2
	lda.w #NoScoring
	sta.b a1
	jsl.l print						; print NoScoring
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l QueueTextDMA				; queue the changed part of the text map for transfer to video memory
	rts
