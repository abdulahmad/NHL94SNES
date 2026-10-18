; Fill the hot / cold table ($1A12, both teams) with random values -12 ... 12
Create_HotCold_Table:
	ldx.w #$026F
.2:
	lda.w #$000E
	jsl.l randoma8
	cmp.w #$000C
	bcc .1
	lda.w #$000C
.1:
	sta.b r3
	lda.w seed
	and.w #$0010
	beq .4
	sep #$20
	lda.b r3
	sta.w HotColdTable,x
.3:
	rep #$20
	dex
	bpl .2
	rtl
.4:
	sep #$20
	lda.b #$00
	sec
	sbc.b r3
	sta.w HotColdTable,x
	bra .3
