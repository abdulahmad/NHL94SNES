; Collision with the goal: over the top, into the net, off a post or off the side
checkgoal:
	cpx.w #$001C
	beq .t3
	jmp.w checkgoalp

.t3:
	ldy.w puckc
	bmi .1
	lda.w position,y
	beq .t1
.1:
	lda.w puckz
	cmp.w #$000D
	bpl .t1
	ldy.b a2
	lda.b d2
	sec
	sbc.w Xpos,y
	sta.b d2
	cmp.w #$0017
	bpl .t1
	lda.b d2
	cmp.w #$FFEA
	bmi .t1
	lda.w #$0009
	sta.b d5
	lda.b d3
	sec
	sbc.w Ypos,y
	sta.b d3
	cmp.w #$000A
	bpl .t1
	lda.w #$0000
	sec
	sbc.b d5
	sta.b d5
	lda.b d3
	cmp.w #$FFF7
	bmi .t1
	lda.w #$FFFF
	sta.w collflag
	lda.w puckoldz
	cmp.w #$000D
	bmi .t2
	lda.w puckoldz
	sta.w puckz
	jmp.w .10

.t1:
	rtl

.t2:
	stz.w pfgoal+puckobj
	lda.w puckc
	bmi .2
	tay
	lda.w #$FFFF
	sta.w puckc
	lda.w #$0008
	sta.w nopuck,y
	lda.w pucky
	sta.b d1
	lda.w pfgoal,y
	bne .1x
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.1x:
	lda.b d1
	bpl .2
	lda.w #$0001
	sta.w pfgoal+puckobj
.2:
	lda.w #$FF01
	sta.b d0
	lda.w #$FF01
	sta.b p0
	lda.w Yfrac,x
	sec
	sbc.w OldYfrac,x
	sta.b d1
	lda.w Ypos,x
	sbc.w OldYpos,x
	sta.b d1+2
	lda.b d1+1
	sta.b d1
	cmp.w #$0000
	beq .6
	bmi .3
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b p0
	sta.b p0
	lda.w #$0000
	sec
	sbc.b d5
	sta.b d5
.3:
	lda.b d5
	clc
	adc.b d3
	sta.b d5
	sta.b r2
	lda.w Xfrac,x
	sec
	sbc.w OldXfrac,x
	sta.b d3
	lda.w Xpos,x
	sbc.w OldXpos,x
	sta.b d3+2
	lda.b d3+1
	sta.b d3
	ldx.b r2
	jsl.l Mul16S
	ldx.b a3
	lda.b d1
	bit.w #$8000
	beq .4
	eor.w #$FFFF
	inc a
.4:
	sta.b r1
	lda.b r2+2
	bit.w #$8000
	beq .5
	eor.w #$FFFF
	inc a
.5:
	cmp.b r1
	bcs .6
	lda.b d1
	sta.b r1
	jsl.l Div32S
	lda.b r0
	sta.b d5
	ldx.b a3
	lda.b d2
	sec
	sbc.b d5
	sta.b d2
	cmp.w #$FFEA
	bmi .6
	lda.b d2
	cmp.w #$0017
	bmi .9
.6:
	jmp.w .11
.7:
	lda.w puckvy
	cmp.w #$0800
	bpl .1xx
	cmp.w #$F800
	bmi .1xx
	cmp.w #$0000
	bpl .t1x
	lda.w #$F800
	sta.w puckvy
	bra .1xx

.t1x:
	lda.w #$0800
	sta.w puckvy
.1xx:
	jmp.w wallcoll
.8:
	jmp.w Goal
.9:
	stz.b d1
	lda.w pucky
	eor.b p0
	bmi .7
	lda.w #$0000
	sec
	sbc.b p0
	sta.b p0
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w pfgoal+puckobj
	bne .7
	lda.w puckz
	cmp.w #$000D
	beq .1xxx
	lda.b d2
	cmp.w #$0012
	bpl .1xxx
	lda.b d2
	cmp.w #$FFEF
	bpl .8
.1xxx:
	jsl.l ChkShotStat
	stz.w breakaway
	stz.w onetimer
	lda.w #$0009
	jsl.l PuckSfx
	lda.l crowdlevel
	clc
	adc.w #$012C
	sta.l crowdlevel
	lda.w #$003C
	sta.b crowdhold
	lda.w CwdExciteLvl
	clc
	adc.w #$0028
	bmi .2x
	sta.w CwdExciteLvl
.2x:
	jsl.l RandomWord
	and.w #$0FFF
	sta.b d0
	lda.w pucky
	bmi .3x
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.3x:
	lda.b d0
	sta.w puckvy
	jsl.l RandomWord
	and.w #$1FFF
	sec
	sbc.w #$1000
	sta.w puckvx
	jsl.l RandomWord
	and.w #$1FFF
	sec
	sbc.w #$1000
	sta.w puckvz
	jmp.w puckflip
.10:
	lda.w puckvz
	bit.w #$8000
	beq .1xxxx
	eor.w #$FFFF
	inc a
.1xxxx:
	sta.w puckvz
	rtl
.11:
	lda.w puckvx
	cmp.w #$0800
	bpl .2xx
	cmp.w #$F800
	bmi .2xx
	cmp.w #$0000
	bpl .t1xx
	lda.w #$F800
	sta.w puckvx
	bra .2xx

.t1xx:
	lda.w #$0800
	sta.w puckvx
.2xx:
	stz.b d0
	lda.w #$00FF
	sta.b d1
	lda.w puckx
	sec
	sbc.w OldXpos+puckobj
	sta.b d2
	bmi .1xxxxx
	lda.w #$FF01
	sta.b d1
.1xxxxx:
	jmp.w wallcoll
