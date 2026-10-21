; Pass the puck in the pass direction, to the best teammate there if any
dopass:								; called from chk4pass, passmode
	stz.w onetimerreq
	lda.w #$0004
	trb.w sflags
	lda.w #$FFFF
	sta.w puckc
	lda.w #$0010
	sta.w nopuck,x
	txa
	lsr a
	sta.w lastplayer
	lda.w #$0007
	sta.b d0
	lda.w position,x
	beq .1
	lda.w passacc,x
	sta.b d0
.1:									; passspeed = d0 * 2 * 2 + $0090, d4 = $FFFF, d3 = $0005, ...
	lda.b d0
	asl a
	asl a
	adc.w #$0090
	sta.w passspeed
	lda.w #$FFFF
	sta.b d4
	lda.w #$0005
	sta.b d3
	stz.b a1
	cpx.w #$000C
	bcc .2
	lda.w #$000C
	sta.b a1
.2:									; loop: if zero go to .5, ...
	cpx.b a1
	beq .5
	ldy.b a1
	lda.w position,y
	bmi .5
	beq .5
	lda.w pflags,y
	bit.w #$1000
	bne .5
	lda.w puckdir,y
	sec
	sbc.w passdir
	sec
	sbc.w #$0004
	stz.b r0
	and.w #$0007
	beq .4
	cmp.w #$0001
	beq .3
	cmp.w #$0007
	bne .5
.3:									; r0 = $1000
	lda.w #$1000
	sta.b r0
.4:									; if carry set go to .5, ...
	lda.b r0
	clc
	adc.w puckdist2,y
	bcs .5
	cmp.b d4
	bcs .5
	sta.b d4
	lda.b a1
	sta.b a0
.5:									; increment a1, increment a1, decrement d3, ...
	inc.b a1
	inc.b a1
	dec.b d3
	bmi .t1
	jmp.w .2

.t1:								; d3 counted below 0: if d4 negative go to .t2, ...
	ldx.b a3
	lda.b d4
	bmi .t2
	jsl.l dopass_count
	lda.w #$0000
	jsl.l PuckSfx					; play sound A with half the puck velocity
	jmp.w dopass_swing

.t2:								; d4 negative: a0 = long passdir * 2 * 2 + dirtab+2, ror a, ...
	lda.w passdir
	asl a
	asl a
	adc.w #dirtab+2
	sta.b a0
	lda.w #dirtab>>16
	sta.b a0+2
	lda.b [a0]
	cmp.w #$8000
	ror a
	tax
	lda.w #$0050
	jsl.l Mul8XS					; A * X, 8 by 8 bits, X signed, into A
	asl a
	sta.b r3
	ldx.b curobj
	lda.w Yvel,x
	cmp.w #$8000
	ror a
	clc
	adc.b r3
	sta.w puckvy
	dec.b a0
	dec.b a0
	lda.b [a0]
	cmp.w #$8000
	ror a
	tax
	lda.w #$0050
	jsl.l Mul8XS					; A * X, 8 by 8 bits, X signed, into A
	asl a
	sta.b r3
	ldx.b curobj
	lda.w Xvel,x
	cmp.w #$8000
	ror a
	clc
	adc.b r3
	sta.w puckvx
	jsl.l RandomWord
	and.w #$0FFF
	sta.w puckvz
; dopass once the puck velocity is set: a goalie never passes back toward his net, then the pass animation
; (SPAgswing / SPApassf); assdumpin ends here too
dopass_swing:						; called from assdumpin, dopass
	lda.w position,x
	bne .2
	lda.w pfgoal,x
	beq .t1
	lda.w puckvy
	bmi .1
	bra .2

.t1:								; pfgoal,x = 0: if puckvy negative go to .2
	lda.w puckvy
	bmi .2
.1:									; eor #$FFFF, increment a, puckvy = A
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.w puckvy
.2:									; d0 = puckvx, d1 = puckvy, call vtoa, ...
	lda.w puckvx
	sta.b d0
	lda.w puckvy
	sta.b d1
	jsl.l vtoa						; direction of the vector d0 / d1
	ldy.w #SPAgswing
	lda.w position,x
	beq .1x
	ldy.w #SPApassf
	jsl.l Findhittype				; swing type of player X for direction d0
	beq .1x
	ldy.w #SPApassb
.1x:								; d1 = Y, call SetSPA, pfalock,x = $0001, ...
	sty.b d1
	jsl.l SetSPA
	lda.w #$0001
	sta.w pfalock,x
	lda.w position,x
	bne .rtl
	lda.w playerpad,x
	bmi .rtl
	stz.w Xvel,x
	stz.w Yvel,x
	sta.b d4
	jsl.l findpc					; choose the player for pad d4
.rtl:								; return
	rtl
dopass_count:						; called from dopass
	jsl.l loadTeamStruct			; a2 = player X's team, a1 = the other team
	lda.w gmclock
	bne .1
	ldy.b a2
	lda.w tmpassatt,y
	inc a
	sta.w tmpassatt,y
