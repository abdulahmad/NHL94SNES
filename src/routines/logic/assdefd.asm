; Assignment: a defenseman on defense stays between the furthest attacker and his goal
assdefd:
	ldy.w puckc
	bmi .16
	lda.w pfteam,x
	cmp.w pfteam,y
	bne .16
	lda.w #$0001
	sta.b d0
	jmp.w assreplace
.1:
	rtl
.2:
	jmp.w assnothing
.16:
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
	bmi .t2
	jmp.w .15

.t2:
	clc
	adc.w aidef,x
	bpl .2x
.1xx:
	lda.w #$0000
.2x:
	sta.w temp1,x
	lda.w pucky
	sta.b d1
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .3
	ora.w #$FC00
.3:
	sta.b d3
	lda.w pfgoal,x
	bne .4
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
	lda.w #$0000
	sec
	sbc.b d3
	sta.b d3
.4:
	lda.b d3
	bpl .5
	stz.b d3
.5:
	lda.b d3
	clc
	adc.b d1
	sta.b d3
	sec
	sbc.w #$0058
	bmi .7
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoside
	bne .7
	lda.w puckc
	bmi .6
	lsr a
.6:
	sta.b d1
	bmi .7
	jsl.l chkpk
	beq .7
	lda.b d1
	sec
	sbc.w #$0006
	sta.b d1
	txa
	lsr a
	sec
	sbc.w #$0006
	sta.b d2
	eor.b d1
	sta.b d1
.7:
	lda.w #$0041
	sta.w temp3,x
	lda.w position,x
	cmp.w #$0002
	beq .8
	lda.w #$FFBF
	sta.w temp3,x
.8:
	ldy.w #$0000
	cpx.w #$000C
	bcs .9
	ldy.w #$000C
.9:
	lda.w #$0006
	sta.b d2
	lda.w #$FC18
	sta.b d0
	lda.w pfgoal,x
	beq .14
	lda.w #$03E8
	sta.b d0
.loop:
	sty.b a0
	lda.w pflags,y
	bit.w #$1000
	bne .12
	lda.w position,y
	bmi .12
	lda.w Yvel,y
	bmi .10
	lda.w #$0000
.10:
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0400
	beq .11
	ora.w #$F800
.11:
	clc
	adc.w Ypos,y
	sta.b d1
	sec
	sbc.b d0
	bpl .12
	lda.b d1
	sta.b d0
.12:
	ldy.b a0
	iny
	iny
	dec.b d2
	bne .loop
	lda.b d0
	sec
	sbc.w #$0028
	sta.b d0
	sec
	sbc.w #$FF42
	bpl .13
	lda.w #$FF24
	sta.b d0
.13:
	lda.b d0
	sta.w temp4,x
	lda.w puckx
	sta.b d0
	lda.w temp3,x
	eor.b d0
	sta.b d1
	bpl .15
	stz.w temp3,x
	bra .15

.t1:
	rtl
.14:
	sty.b a0
	lda.w pflags,y
	bit.w #$1000
	bne .4x
	lda.w position,y
	bmi .4x
	lda.w Yvel,y
	bpl .1xxx
	lda.w #$0000
.1xxx:
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0400
	beq .3x
.2xx:
	ora.w #$F800
.3x:
	clc
	adc.w Ypos,y
	sta.b d1
	sec
	sbc.b d0
	bmi .4x
	lda.b d1
	sta.b d0
.4x:
	ldy.b a0
	iny
	iny
	dec.b d2
	bne .14
	lda.b d0
	clc
	adc.w #$0028
	sta.b d0
	sec
	sbc.w #$00BE
	bmi .5x
	lda.w #$00DC
	sta.b d0
.5x:
	lda.b d0
	sta.w temp4,x
	lda.w #$0000
	sec
	sbc.w temp3,x
	sta.w temp3,x
	lda.w puckx
	sta.b d0
	lda.w temp3,x
	eor.b d0
	sta.b d1
	bpl .15
	stz.w temp3,x
.15:
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jsl.l skateto
	jmp.w check4check
