; Scroll the other-scores list down one page.
ScrollOtherScoresDown:				; called from OtherScoresLoop
	jsr.w ClearOtherScoreBraces
	lda.w #$0006
	sta.w listrows
	jsl.l DrawOtherScoresPage
	lda.w #$0005
	sta.w listrows
	lda.w listtop
	clc
	adc.w #$0005
	clc
	adc.w otherskip
	cmp.w listend
	bmi .t2
	jmp.w OtherScoresNext

.t2:								; sbc #$0004, sbc otherskip, if not zero go to .2
	sec
	sbc.w #$0004
	sec
	sbc.w otherskip
	cmp.l gamenum
	bne .2
.1:									; adc #$0005, adc otherskip, if minus go to .t1, ...
	clc
	adc.w #$0005
	clc
	adc.w otherskip
	cmp.w listend
	bmi .t1
	jmp.w OtherScoresNext

.t1:								; sbc #$0004, sbc otherskip
	sec
	sbc.w #$0004
	sec
	sbc.w otherskip
.2:									; listtop = A, irqvscroll1 = $0001, irqvscroll2 = $0018
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
	jsl.l DrawOtherScoresPage
	jsl.l WaitFrame
	lda.w #$FFFF
	sta.w irqvscroll1
	jmp.w OtherScoresLoop
