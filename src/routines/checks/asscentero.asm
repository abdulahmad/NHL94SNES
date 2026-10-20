; Assignment: the center on offense skates to a spot in the zone of the puck
asscentero:							; X = center; asstab entry, skates to a spot via skateto
	cpx.w puckc
	beq .3
	ldy.w puckc
	bmi .7
	lda.w pfteam,x
	cmp.w pfteam,y
	beq .7
	lda.w #$0005
	sta.b d0
	jmp.w assreplace
.1:									; playerpad,x >= 0: return
	rtl
.2:									; gmclock != 0: go to assnothing
	jmp.w assnothing
.3:									; d0 = $0011, go to assinsert
	lda.w #$0011
	sta.b d0
	jmp.w assinsert
.7:									; if gmclock != 0 go to .2, ...
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
	lda.w #$FFFF
	sta.w temp5,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.1x:								; temp1,x = temp1,x - d7, if minus go to .t1, ...
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .t1
	jmp.w .6

.t1:								; temp1 ran out: add aidef,x to it and pick a new spot
	clc
	adc.w aidef,x
	bpl .2x
.1xx:								; falls through
	lda.w #$0000
.2x:								; temp1,x = A, d0 = pucky, if pfgoal,x != 0 go to .3x, ...
	sta.w temp1,x
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .3x
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.3x:								; d2 = 0, if minus go to .4, ...
	stz.b d2
	lda.b d0
	sec
	sbc.w #$FFA8
	bmi .4
	lda.w #$0008
	sta.b d2
	lda.b d0
	sec
	sbc.w #$0058
	bmi .4
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoside
	bne .4
	asl.b d2
	lda.b d0
	sec
	sbc.w #$0108
	bmi .4
	lda.w #$0018
	sta.b d2
.4:									; if d2 != temp5,x go to .5, ...
	lda.b d2
	cmp.w temp5,x
	bne .5
	lda.w seed+2
	cmp.w #$0200
	bcs .6
.5:									; temp5,x = d2, a0 = CenterOSpots, Y + 1, ...
	lda.b d2
	sta.w temp5,x
	tay
	lda.w #CenterOSpots>>16
	sta.b a0+2
	lda.w #CenterOSpots
	sta.b a0
	iny
	iny
	lda.b [a0],y
	dey
	dey
	jsl.l randomd0s
	adc.b [a0],y
	sta.w temp3,x
	tya
	clc
	adc.w #$0006
	tay
	lda.b [a0],y
	dey
	dey
	jsl.l randomd0s
	adc.b [a0],y
	sta.w temp4,x
.6:									; d0 = temp3,x, d1 = temp4,x, if pfgoal,x != 0 go to .1xxx, ...
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w pfgoal,x
	bne .1xxx
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.1xxx:								; a0 = EvadePC, go to skateto
	lda.w #EvadePC>>16
	sta.b a0+2
	lda.w #EvadePC
	sta.b a0
	jml.l skateto

.t1x:								; bare return, not branched to in this file
	rtl
