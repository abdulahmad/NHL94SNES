; While $19CE is not 0: lower four hot / cold bytes of each of 52 entries ($1A12, 12 bytes apart) by 2, and
; count $19CE down
LowerHotColdTable:
	lda.w HotColdRaised
	beq .rtl
	ldy.w #$0033
	ldx.w #$0000
.loop:
	sep #$20
	lda.w HotColdTable+1,x
	dec a
	dec a
	sta.w HotColdTable+1,x
	lda.w HotColdTable,x
	dec a
	dec a
	sta.w HotColdTable,x
	lda.w HotColdTable+3,x
	dec a
	dec a
	sta.w HotColdTable+3,x
	lda.w HotColdTable+2,x
	dec a
	dec a
	sta.w HotColdTable+2,x
	rep #$20
	txa
	clc
	adc.w #$000C
	tax
	dey
	bpl .loop
	dec.w HotColdRaised
.rtl:
	rtl
