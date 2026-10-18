; Add roster player d0 to slot d4 of the list of players wanted on the ice, if he is available
TryAddPlayerToList:
	lda.b d0
	sta.b d1
	dec.b d0
	asl.b d0
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	adc.b d0
	tay
	lda.w tmpdst,y
	sec
	sbc.w #$0000
	beq .chk
	bpl .t1
.chk:
	lda.w tmpdst,y
	cmp.w #TMPDOUT
	beq .t1
	cmp.w #rosterNone
	beq .t1
	lda.w #$0005
	sta.b d0
.s2:
	ldy.b d0
	lda.b [a4],y
	and.w #$00FF
	sta.b tmp0
	lda.b d1
	and.w #$00FF
	cmp.b tmp0
	beq .t1
	dec.b d0
	bpl .s2
	ldy.b d4
	sep #$20
	lda.b d1
	sta.b [a4],y
	rep #$20
	lda.b d1
	and.w #$00FF
	rtl

.t1:
	lda.w #$0000
	sta.b d1
	rtl
