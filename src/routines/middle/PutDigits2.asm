; Write the two digit number d0 as two characters at [a1], blank leading zero.
PutDigits2:							; called from PlayerNumName, PlayerShortName, pplpen
	lda.w #$2020
	sta.b tmp0
	lda.b d0
	and.w #$00FF
	cmp.w #$000A
	bcc .ones
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc.w #$0030
	sta.b tmp0
.ones:								; tmp0+1 = d0 & $000F + $0030, [a1] = tmp0, increment a1, ...
	lda.b d0
	and.w #$000F
	clc
	adc.w #$0030
	sta.b tmp0+1
	lda.b tmp0
	sta.b [a1]
	inc.b a1
	inc.b a1
	rtl
