; Scroll the penalty summary up one page.
ScrollPenaltyUp:					; called from PenaltySummaryLoop
	lda.w listtop
	dec a
	bmi PenaltySummaryWait
	sta.w listtop
	lda.w #$0006
	sta.w listrows
	jsr.w DrawPenaltyPage
	jsl.l WaitFrame
	lda.w #$0015
	sta.w irqvscroll1
	lda.w #$0018
	sta.w irqvscroll2
.loop:								; loop: call WaitFrame, decrement irqvscroll1, decrement irqvscroll1, ...
	jsl.l WaitFrame
	dec.w irqvscroll1
	dec.w irqvscroll1
	lda.w irqvscroll1
	cmp.w #$0001
	bne .loop
	jsl.l PrintScrollArrows
	lda.w #$0005
	sta.w listrows
	jsr.w DrawPenaltyPage
	jsl.l WaitFrame
	lda.w #$FFFF
	sta.w irqvscroll1
	jmp.w PenaltySummaryLoop
