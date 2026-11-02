; Scroll the penalty summary down one page.
ScrollPenaltyDown:					; called from PenaltySummaryLoop
	lda.w #$0006
	sta.w listrows
	jsr.w DrawPenaltyPage			; draw the visible penalty rows, or No Penalties when the list is empty
	lda.w #$0005
	sta.w listrows
	lda.w listtop
	clc
	adc.w #$0005
	cmp.w listend
	bpl PenaltySummaryWait
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
	jsl.l PrintScrollArrows			; show or clear the scroll arrows beside a summary list
	jsr.w DrawPenaltyPage			; draw the visible penalty rows, or No Penalties when the list is empty
	jsl.l WaitFrame
	lda.w #$FFFF
	sta.w irqvscroll1
	bra PenaltySummaryLoop
