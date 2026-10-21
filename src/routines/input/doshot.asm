; The stick is at the puck: launch it toward the goal
doshot:								; called from ShotMode, assbreakaway, asspassrec
	jsl.l shotdiradj
	lda.w #$0007
	pha								; 1,s = the shot code (7 until set below)
	lda.w #$0008
	trb.w sflags
	sta.w pfalock,x
	stx.w shotplayer
	cpx.w puckc
	beq .t2
	jmp.w .7

.t2:								; 1,s = $0001, tsb sflags, if SPA,x != SPAshotb go to .1, ...
	lda.w #$0001
	sta.b 1,s
	lda.w #$1000
	tsb.w sflags
	lda.w SPA,x
	cmp.w #SPAshotb
	bne .1
	lda.w #$0001
	sta.b 1,s
	lda.w passspeed
	lsr a
	lsr a
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.w passspeed
	sta.w passspeed
.1:									; lastshotspeed = passspeed, if carry clear go to .2, ...
	lda.w passspeed
	sta.w lastshotspeed
	cmp.w #$001E
	bcc .2
	lda.w #$0002
	sta.b 1,s
.2:									; a0 = X, call makepde, adc #$0014, ...
	lda.w shotspd,x
	stx.b a0
	jsl.l makepde					; d0 = rating A scaled by player a0's energy
	adc.w #$0014
	tax
	lda.w passspeed
	jsl.l Mul16x8U
	ldx.b r2
	lda.w #$2570
	jsl.l Mul16U
	lda.b r2+2
	sta.w passspeed
	lda.w breakaway
	beq .3
	jsl.l CheckBreakaway
	lda.w IsBreakaway
	sta.w breakaway
.3:									; puckc = $FFFF, nopuck,x = $0010, lastplayer = curobj / 2, ...
	ldx.b curobj
	lda.w #$FFFF					; puck loose
	sta.w puckc
	lda.w #$0010					; no puck pickup for 16 frames
	sta.w nopuck,x
	txa
	lsr a
	sta.w lastplayer
	ldy.w #$0108
	lda.w pfgoal,x
	bne .4
	ldy.w #$FEF8
.4:									; d1 = Y, a0 = shotsets, d0 = [a0],y - puckx, ...
	sty.b d1
	lda.w passdir
	asl a
	asl a
	tay
	lda.w #shotsets>>16
	sta.b a0+2
	lda.w #shotsets
	sta.b a0
	lda.b [a0],y
	sec
	sbc.w puckx
	sta.b d0
	iny
	iny
	lda.b [a0],y
	sta.b d2
	pha								; z diff (d2): 7,s at the .3x pha
	lda.b d1
	sec
	sbc.w pucky
	sta.b d1
	pha								; y diff (d1): 5,s at the .3x pha
	lda.b d0
	pha								; x diff (d0): 3,s at the .3x pha
	lda.b d0
	ldy.b d1
	jsl.l ApproxLength				; A = the approximate length of the vector
	cmp.w #$0000
	bne .5
	inc a
.5:									; d3 = A, if gmode bits gmhl clear go to .t1, ...
	sta.b d3
	lda.w gmode
	bit.w #gmhl						; gmhl: highlights are always perfect
	beq .t1
	jmp.w .6

.t1:								; gmode bits gmhl clear: if d3 >= $00C9 go to .1x, ...
	lda.b d3
	cmp.w #$00C9					; too far away for a perfect shot
	bcs .1x
	lda.w #$0010
	adc.w shotacc,x
	jsl.l randoma8					; random number below A
	cmp.w #$000F					; chance of a perfect shot
	bcs .6
.1x:								; call Mul16U, d0 = r2 / 2 / 2 / 2 / 2 / 2 / 2, if d3 >= $00FB go to .2...
	lda.w passspeed
	lsr a
	lsr a
	lsr a
	sec
	sbc.w shotacc,x
	clc
	adc.w #$0010
	ldx.b d3
	jsl.l Mul16U
	lda.b r2
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	lda.b d3
	cmp.w #$00FB					; closer than 251: half the error
	bcs .2x
	lsr.b d0
.2x:								; if d0 < sideline go to .3x, ...
	lda.b d0
	cmp.w #sideline					; clamp $88
	bcc .3x
	lda.w #sideline
	sta.b d0
.3x:								; call randomd0s, adc 3,s, 3,s = A, ...
	pha								; 1,s adjust, 3,s x diff, 5,s y diff; after its pla 5,s is the z diff
	jsl.l randomd0s					; A = a random number from -A to A-1
	adc.b 3,s
	sta.b 3,s
	lda.b 1,s
	sta.b d0
	cmp.w #$003D					; max 60
	bcc .4x
	lda.w #$003C
	sta.b d0
	sta.b 1,s
.4x:								; if 5,s >= 0 go to .5x, ...
	lda.b 5,s
	bpl .5x
	lsr.b d0
.5x:								; call randomd0sd0, 5,s = 5,s + d0, call randoma, ...
	jsl.l randomd0sd0				; randomd0s with the range in d0
	lda.b 5,s
	adc.b d0
	sta.b 5,s
	pla
	lsr a
	jsl.l randoma					; A = a random number from 0 to A-1
	adc.b 5,s
	sta.b 5,s
.6:									; call Mul8XS, call Mul16S, r1 = d3, ...
	ldx.w passspeed
	lda.w #$0044
	jsl.l Mul8XS					; A * X, 8 by 8 bits, X signed, into A
	plx
	jsl.l Mul16S					; signed 32-bit multiply
	lda.b d3
	sta.b r1
	jsl.l Div32S					; signed divide
	lda.b r0
	asl a
	sta.w puckvx
	ldx.w passspeed
	lda.w #$0044
	jsl.l Mul8XS					; A * X, 8 by 8 bits, X signed, into A
	plx
	jsl.l Mul16S					; signed 32-bit multiply
	lda.b d3
	sta.b r1
	jsl.l Div32S					; signed divide
	lda.b r0
	asl a
	sta.w puckvy
	ldx.b curobj
	pla
	beq .7
	tax
	lda.w passspeed
	jsl.l Mul16x8U
	ldx.b r2
	lda.w #$0044
	jsl.l Mul16x8U					; mulres = mula*mulb
	lda.b d3
	sta.b r1
	jsl.l Div32U
	lda.b r0
	asl a
	sta.b d1
	lda.w #$0B33
	ldx.b d3
	jsl.l Mul16U					; mulres = mula*mulb
	lda.w passspeed
	sta.b r1
	jsl.l Div32U
	ldx.b curobj
	lda.b r0
	lsr a
	adc.b d1
	cmp.w #$1801
	bcc .1xx
	lda.w #$1800
.1xx:								; puckvz = A
	sta.w puckvz
.7:									; call PuckSfx, if pfgoal,x != 0 go to .1xxx, ...
	pla
	jsl.l PuckSfx					; play sound A with half the puck velocity
	ldx.b a3
	ldy.w #$0108
	lda.w pfgoal,x
	bne .1xxx
	ldy.w #$FEF8
.1xxx:								; tmp0 = Y, eor puckvy, if plus go to .2xx, ...
	sty.b tmp0
	tya
	sec
	sbc.w pucky
	eor.w puckvy
	bpl .2xx
	lda.w #$0000
	sec
	sbc.w puckvy
	sta.w puckvy
.2xx:								; if PenShotActive = 0 go to .rtl, ...
	lda.w PenShotActive
	beq .rtl
	lda.w #$0012
	sta.b d0
	jsl.l assreplace
.rtl:								; return
	rtl
