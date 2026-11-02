; Print the scroll hint under a summary list.
PrintScrollHint:					; called from PenaltySummaryScreen, ScoringSummaryScreen
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintScrollHintPos>>16
	sta.b a1+2
	lda.w #PrintScrollHintPos
	sta.b a1
	jsl.l print						; print PrintScrollHintPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$000E
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l FramerOutline
	lda.w #$2400
	sta.w printa
	lda.w #$000A
	sta.w printx
	lda.w #$0007
	sta.w printy
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ScrollHint>>16
	sta.b a1+2
	lda.w #ScrollHint
	sta.b a1
	jsl.l print						; print ScrollHint
	pla
	sta.b a1
	pla
	sta.b a1+2
	rtl
