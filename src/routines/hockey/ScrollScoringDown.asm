; Scroll the scoring summary down one page.
ScrollScoringDown:					; called from ScoringSummaryLoop
	lda.w #$0006
	sta.w listrows
	jsr.w DrawScoringPage
	lda.w #$0005
	sta.w listrows
	lda.w listtop
	clc
	adc.w #$0005
	cmp.w listend
	bpl ScoringSummaryWait
.1:									; sbc #$0004, listtop = A, irqvscroll1 = $0001, ...
	sec
	sbc.w #$0004
	sta.w listtop
	lda.w #$0001
	sta.w irqvscroll1
	lda.w #$0018
	sta.w irqvscroll2
.loop:								; loop: call WaitFrame, increment irqvscroll1, increment irqvscroll1, ...
	jsl.l WaitFrame
	inc.w irqvscroll1
	inc.w irqvscroll1
	lda.w irqvscroll1
	cmp.w #$0017
	bne .loop
	jsl.l PrintScrollArrows
	jsr.w DrawScoringPage
	jsl.l WaitFrame
	lda.w #$FFFF
	sta.w irqvscroll1
	bra ScoringSummaryLoop
