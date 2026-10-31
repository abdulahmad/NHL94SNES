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
.1:									; playerpad,x >= 0: return
	rtl
.2:									; gmclock != 0: go to donothing
	jmp.w donothing					; computer player stands still
.4:									; if gmclock != 0 go to .2, ...
	lda.w gmclock
	bne .2
	jsl.l check4bench				; check whether a line change wants this player off
	lda.w playerpad,x
	bpl .1
	lda.w pflags,x
	bit.w #pfna
	beq .1x
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x					; temp1 = 0
	stz.w temp2,x
	lda.w #$0008					; temp2b = 8
	sta.w temp2b,x
.1x:								; temp1,x = temp1,x - d7, if plus go to .2x, ...
	lda.w temp1,x					; timer
	sec
	sbc.b d7						; minus d7
	sta.w temp1,x
	bpl .2x							; not up
	lda.w aidef,x					; reload from aidef
	sta.w temp1,x
.2x:								; ror a, d0 = A, d1 = $0080, ...
	lda.w puckx						; puck x
	pha
	asl a							; /2
	pla
	ror a
	sta.b d0						; target x
	lda.w #$0080					; target y
	sta.b d1
	lda.w pfgoal,x					; goal end
	beq .t2							; top
	lda.w #$FF80					; bottom end
	sta.b d1
	lda.w #$FFA8
	sec								; puck y
	sbc.w pucky
	bpl .3
	lda.w #$FF80					; halfway
	clc
	adc.w pucky						; plus puck y
	pha
	asl a
	pla								; /2
	ror a
	sta.b d1
	bra .3							; skate there

.t1:								; bare return, not branched to in this file
	rtl

.t2:								; pfgoal clear: target y from $0058 - pucky, halved
	lda.w #$0058
	sec
	sbc.w pucky
	bmi .3
	lda.b d1
	clc
	adc.w pucky						; plus puck y
	pha
	asl a
	pla								; /2
	ror a
	sta.b d1
.3:									; a0 = rtss, go to skateto
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jmp.w skateto					; player X skates toward d0 / d1
