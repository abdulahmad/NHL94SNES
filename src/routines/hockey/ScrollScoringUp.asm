; Scroll the scoring summary up one page.
ScrollScoringUp:					; called from ScoringSummaryLoop
	lda.w listtop
	dec a
	bmi ScoringSummaryWait
	sta.w listtop
	lda.w #$0006
	sta.w listrows
	jsr.w DrawScoringPage			; draw the visible scoring rows, or No Scoring when the list is empty
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
	jsl.l PrintScrollArrows			; show or clear the scroll arrows beside a summary list
	lda.w #$0005
	sta.w listrows
	jsr.w DrawScoringPage			; draw the visible scoring rows, or No Scoring when the list is empty
	jsl.l WaitFrame
	lda.w #$FFFF
	sta.w irqvscroll1
	jmp.w ScoringSummaryLoop
