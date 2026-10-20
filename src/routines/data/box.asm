; Erase the goal box (19 x 9 at $0B, $02)
box:								; called from SetLCmode2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #boxPos>>16
	sta.b a1+2
	lda.w #boxPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0013
	sta.b d0
	lda.w #$0009
	sta.b d1
	lda.l blankchar
	sta.b d2
	jml.l eraser
