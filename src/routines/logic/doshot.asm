; The stick is at the puck: launch it toward the goal
doshot:								; called from ShotMode, assbreakaway, asspassrec
	jsl.l shotdiradj				;aim adjust
	lda.w #$0007
	pha								; 1,s = the shot code (7 until set below)
	lda.w #sfssdir
	trb.w sflags					;clear the shot-pending flag
	sta.w pfalock,x					;animation locked
	stx.w shotplayer				;shooter
	cpx.w puckc						;has the puck?
	beq .t2							;yes: shoot
	jmp.w .7						;no: just the sound

.t2:								; 1,s = $0001, tsb sflags, if SPA,x != SPAshotb go to .1, ...
	lda.w #$0001					;sound 1 (slap)
	sta.b 1,s
	lda.w #sf2shot
	tsb.w sflags					;shot flag
	lda.w SPA,x						;his animation
	cmp.w #SPAshotb					;backhand?
	bne .1							;no
	lda.w #$0001					;sound 1
	sta.b 1,s
	lda.w passspeed					;shot power
	lsr a							;/4
	lsr a
	eor.w #$FFFF					;minus a quarter
	inc a
	clc
	adc.w passspeed					;plus the power
	sta.w passspeed					;backhand: 3/4 power
.1:									; lastshotspeed = passspeed, if carry clear go to .2, ...
	lda.w passspeed					;power
	sta.w lastshotspeed				;last shot speed
	cmp.w #$001E					;hard (30+)?
	bcc .2							;no
	lda.w #$0002					;sound 2 (hard)
	sta.b 1,s
.2:									; a0 = X, call makepde, adc #$0014, ...
	lda.w shotspd,x					;shot rating
	stx.b a0						;shooter
	jsl.l makepde					; d0 = rating A scaled by player a0's energy
	adc.w #$0014					;plus 20
	tax
	lda.w passspeed					;power
	jsl.l Mul16x8U					;times the rating
	ldx.b r2						;product
	lda.w #$2570					;$2570
	jsl.l Mul16U					;scaled
	lda.b r2+2						;high word
	sta.w passspeed					;shot speed
	lda.w breakaway					;breakaway?
	beq .3							;no
	jsl.l CheckBreakaway			;still one?
	lda.w IsBreakaway
	sta.w breakaway					;breakaway
.3:									; puckc = $FFFF, nopuck,x = $0010, lastplayer = curobj / 2, ...
	ldx.b curobj
	lda.w #$FFFF					;puck loose
	sta.w puckc
	lda.w #$0010					;shooter can't touch it
	sta.w nopuck,x
	txa
	lsr a							;object / 2
	sta.w lastplayer				;last to touch it
	ldy.w #$0108					;goal line at the top
	lda.w pfgoal,x					;attacking end
	bne .4							;top
	ldy.w #$FEF8					;bottom
.4:									; d1 = Y, a0 = doshot_shotsets, d0 = [a0],y - puckx, ...
	sty.b d1						;goal line y
	lda.w passdir					;shot direction
	asl a
	asl a							;x4
	tay
	lda.w #doshot_shotsets>>16
	sta.b a0+2
	lda.w #doshot_shotsets			;target table
	sta.b a0
	lda.b [a0],y					;target x
	sec
	sbc.w puckx						;minus the puck x
	sta.b d0						;d0 = dx
	iny
	iny
	lda.b [a0],y					;target z
	sta.b d2						;d2
	pha								; z diff (d2): 7,s at the .3x pha
	lda.b d1
	sec
	sbc.w pucky
	sta.b d1						;minus the puck y
	pha								;d1 = dy
	lda.b d0
	pha								;dx
	lda.b d0
	ldy.b d1
	jsl.l ApproxLength				;distance
	cmp.w #$0000					;zero?
	bne .5							;no
	inc a							;at least 1
.5:									; d3 = A, if gmode bits gmhl clear go to .t1, ...
	sta.b d3						;d3 = distance
	lda.w gmode						;game mode
	bit.w #gmhl						; gmhl: highlights are always perfect
	beq .t1							;no
	jmp.w .6						;highlight: exact

.t1:								; gmode bits gmhl clear: if d3 >= $00C9 go to .1x, ...
	lda.b d3
	cmp.w #$00C9					;far (201+)?
	bcs .1x							;yes: aim error
	lda.w #$0010					;16
	adc.w shotacc,x					;plus his accuracy
	jsl.l randoma8					;random
	cmp.w #$000F					; chance of a perfect shot
	bcs .6							;15 or more?
