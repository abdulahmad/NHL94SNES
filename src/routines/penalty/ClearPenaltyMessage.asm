; Clear the penalty message area on the horizontal rink (a 24 x 3 frame at 4, $0C)
ClearPenaltyMessage:				; called from UpdatePA, prefmes
	lda.b d0
	pha
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ClearPenaltyMessagePos>>16
	sta.b a1+2
	lda.w #ClearPenaltyMessagePos
	sta.b a1
	jsl.l print						; print ClearPenaltyMessagePos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0018
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ClearPenaltyMessagePos2>>16
	sta.b a1+2
	lda.w #ClearPenaltyMessagePos2
	sta.b a1
	jsl.l print						; print ClearPenaltyMessagePos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	pla
	sta.b d0
	rtl
