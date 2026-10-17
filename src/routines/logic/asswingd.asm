; Assignment: a wing on defense covers his side between the puck and the goal
asswingd:
	ldy.w puckc
	bmi .8
	lda.w pfteam,x
	cmp.w pfteam,y
	bne .8
	lda.w #$0004
	sta.b d0
	jmp.w assreplace
.1:
	rtl
.2:
	jmp.w assnothing
.8:
	lda.w gmclock
	bne .2
	jsl.l check4bench
	lda.w playerpad,x
	bpl .1
	lda.w pflags,x
	bit.w #pfna
	beq .1x
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.1x:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .4
	clc
	adc.w aidef,x
	bpl .3
.2x:
	lda.w #$0000
.3:
	sta.w temp1,x
.4:
	lda.w #$0064
	sta.b d0
	lda.w position,x
	cmp.w #$0005
	bne .5
	lda.w #$FF9C
	sta.b d0
.5:
	ldy.w puckc
	lda.w pfgoal,x
	beq .t3
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$FF62
	sta.b d1
	lda.w #$FFB2
	sta.b d2
	lda.w position,y
	beq .6
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoffside
	bne .6
	lda.b d2
	sec
	sbc.w pucky
	bpl .t2
	lda.w pucky
	sta.b d1
	bra .7

.t1:
	rtl

.t2:
	lda.w #$FEF8
	sta.b d2
	sec
	sbc.w pucky
	bmi .7
	bra .6

.t3:
	lda.w #$009E
	sta.b d1
	lda.w #$004E
	sta.b d2
	lda.w position,y
	beq .6
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoffside
	bne .6
	lda.b d2
	sec
	sbc.w pucky
	bmi .t1x
	lda.w pucky
	sta.b d1
	bra .7

.t1x:
	lda.w #$0108
	sta.b d2
	sec
	sbc.w pucky
	bpl .7
.6:
	lda.b d2
	sta.b d1
.7:
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	lda.w puckx
	eor.b d0
	sta.b d2
	bmi .1xx
	lda.w puckx
	sta.b d0
.1xx:
	jmp.w skateto