.1:									; temp1,x = aidef,x / 2 + $0001 + temp1,x, passReceiverPlayerNum = a0, ...
	ldx.w topgoalie,y
	lda.w aidef,x
	lsr a
	clc
	adc.w #$0001
	adc.w temp1,x
	sta.w temp1,x
	lda.b a0
	sta.w passReceiverPlayerNum
	ldx.b a0
	lda.w #$0015
	sta.b d0
	jsl.l assinsert					; give player X assignment d0 on top of the current one
	ldx.b a3
	ldy.b a0
	lda.w frame,y
	pha
	lda.w attribute,y
	bit.w #$0800
	beq .t1
	lda.w #$0000
	sec
	sbc.w facedir,y
	bra .2

.t1:								; attribute,y bits $0800 clear: falls through
	lda.w facedir,y
.2:									; and #$0007, asl a, frame,y = SPAonetimerf&$FF0000,x, ...
	and.w #$0007
	asl a
	tax
	lda.l SPAonetimerf,x
	tax
	lda.l SPAonetimerf&$FF0000,x	;the first frame of SPAonetimerf in that direction:
									;GetHot below takes its hot spot
	ldx.b a3
	ldy.b a0
	sta.w frame,y
	lda.b a0
	jsl.l GetHot
	ldy.b a0
	pla
	sta.w frame,y
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	lda.w #$0018
	sta.b d6
	lda.b d6
	asl a
	asl a
	asl a
	asl a
	ldy.b a0
	ldx.w Xvel,y
	jsl.l Mul16XS
	lda.b r2+2
	clc
	adc.b d0
	sta.b d2
	lda.b d6
	asl a
	asl a
	asl a
	asl a
	ldx.w Yvel,y
	jsl.l Mul16XS
	lda.b r2+2
	clc
	adc.b d1
	sta.b d3
	ldy.b d2
	jsl.l ApproxLength				; A = the approximate length of the vector
	sta.b d4
	asl a
	tax
	lda.w #$0003
	jsl.l DivX8U					; X / A into A with the hardware divider
	cmp.w #$0040
	bcc .t1x
	cmp.w #$0050
	bcc .4
	ldx.b d4
	lda.w #$0005
	jsl.l DivX8U					; X / A into A with the hardware divider
	sta.b d6
	lda.w #$0050
	bra .3

.t1x:								; d6 = d4 / 2 / 2
	lda.b d4
	lsr a
	lsr a
	sta.b d6
	lda.w #$0040
.3:									; call Mul16XS, d2 = r2+2 + d0, call Mul16XS, ...
	pha
	lda.b d6
	asl a
	asl a
	asl a
	asl a
	ldy.b a0
	ldx.w Xvel,y
	jsl.l Mul16XS
	lda.b r2+2
	clc
	adc.b d0
	sta.b d2
	lda.b d6
	asl a
	asl a
	asl a
	asl a
	ldx.w Yvel,y
	jsl.l Mul16XS
	lda.b r2+2
	clc
	adc.b d1
	sta.b d3
	ldy.b d2
	jsl.l ApproxLength				; A = the approximate length of the vector
	sta.b d4
	pla
.4:									; d5 = A, passspeed = A, call randomd0s, ...
	sta.b d5
	sta.w passspeed
	ldx.b curobj
	lda.w #$0010
	sec
	sbc.w passacc,x
	jsl.l randomd0s					; A = a random number from -A to A-1
	clc
	adc.b d5
	sta.b d5
	ldx.b d2
	jsl.l Mul16x8XS
	lda.b d4
	sta.b r1
	jsl.l Div32S
	lda.b r0
	xba
	and.w #$FF00
	sta.w puckvx
	lda.b d5
	ldx.b d3
	jsl.l Mul16x8XS
	lda.b d4
	sta.b r1
	jsl.l Div32S
	lda.b r0
	xba
	and.w #$FF00
	sta.w puckvy
	lda.b d2
	clc
	adc.w puckx
	sta.w passtargetx
	lda.b d3
	clc
	adc.w pucky
	sta.w passtargety
	lda.b d4
	asl a
	asl a
	asl a
	sta.w puckvz
	lda.w #$000A
	sta.w nopuck+puckobj
	ldy.b a0
	lda.b d6
	clc
	adc.w #$0006
	sta.w passwait,y
	ldx.b curobj
	lda.b d6
	sta.w nopuck,x
	ldy.b a2
	lda.w playerpad,x
	sta.w passpad,y
	lda.w position,x
	bne .rtl
	lda.w playerpad,x
	bmi .rtl
	stz.w Xvel,x
	stz.w Yvel,x
	lda.w playerpad,x
	sta.b d4
	lda.w passReceiverPlayerNum
	sta.b d0
	jsl.l AssignPadIfFree			; AssignPadPlayer when player d0 has no pad yet
	lda.w playerpad,x
	bmi .rtl
	jsl.l findpc					; choose the player for pad d4
.rtl:								; return
	rtl
