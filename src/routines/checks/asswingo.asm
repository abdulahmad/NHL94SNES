; Assignment: a wing on offense skates to a spot in the zone of the puck
asswingo:							; X = wing; asstab entry, skates to a spot via skateto
	cpx.w puckc
	beq .3
	ldy.w puckc
	bmi .8
	lda.w pfteam,x
	cmp.w pfteam,y
	beq .8
	lda.w #$0003
	sta.b d0
	jmp.w assreplace
.1:
	rtl
.2:
	jmp.w assnothing
.3:
	lda.w #$0011
	sta.b d0
	jmp.w assinsert
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
	lda.w #$FFFF
	sta.w temp5,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.1x:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .t1
	jmp.w .7

.t1:								; temp1 ran out: add aidef,x to it and pick a new spot
	clc
	adc.w aidef,x
	bpl .2x
.1xx:
	lda.w #$0000
.2x:
	sta.w temp1,x
	lda.w pucky
	sta.b d0
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .3x
	ora.w #$FC00
.3x:
	clc
	adc.b d0
	sta.b d3
	lda.w pfgoal,x
	bne .4
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d3
	sta.b d3
.4:
	stz.b d2
	lda.b d3
	sec
	sbc.w #$FFA8
	bmi .5
	lda.w #$0008
	sta.b d2
	lda.b d0
	sec
	sbc.w #$0058
	bmi .5
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoside
	bne .5
	asl.b d2
	lda.b d3
	sec
	sbc.w #$0108
	bmi .5
	lda.w #$0018
	sta.b d2
.5:
	lda.b d2
	cmp.w temp5,x
	bne .6
	lda.w seed
	cmp.w #$0200
	bcs .7
.6:
	lda.b d2
	sta.w temp5,x
	tay
	lda.w #$009E
	sta.b a0+2
	lda.w #.9
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
.7:
	lda.w temp3,x
	sta.b d0
	lda.w position,x
	cmp.w #$0005
	beq .1xxx
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.1xxx:
	lda.w temp4,x
	sta.b d1
	lda.w pfgoal,x
	bne .2xx
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.2xx:
	lda.w #EvadePC>>16
	sta.b a0+2
	lda.w #EvadePC
	sta.b a0
	jml.l skateto

.t1x:								; bare return, not branched to in this file
	rtl
.9:
	dw $0050,$0014,$FFBA,$000A
	dw $0064,$0014,$003C,$000A
	dw $003C,$0032,$00E6,$0014
	dw $0050,$001E,$00FA,$0014
