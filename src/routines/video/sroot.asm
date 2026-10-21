; d0 = the square root of $A7:d0 (binary search, the range narrowed first)
sroot:								; called from UpdateCrowdMeter
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

.t1:								; $087D >= $0016: go to .1
	ldx.w #$04B0
	bra .1

.t2:								; $1000 >= $0048: if $087C >= $0096 go to .t3, ...
	ldx.w #$087C
	cmp.w #$0096
	bcs .t3
	ldy.w #$0C40
	bra .1

.t3:								; $087C >= $0096: falls through
	ldx.w #$0C3F
.1:									; p0 = X, p1 = Y
	stx.b p0
	sty.b p1
.2:									; loop: ror a, if zero go to .t2x, ...
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

.t1x:								; p0 = pulled value, go to .2
	pla
	sta.b p0
	bra .2

.t2x:								; d0 = A, return
	plx
	sta.b d0
	rtl
.3:									; d0+2 = 0: p0 = 0, p1 = $00FF
	stz.b p0
	lda.w #$00FF
	sta.b p1
.4:									; loop: ror a, if zero go to .t2xx, ...
	lda.b p0
	clc
	adc.b p1
	ror a
	cmp.b p0
	beq .t2xx
	pha
	tax
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	cmp.b d0
	bcc .t1xx
	pla
	sta.b p1
	bra .4

.t1xx:								; p0 = pulled value, go to .4
	pla
	sta.b p0
	bra .4

.t2xx:								; d0 = A, return
	plx
	sta.b d0
	rtl
