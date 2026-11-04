; Scroll the other-scores list up one page.
ScrollOtherScoresUp:				; called from OtherScoresLoop
	jsr.w ClearOtherScoreBraces		; erase the braces around the visible other-scores rows
	lda.w listtop
	dec a
	bpl .t2
	jmp.w OtherScoresNext

.t2:								; a still >= 0: if not zero go to .1, ...
	cmp.l gamenum
	bne .1
	cmp.w #$0000
	bne .t1
	jmp.w OtherScoresNext

.t1:								; decrement a
	dec a
.1:									; listtop = A, listrows = $0006, call DrawOtherScoresPage, ...
	sta.w listtop
	lda.w #$0006
	sta.w listrows
	jsl.l DrawOtherScoresPage		; draw the other-scores rows
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
	lda.w #$0005
	sta.w listrows
	jsl.l DrawOtherScoresPage		; draw the other-scores rows
	jsl.l WaitFrame
	lda.w #$FFFF
	sta.w irqvscroll1
	jmp.w OtherScoresLoop