.1x:								;yes: perfect
	lda.w passspeed					;speed
	lsr a							;/8
	lsr a
	lsr a
	sec
	sbc.w shotacc,x					;minus his accuracy
	clc
	adc.w #$0010					;plus 16
	ldx.b d3						;distance
	jsl.l Mul16U					;times the error
	lda.b r2						;product
	lsr a							;/64
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0						;d0 = error
	lda.b d3						;distance
	cmp.w #$00FB					; closer than 251: half the error
	bcs .2x							;far: full error
	lsr.b d0						;near: half the error
.2x:								; if d0 < Sideline go to .3x, ...
	lda.b d0						;error
	cmp.w #Sideline					;over $88?
	bcc .3x
	lda.w #Sideline					;cap
	sta.b d0
.3x:								;error
	pha								; 1,s adjust, 3,s x diff, 5,s y diff; after its pla 5,s is the z diff
	jsl.l randomas					;random +-
	adc.b 3,s						;plus dx
	sta.b 3,s						;new dx
	lda.b 1,s						;error
	sta.b d0
	cmp.w #$003D					;over 60?
	bcc .4x
	lda.w #$003C					;cap at 60
	sta.b d0
	sta.b 1,s
.4x:								;dy
	lda.b 5,s						;down: full error
	bpl .5x							;up: half
	lsr.b d0
.5x:								; call randomd0s, 5,s = 5,s + d0, call randomd0A, ...
	jsl.l randomd0s					;random +- d0
	lda.b 5,s						;dy
	adc.b d0						;plus the error
	sta.b 5,s						;new dy
	pla								;error
	lsr a							;half
	jsl.l randomd0A					;random lift
	adc.b 5,s						;plus dz
	sta.b 5,s						;new dz
.6:									; call Mul8XS, call Mul16S, r1 = d3, ...
	ldx.w passspeed					;speed
	lda.w #$0044					;$44
	jsl.l Mul8XS					;speed x $44
	plx								;dx
	jsl.l Mul16S					;times dx
	lda.b d3						;distance
	sta.b r1
	jsl.l Div32S					;divided by the distance
	lda.b r0
	asl a							;x2
	sta.w puckvx					;puck x speed
	ldx.w passspeed					;speed
	lda.w #$0044
	jsl.l Mul8XS					;speed x $44
	plx								;dy
	jsl.l Mul16S					;times dy
	lda.b d3						;distance
	sta.b r1
	jsl.l Div32S					;divided by the distance
	lda.b r0
	asl a							;x2
	sta.w puckvy					;puck y speed
	ldx.b curobj
	pla								;dz
	beq .7							;flat shot: no lift
	tax
	lda.w passspeed					;speed
	jsl.l Mul16x8U					;times dz
	ldx.b r2
	lda.w #$0044					;$44
	jsl.l Mul16x8U					;product
	lda.b d3						;distance
	sta.b r1
	jsl.l Div32U					;divided by the distance
	lda.b r0
	asl a							;x2
	sta.b d1						;d1
	lda.w #$0B33					;gravity term $B33
	ldx.b d3						;distance
	jsl.l Mul16U					;product
	lda.w passspeed					;speed
	sta.b r1
	jsl.l Div32U					;divided by the speed
	ldx.b curobj
	lda.b r0
	lsr a							;half
	adc.b d1						;plus d1
	cmp.w #$1801					;over $1800?
	bcc .1xx
	lda.w #$1800					;cap
.1xx:								; puckvz = A
	sta.w puckvz					;puck z speed
.7:									; call PuckSfx, if pfgoal,x != 0 go to .1xxx, ...
	pla								;sound
	jsl.l PuckSfx					;play it
	ldx.b a3						;shooter
	ldy.w #$0108					;goal line at the top
	lda.w pfgoal,x					;attacking end
	bne .1xxx						;top
	ldy.w #$FEF8					;bottom
.1xxx:								; tmp0 = Y, eor puckvy, if plus go to .2xx, ...
	sty.b tmp0
	tya								;goal y
	sec
	sbc.w pucky						;minus the puck y
	eor.w puckvy					;same sign as the y speed?
	bpl .2xx						;yes
	lda.w #$0000
	sec
	sbc.w puckvy					;reverse
	sta.w puckvy					;toward the goal
.2xx:								; if PenShotActive = 0 go to .rtl, ...
	lda.w PenShotActive				;penalty shot?
	beq .rtl						;no
	lda.w #$0012					;assignment $12
	sta.b d0
	jsl.l assreplace				;after the shot
.rtl:								; return
	rtl
