; Show or clear the scroll arrows beside a summary list, then send the text map
PrintScrollArrows:					; called from ScrollPenaltyDown, ScrollPenaltyUp, ScrollScoringDown, Sc...
	lda.w listtop
	clc
	adc.w #$0005
	cmp.w listend
	bpl .t1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #RightArrowTxt2>>16
	sta.b a1+2
	lda.w #RightArrowTxt2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .1

.t1:								; a1 = PrintScrollArrowsPos, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintScrollArrowsPos>>16
	sta.b a1+2
	lda.w #PrintScrollArrowsPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
.1:									; if a counted below 0 go to .t1x, ...
	lda.w listtop
	dec a
	bmi .t1x
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #LeftArrowTxt2>>16
	sta.b a1+2
	lda.w #LeftArrowTxt2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .2

.t1x:								; a counted below 0: a1 = PrintScrollArrowsPos2, call print, a1 = pulle...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintScrollArrowsPos2>>16
	sta.b a1+2
	lda.w #PrintScrollArrowsPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
.2:									; call QueueTextDMA, return
	jsl.l QueueTextDMA
	rtl
