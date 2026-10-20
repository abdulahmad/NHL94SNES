; Roster column: the fighting rating, then the rating printer AttribRating
; Takes d0 = player attribute word. The handedness bit is dropped and the rating is printed with its
; position (AttribFightingPos). AttribRating is the shared tail that prints d0 as a number of d1 = 4 digits.
;
; Called through attribjmp.
AttribFighting:						; print the fighting rating
	lda.b d0
	and.w #$000E					; drop the handedness bit
	sta.b d0
	dec.b d1						; 15 ratings: d1 - 1
AttribRating:						; print d0 as a number followed by the text at a1
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
