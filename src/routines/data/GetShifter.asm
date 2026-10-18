; d1 = the number of games of the playoff round less one, d2 = its first win bit
GetShifter:
	lda.w #$FFF0
	sta.b d2
	lda.w #$0010
	sta.b d1
	lda.l playoffRoundIdx
	tay
.3:
	lda.b d2
	clc
	adc.b d1
	sta.b d2
	lsr.b d1
	dey
	bpl .3
	dec.b d1
	rtl
