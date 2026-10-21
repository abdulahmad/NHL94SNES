; d0 = a random index 0 ... d0 into the weight word list at nibblebuffer, each index as likely as its weight
WeightedRandomSelect:				; called from SetScore
	lda.b d1+2
	pha
	lda.b d1
	pha
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #$0000
	sta.b a1+2
	lda.w #$0CF9
	sta.b a1
	stz.b d1
	bra .2
.1:									; loop: d0 still >= 0: d1 = d1 + [a1], increment a1, increment a1
	lda.b d1
	clc
	adc.b [a1]
	sta.b d1
	inc.b a1
	inc.b a1
.2:									; decrement d0, if d0 still >= 0 go to .1, ...
	dec.b d0
	bpl .1
	lda.b d1
	sta.b d0
	jsl.l randomd0
.loop:								; loop: decrement a1, decrement a1, d0 = d0 - [a1], ...
	dec.b a1
	dec.b a1
	lda.b d0
	sec
	sbc.b [a1]
	sta.b d0
	bpl .loop
	lda.b a1
	sec
	sbc.w #$0CF9
	lsr a
	sta.b d0
	pla
	sta.b a1
	pla
	sta.b a1+2
	pla
	sta.b d1
	pla
	sta.b d1+2
	rtl
