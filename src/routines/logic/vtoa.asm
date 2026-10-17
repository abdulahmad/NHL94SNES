; d0 = the direction (0-7, 8 = none) of the x / y distances d0 / d1.
vtoa:
	lda.b d0
	ora.b d1
	beq .nodir
	stz.b d7+2						;the octant index (94G builds it in d2): sign
	;bits, then the two ratio bits
	lda.b d0
	bpl .0
	eor.w #$FFFF
	inc a
	sta.b d0
	inc.b d7+2
.0:
	lda.b d1
	bpl .1
	eor.w #$FFFF
	inc a
	sta.b d1
	inc.b d7+2
	inc.b d7+2
.1:
	lda.b d1
	asl a
	cmp.b d0
	bcc .2
	lda.w #$0004
	tsb.b d7+2
.2:
	lda.b d0
	asl a
	cmp.b d1
	bcc .3
	lda.w #$0008
	tsb.b d7+2
.3:
	phx
	ldx.b d7+2
	lda.l .dt,x
	plx
	and.w #$00FF
	sta.b d0
	rtl
.nodir:
	lda.w #$0008
	sta.b d0
	rtl
.dt:
	db $01,$07,$03,$05,$00,$00,$04,$04,$02,$06,$02,$06,$01,$07,$03,$05
