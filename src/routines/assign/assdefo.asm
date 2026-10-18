; Assignment: a defenseman on offense holds the blue line on his side
assdefo:
	cpx.w puckc
	beq .2
	ldy.w puckc
	bmi .11
	lda.w pfteam,x
	cmp.w pfteam,y
	beq .11
	lda.w #$0002
	sta.b d0
	jmp.w assreplace
.1:
	rtl

.t1:
	jmp.w assnothing
.2:
	lda.w #$0011
	sta.b d0
	jmp.w assinsert
.11:
	lda.w gmclock
	beq .t2
	jmp.w assnothing

.t2:
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
	adc.w aioff,x
	bpl .3
.2x:
	lda.w #$0000
.3:
	sta.w temp1,x
.4:
	lda.w #EvadePC>>16
	sta.b a0+2
	lda.w #EvadePC
	sta.b a0
	ldy.w #$0050
	lda.w position,x
	cmp.w #$0002
	beq .5
	ldy.w #$FFB0
.5:
	lda.w pfgoal,x
	bne .6
	tya
	eor.w #$FFFF
	inc a
	tay
.6:
	sty.b d0
	lda.w puckx
	eor.b d0
	bmi .t3
	lda.w puckx
	bra .7

.t1x:
	rtl

.t3:
	lda.w puckx
	pha
	asl a
	pla
	ror a
	clc
	adc.b d0
.7:
	sta.b d0
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoside
	bne .10
	lda.w pucky
	sta.b d2
	lda.w pfgoal,x
	bne .1xx
	lda.w #$0000
	sec
	sbc.b d2
	sta.b d2
.1xx:
	lda.b d2
	cmp.w #$FFA8
	bmi .t2x
	cmp.w #$0058
	bmi .t1xx
	lda.w #$0062
	sta.b d1
	bra .8

.t1xx:
	lda.w #$FFB2
	sta.b d1
	bra .8

.t2x:
	lda.w #$FF28
	sta.b d1
.8:
	lda.w pfgoal,x
	bne .9
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.9:
	jmp.w skateto
.10:
	ldy.w #$0062
	lda.w pfgoal,x
	beq .1xxx
	ldy.w #$FF9E
.1xxx:
	sty.b d1
	bra .9
