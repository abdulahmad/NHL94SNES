; Roster column: the fighting rating, then the rating printer AttribRating
AttribFighting:
	lda.b d0
	and.w #$000E					; drop the handedness bit
	sta.b d0
	dec.b d1						; 15 ratings: d1 - 1
AttribRating:
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l print
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #AttribFightingPos>>16
	sta.b a1+2
	lda.w #AttribFightingPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	rtl
