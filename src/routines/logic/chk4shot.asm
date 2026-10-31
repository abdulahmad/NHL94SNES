; A computer player looks for a shot
chk4shot:							; called from asspuckc
	lda.w gmclock
	bne .t2
	lda.w gameclock
	cmp.w #$0005
	bcs .t2
	jmp.w CompShoot					; computer player X shoots

.t2:								; if PenShotActive != 0 go to .t1, ...
	lda.w PenShotActive
	bne .t1
	jsl.l chkpk						; Z if X is killing a penalty
	bne .t1							; not a penalty killer
	lda.w threat					; threat on the puck carrier
	beq .t1
	lda.w Ypos,x					; |Y| of the player
	cmp.w #$FF13
	bmi .t1
	cmp.w #$00ED
	bpl .t1
	lda.w seed						; one time in four: clear the puck
	and.w #$0003
	bne .t1
	jmp.w StartDumpIn

.t1:								; d4 = $0020 - spodds,x * 2 * 2 * 2 * 2, if pfgoal,x != 0 go to .1, ...
	lda.w #$0020
	sec
	sbc.w spodds,x
	asl a
	asl a
	asl a
	asl a
	sta.b d4
	ldy.w #$0108
	lda.w pfgoal,x
	bne .1
	ldy.w #$FEF8
.1:									; d1 = Y, d1 = Y - pucky, if plus go to .3, ...
	sty.b d1
	tya
	sec
	sbc.w pucky
	sta.b d1
	cmp.w #$0064
	bpl .3
	cmp.w #$FF9C
	bmi .3
	lda.w puckx
	cmp.w #$0064
	bpl .3
	cmp.w #$FF9C
	bmi .6
	eor.w #$FFFF					; negate: two's complement
	inc a
	pha
	tax
	jsl.l Mul8S						; A * X, 8 by 8 bits, both signed, into A
	sta.b d0
	lda.b d1
	tax
	jsl.l Mul8S						; A * X, 8 by 8 bits, both signed, into A
	ldx.b curobj
	clc
	adc.b d0
	sta.b tmp0
	pla								; restore Y
	sta.b d0
	lda.b tmp0
	cmp.w #$2711					; distance^2 > 100*100?
	lsr.b d4
	lsr.b d4
	lsr.b d4
	lsr.b d4
	jsl.l vtoa						; direction of the vector d0 / d1
	sta.b d5						; d5 = direction to the goal
	lda.w #$0005					; 6 opponents
	sta.b d3
	ldy.w #$0000
	cpx.w #$000C
	bcs .2
	ldy.w #$000C
.2:									; if position,y = 0 go to .4, ...
	lda.w position,y				; empty slot: the goalie
	beq .4
	lda.w puckdir,y
	sec
	sbc.w #$0004
	and.w #$0007
	cmp.b d5
	bne .5
	asl.b d4
	bra .5
.3:									; go to .6
	bra .6
.4:									; position,y = 0: if pf2aip,y = 0 go to .5, ...
	lda.w pf2aip,y					; goalie flagged (pf2aip): shoot now
	beq .5
	stz.b d3						; stop checking
	lda.w #$0001
	sta.b d4
.5:									; Y + 1, Y + 1, decrement d3, ...
	iny
	iny
	dec.b d3
	bpl .2
.6:									; call randomd0A, if carry set go to .t1x, ...
	lda.b d4
	jsl.l randomd0A					; A = a random number from 0 to A-1
	cmp.w #$0009					; no shot if random(d4) > 8
	bcs .t1x						; too unlikely: no shot
	lda.w pucky
	sta.b d0						; d0 = puck Y relative to our goal
	lda.w pfgoal,x
	bne .1x
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.1x:								; if d0 negative go to .t1x, ...
	lda.b d0
	bmi .t1x
	lda.w #$0108
	sec
	sbc.b d0
	bmi .t1x						; beyond the blue line: no shot
	lda.w PenShotActive				; sf2offsig: player is offside
	beq .2x
	lda.w #$00B0
	lsr a
	lsr a
	clc
	adc.w #$0058
	sec
	sbc.b d0
	bpl .t1x
.2x:								; if sflags bit $8000 set go to .t1x, ...
	lda.w sflags
	bit.w #$8000
	bne .t1x
	jmp.w CompShoot					; computer player X shoots

.t1x:								; return
	rtl
