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
.1:									; playerpad,x >= 0: return
	rtl
.2:									; gmclock != 0: go to donothing
	jmp.w donothing				; computer player stands still
.3:									; d0 = $0011, go to assinsert
	lda.w #$0011
	sta.b d0
	jmp.w assinsert					; give player X assignment d0 on top of the current one
.8:									; if gmclock != 0 go to .2, ...
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
	lda.w #$FFFF					; temp5 = -1: no zone yet
	sta.w temp5,x
	stz.w temp1,x					; reset the timers
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.1x:								; temp1,x = temp1,x - d7, if minus go to .t1, ...
	lda.w temp1,x					; timer
	sec
	sbc.b d7						; minus the frame count
	sta.w temp1,x
	bmi .t1							; expired: reevaluate
	jmp.w .7

.t1:								; temp1 ran out: add aidef,x to it and pick a new spot
	clc
	adc.w aidef,x					; reload from aidef
	bpl .2x
.1xx:								; falls through
	lda.w #$0000					; not below zero
.2x:								; temp1,x = A, d0 = pucky, if zero go to .3x, ...
	sta.w temp1,x
	lda.w pucky						; d3 = pucky + puckvy / 64
	sta.b d0
	lda.w puckvy					; puck y velocity
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200					; sign extend
	beq .3x
	ora.w #$FC00
.3x:								; adc d0, d3 = A, if pfgoal,x != 0 go to .4, ...
	clc
	adc.b d0						; d3 = puck y plus velocity / 64
	sta.b d3
	lda.w pfgoal,x					; which end
	bne .4
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d3
	sta.b d3
.4:									; d2 = 0, if minus go to .5, ...
	stz.b d2						; zone 0: own zone
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
	bit.w #tmfoside					; offsides: stay back
	bne .5
	asl.b d2						; zone 16: their zone
	lda.b d3
	sec
	sbc.w #$0108
	bmi .5
	lda.w #$0018
	sta.b d2
.5:									; if d2 != temp5,x go to .6, ...
	lda.b d2
	cmp.w temp5,x					; same zone as last time?
	bne .6
	lda.w seed						; same zone: new spot only now and then
	cmp.w #$0200					; random
	bcs .7
.6:									; temp5,x = d2, a0 = long .9, ...
	lda.b d2
	sta.w temp5,x					; remember the zone
	tay
	lda.w #.9>>16
	sta.b a0+2
	lda.w #.9
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
.7:									; d0 = temp3,x, if position,x = $0005 go to .1xxx, ...
	lda.w temp3,x					; spot x
	sta.b d0
	lda.w position,x				; position 5: left wing
	cmp.w #$0005
	beq .1xxx
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.1xxx:								; d1 = temp4,x, if pfgoal,x != 0 go to .2xx, ...
	lda.w temp4,x					; spot y
	sta.b d1
	lda.w pfgoal,x					; which end
	bne .2xx
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.2xx:								; a0 = EvadePC, go to skateto
	lda.w #EvadePC>>16
	sta.b a0+2
	lda.w #EvadePC
	sta.b a0
	jml.l skateto					; player X skates toward d0 / d1

.t1x:								; bare return, not branched to in this file
	rtl
.9:									; dw $0050,$0014,$FFBA,$000A, dw $0064,$0014,$003C,$000A, dw $003C,$003...
	dw $0050,$0014,$FFBA,$000A
	dw $0064,$0014,$003C,$000A
	dw $003C,$0032,$00E6,$0014
	dw $0050,$001E,$00FA,$0014
