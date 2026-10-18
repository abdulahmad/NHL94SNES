; The puck hits player a2's stick
puckstick:
	ldy.b a2
	lda.w position,y
	bne .2
	lda.w gmode
	bit.w #gmhl
	beq .2
.1:
	rtl
.2:
	lda.w pflags,y
	and.w #$FFFE
	sta.w pflags,y
	ldy.w puckc
	bpl .t1
	jmp.w .5

.t1:
	lda.w pfteam,y
	ldy.b a2
	cmp.w pfteam,y
	beq .1
	lda.b d0
	cmp.w #$0025
	bcs .1
	lda.w position,y
	beq .1x
	ldy.b a0
	lda.w position,y
	beq .1
	lda.w stickhand,y
	jsl.l makepde
	lda.b d0
	pha
	lda.b a0
	ldy.b a2
	sty.b a0
	sta.b a2
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b a0
	ldy.b a2
	sty.b a0
	sta.b a2
	pla
	sec
	sbc.b d0
	clc
	adc.w #$0024
	jsl.l randoma
	cmp.w #$0003
	bcs .1
.1x:
	ldy.b a0
	lda.w stickhand,y
	jsl.l makepde
	lda.b d0
	adc.w #$0014
	ldy.b a0
	sta.w nopuck,y
	lda.b a0
	ldy.b a2
	sty.b a0
	sta.b a2
	lda.w stickhand,y
	jsl.l makepde
	lda.b d0
	adc.w #$0014
	ldy.b a0
	sta.w nopuck,y
	lda.b a0
	ldy.b a2
	sty.b a0
	sta.b a2
	tya
	lsr a
	sta.w lastplayer
	lda.w #$000C
	trb.w sflags
.3:
	lda.w #$0003
	jsl.l PuckSfx
	jsl.l a2touchpuck
	jmp.w deflect
.4:
	rtl
.5:
	lda.b d0
	sta.b d2
	lda.w puckvx
	phx
	tax
	jsl.l Mul16S
	lda.b r2+2
	sta.b d0+2
	lda.b r2
	sta.b d0
	lda.w puckvy
	tax
	jsl.l Mul16S
	plx
	lda.b r2
	clc
	adc.b d0
	sta.b d0
	lda.b r2+2
	adc.b d0+2
	sta.b d0+2
	stz.b d1
	lda.w sflags
	bit.w #$1000
	bne .1xx
	ldy.b a2
	lda.w stickhand,y
	phx
	ldx.w #$02BC
	jsl.l Mul16x8U
	lda.b r2
	sta.b d1
	plx
.1xx:
	lda.b d1
	clc
	adc.w #$2710
	ldy.w position,x
	beq .2x
	cpx.w passReceiverPlayerNum
	bne .3x
.2x:
	adc.w #$0BB8
.3x:
	phx
	tax
	jsl.l Mul16U
	plx
	lda.b r2
	cmp.b d0
	lda.b r2+2
	sbc.b d0+2
	bcs .t2
	lda.w position,x
	beq .t1x
	lda.b d2
	cmp.w #$0025
	bcc .t1x
	jmp.w .4

.t1x:
	ldy.b a2
	lda.w #$0008
	sta.w nopuck,y
	jmp.w .3

.t2:
	jmp.w puckglue
