; The player's weight in pounds, from his weight rating
; Takes d0 = weight rating. Weight = 8 * rating + $8C pounds, printed with PushNumber followed by the
; text AttribWeightPos.
;
; Called through attribjmp.
AttribWeight:						; print the weight
	lda.b d0						; rating
	asl a							; times 8
	asl a
	asl a
	adc.w #$008C
	sta.b d0
	jsl.l PushNumber				; number to text
	jsl.l print						; print it
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #AttribWeightPos>>16
	sta.b a1+2
	lda.w #AttribWeightPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	rtl
