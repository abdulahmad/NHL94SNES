; d0 = a random index 0 ... d0 into the weight word list at nibblebuffer, each index as likely as its weight
WeightedRandomSelect:				; called from SetScore
	lda.b d1+2						; keep d1
	pha
	lda.b d1
	pha
	lda.b a1+2						; keep a1
	pha
	lda.b a1
	pha
	lda.w #$0000
	sta.b a1+2
	lda.w #$0CF9
	sta.b a1
	stz.b d1						; sum = 0
	bra .2							; go
.1:									; loop: d0 still >= 0: d1 = d1 + [a1], increment a1, increment a1
	lda.b d1						; sum
	clc
	adc.b [a1]						; plus the weight
	sta.b d1
	inc.b a1						; next weight
	inc.b a1
.2:									; decrement d0, if d0 still >= 0 go to .1, ...
	dec.b d0						; count down
	bpl .1
	lda.b d1						; sum
	sta.b d0						; random limit
	jsl.l randomd0					; 0 to sum-1
.loop:								; loop: decrement a1, decrement a1, d0 = d0 - [a1], ...
	dec.b a1						; back one weight
	dec.b a1
	lda.b d0						; random
	sec
	sbc.b [a1]						; minus the weight
	sta.b d0
	bpl .loop						; until below zero
	lda.b a1						; index
	sec
	sbc.w #$0CF9
	lsr a							; words to index
	sta.b d0
	pla								; restore the registers
	sta.b a1
	pla
	sta.b a1+2
	pla
	sta.b d1
	pla
	sta.b d1+2
	rtl
