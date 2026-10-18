; d0 = the square root of $A7:d0 (binary search, the range narrowed first)
sroot:
	phx
	lda.b d0+2
	beq .3
	ldx.w #$0100
	ldy.w #$1000
	cmp.w #$0048
	bcs .t2
	ldy.w #$087D
	cmp.w #$0016
	bcs .t1
	ldy.w #$04B1
	bra .1

.t1:
	ldx.w #$04B0
	bra .1

.t2:
	ldx.w #$087C
	cmp.w #$0096
	bcs .t3
	ldy.w #$0C40
	bra .1

.t3:
	ldx.w #$0C3F
.1:
	stx.b p0
	sty.b p1
.2:
	lda.b p0
	clc
	adc.b p1
	ror a
	cmp.b p0
	beq .t2x
	pha
	tax
	jsl.l Mul16U
	lda.b d0
	cmp.b r2
	lda.b d0+2
	sbc.b r2+2
	bcs .t1x
	pla
	sta.b p1
	bra .2

.t1x:
	pla
	sta.b p0
	bra .2

.t2x:
	plx
	sta.b d0
	rtl
.3:
	stz.b p0
	lda.w #$00FF
	sta.b p1
.4:
	lda.b p0
	clc
	adc.b p1
	ror a
	cmp.b p0
	beq .t2xx
	pha
	tax
	jsl.l Mul8U
	cmp.b d0
	bcc .t1xx
	pla
	sta.b p1
	bra .4

.t1xx:
	pla
	sta.b p0
	bra .4

.t2xx:
	plx
	sta.b d0
	rtl
