; Assignment: the center on defense, halfway between the puck and his goal
asscenterd:							; X = center; asstab entry; teammate has puck: assignment 6
	ldy.w puckc
	bmi .4
	lda.w pfteam,x
	cmp.w pfteam,y
	bne .4
	lda.w #$0006
	sta.b d0
	jmp.w assreplace
.1:
	rtl
.2:
	jmp.w assnothing
.4:
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
	bpl .2x
	lda.w aidef,x
	sta.w temp1,x
.2x:
	lda.w puckx
	pha
	asl a
	pla
	ror a
	sta.b d0
	lda.w #$0080
	sta.b d1
	lda.w pfgoal,x
	beq .t2
	lda.w #$FF80
	sta.b d1
	lda.w #$FFA8
	sec
	sbc.w pucky
	bpl .3
	lda.w #$FF80
	clc
	adc.w pucky
	pha
	asl a
	pla
	ror a
	sta.b d1
	bra .3

.t1:								; bare return, not branched to in this file
	rtl

.t2:								; pfgoal clear: target y from $0058 - pucky, halved
	lda.w #$0058
	sec
	sbc.w pucky
	bmi .3
	lda.b d1
	clc
	adc.w pucky
	pha
	asl a
	pla
	ror a
	sta.b d1
.3:
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jmp.w skateto
