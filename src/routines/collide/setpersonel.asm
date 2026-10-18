; Put team a2's wanted players on the ice, keeping the ones already there
setpersonel:
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .savea
	ldx.b xsave
	ldy.b a2
	ldx.w tmsort,y
	stx.b a3
	lda.w #$0005
	sta.b d4
.l0:
	lda.w #$FFFF
	sta.w newpos,x
	sta.w newpnum,x
	inx
	inx
	stx.b a3
	dec.b d4
	bpl .l0
	jsl.l SetPlList
	lda.w #$0005
	sta.b d4
	lda.w #PlList>>16
	sta.b a4+2
	lda.w #PlList
	sta.b a4
.3:
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d5
	beq .4
	dec.b d5
	lda.w #$0005
	sta.b d3
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.2:
	inx
	inx
	stx.b a3
	lda.w pnum,x
	and.w #$00FF
	sta.b tmp0
	lda.b d5
	and.w #$00FF
	cmp.b tmp0
	beq .t1
	dec.b d3
	bpl .2
	bra .4

.t1:
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	bit.w #$0080
	beq .1
	ora.w #$FF00
.1:
	sta.w newpos,x
	lda.b d5
	and.w #$00FF
	bit.w #$0080
	beq .2x
	ora.w #$FF00
.2x:
	sta.w newpnum,x
	ldy.b d4
	sep #$20
	lda.b #$00
	sta.b [a4],y
	rep #$20
.4:
	dec.b d4
	bpl .3
	lda.w #$0005
	sta.b d4
	lda.w #PlList>>16
	sta.b a4+2
	lda.w #PlList
	sta.b a4
.5:
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d5
	beq .8
	dec.b d5
	lda.w #$0005
	sta.b d3
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.6:
	inx
	inx
	stx.b a3
	lda.w newpnum,x
	bit.w #$0080
	bne .t1x
	dec.b d3
	bpl .6
	bra .7

.t1x:
	stx.b a0
.7:
	lda.w position,x
	bpl .1x
	dec.b d3
	bpl .6
.1x:
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	bit.w #$0080
	beq .2xx
	ora.w #$FF00
.2xx:
	ldy.b a0
	sta.w newpos,y
	lda.b d5
	and.w #$00FF
	bit.w #$0080
	beq .3x
	ora.w #$FF00
.3x:
	sta.w newpnum,y
	ldy.b d4
	sep #$20
	lda.b #$00
	sta.b [a4],y
	rep #$20
.8:
	dec.b d4
	bpl .5
	stx.b xsave
	ldx.w #$0012
.loop:
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop
	ldx.b xsave
	stx.b xsave
	ldx.w #$0016
.loop2:
	pla
	sta.b d0,x
	dex
	dex
	bpl .loop2
	ldx.b xsave
	ldx.b a3
	rtl
