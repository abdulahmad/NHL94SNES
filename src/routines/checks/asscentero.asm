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
.2:									; gmclock != 0: go to donothing
	jmp.w donothing					; computer player stands still
.3:									; d0 = $0011, go to assinsert
	lda.w #$0011
	sta.b d0
	jmp.w assinsert					; give player X assignment d0 on top of the current one
.7:									; if gmclock != 0 go to .2, ...
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
	lda.w #$FFFF					; no zone yet
	sta.w temp5,x					; clear the timers
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.1x:								; temp1,x = temp1,x - d7, if minus go to .t1, ...
	lda.w temp1,x					; every aidef frames
	sec
	sbc.b d7
	sta.w temp1,x					; expired: reevaluate
	bmi .t1
	jmp.w .6

.t1:								; temp1 ran out: add aidef,x to it and pick a new spot
	clc
	adc.w aidef,x					; reload from aidef
	bpl .2x							; not below zero
.1xx:								; falls through
	lda.w #$0000
.2x:								; temp1,x = A, d0 = pucky, if pfgoal,x != 0 go to .3x, ...
	sta.w temp1,x
	lda.w pucky						; d0 = pucky toward the attacking end
	sta.b d0
	lda.w pfgoal,x
	bne .3x
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.3x:								; d2 = 0, if minus go to .4, ...
	stz.b d2						; zone 0: own zone
	lda.b d0
	sec
	sbc.w #$FFA8					; first zone limit
	bmi .4
	lda.w #$0008					; zone 8
	sta.b d2
	lda.b d0
	sec
	sbc.w #$0058
	bmi .4
	ldy.b a2						; tmflags bit 4: stay in the middle zone
	lda.w tmflags,y
	bit.w #tmfoside
	bne .4
	asl.b d2						; zone 16
	lda.b d0
	sec
	sbc.w #$0108					; far zone limit
	bmi .4
	lda.w #$0018					; zone 24
	sta.b d2
.4:									; if d2 != temp5,x go to .5, ...
	lda.b d2						; same zone: new spot only 1 in 128
	cmp.w temp5,x					; same zone as last time?
	bne .5
	lda.w seed+2					; random
	cmp.w #$0200
	bcs .6
.5:									; temp5,x = d2, a0 = CenterOSpots, Y + 1, ...
	lda.b d2						; remember the zone
	sta.w temp5,x
	tay								; zone table
	lda.w #CenterOSpots>>16
	sta.b a0+2
	lda.w #CenterOSpots
	sta.b a0
	iny
	iny
	lda.b [a0],y					; x random range
	dey
	dey
	jsl.l randomd0s					; A = a random number from -A to A-1
	adc.b [a0],y					; plus the zone x
	sta.w temp3,x					; temp3 = spot x
	tya
	clc
	adc.w #$0006
	tay
	lda.b [a0],y					; y random range
	dey
	dey
	jsl.l randomd0s					; A = a random number from -A to A-1
	adc.b [a0],y					; plus the zone y
	sta.w temp4,x					; temp4 = spot y
.6:									; d0 = temp3,x, d1 = temp4,x, if pfgoal,x != 0 go to .1xxx, ...
	lda.w temp3,x					; spot x
	sta.b d0
	lda.w temp4,x					; spot y
	sta.b d1
	lda.w pfgoal,x					; which end
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
	jml.l skateto					; player X skates toward d0 / d1

.t1x:								; bare return, not branched to in this file
	rtl
