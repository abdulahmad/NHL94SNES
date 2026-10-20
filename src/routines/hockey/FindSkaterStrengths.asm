; The player card strengths of skater $1D9B: the best three of eleven rating columns into $1E79-$1E83
; (AddStrength)
;
; Called from DrawPlayerCard with the skater selected for the card. Each AddStrength call (d1 = rating
; column) keeps the best three (column, rating) pairs.
FindSkaterStrengths:				; called from DrawPlayerCard
	lda.w #$FFFF					; clear the three (column, rating) pairs to $FFFF
	sta.w strengths
	sta.w strengths+2
	sta.w strengths+4
	sta.w strengths+6
	sta.w strengths+8
	sta.w strengths+$A
	lda.w #$0004					; d1 = a rating column, AddStrength keeps the best three; eleven columns
									; in all
	sta.b d1
	jsl.l AddStrength
	lda.w #$0006
	sta.b d1
	jsl.l AddStrength
	lda.w #$0008
	sta.b d1
	jsl.l AddStrength
	lda.w #$000F
	sta.b d1
	jsl.l AddStrength
	lda.w #$0007
	sta.b d1
	jsl.l AddStrength
	lda.w #$000B
	sta.b d1
	jsl.l AddStrength
	lda.w #$0009
	sta.b d1
	jsl.l AddStrength
	lda.w #$0003
	sta.b d1
	jsl.l AddStrength
	lda.w #$000A
	sta.b d1
	jsl.l AddStrength
	lda.w #$000D
	sta.b d1
	jsl.l AddStrength
	lda.w #$000E
	sta.b d1
	jsl.l AddStrength
	rtl
