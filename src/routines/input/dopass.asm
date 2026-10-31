; Pass the puck in the pass direction, to the best teammate there if any
dopass:								; called from chk4pass, passmode
	stz.w onetimerreq				;no one-timer request
	lda.w #$0004					; sflags bit $0004
	trb.w sflags					;clear the carry flag
	lda.w #$FFFF					; puckc = -1: puck not held
	sta.w puckc						;puck loose
	lda.w #$0010
	sta.w nopuck,x					;passer can't touch it for 16
	txa
	lsr a							;object number
	sta.w lastplayer				;last to touch it
	lda.w #$0007					;goalie pass accuracy 7
	sta.b d0
	lda.w position,x				;goalie?
	beq .1							;yes
	lda.w passacc,x					;pass accuracy
	sta.b d0
.1:									; passspeed = d0 * 2 * 2 + $0090, d4 = $FFFF, d3 = $0005, ...
	lda.b d0
	asl a							;x4
	asl a
	adc.w #$0090					;plus $90
	sta.w passspeed					;pass speed
	lda.w #$FFFF					; no candidate yet
	sta.b d4						;best distance none
	lda.w #$0005					; 6 players
	sta.b d3						;6 teammates
	stz.b a1						; a1 = first player of the team
	cpx.w #$000C					;home first object
	bcc .2							;visitors?
	lda.w #$000C					;no
	sta.b a1						;visitors first object
.2:									; loop: if zero go to .5, ...
	cpx.b a1						;the passer?
	beq .5							;skip
	ldy.b a1						;teammate
	lda.w position,y				;on the ice?
	bmi .5							;no
	beq .5							;goalie: no
	lda.w pflags,y					;flags
	bit.w #$1000					;falling?
	bne .5							;yes: skip
	lda.w puckdir,y					;his direction from the puck
	sec
	sbc.w passdir
	sec
	sbc.w #$0004					;opposite?
	stz.b r0						;no penalty
	and.w #$0007					;mod 8
	beq .4							;straight along it
	cmp.w #$0001					;one off?
	beq .3							;penalty
	cmp.w #$0007					;one off the other way?
	bne .5							;no: skip
.3:									; r0 = $1000
	lda.w #$1000					;penalty $1000
	sta.b r0
.4:									; if carry set go to .5, ...
	lda.b r0						;penalty
	clc
	adc.w puckdist2,y				;plus his distance
	bcs .5							;overflow: skip
	cmp.b d4						;nearer than the best?
	bcs .5							;no
	sta.b d4						;best distance
	lda.b a1						; best teammate so far
	sta.b a0						;best receiver
.5:									; increment a1, increment a1, decrement d3, ...
	inc.b a1						;next object
	inc.b a1
	dec.b d3						;count
	bmi .t1							;all six
	jmp.w .2

.t1:								; d3 counted below 0: if d4 negative go to .t2, ...
	ldx.b a3						;passer
	lda.b d4						;best distance
	bmi .t2							;no receiver: blind pass
	jsl.l dopass_count				;aim at the receiver
	lda.w #$0000					;sound 0
	jsl.l PuckSfx					; play sound A with half the puck velocity
	jmp.w dopass_swing				;swing

.t2:								; d4 negative: a0 = long passdir * 2 * 2 + dirtab+2, ror a, ...
	lda.w passdir					;pass direction
	asl a
	asl a							;x4
	adc.w #dirtab+2					;unit vector y
	sta.b a0
	lda.w #dirtab>>16
	sta.b a0+2
	lda.b [a0]						;y step
	cmp.w #$8000					;sign into carry
	ror a							;half
	tax
	lda.w #$0050					;x 80
	jsl.l Mul8XS					; A * X, 8 by 8 bits, X signed, into A
	asl a							;x2
	sta.b r3
	ldx.b curobj					;passer
	lda.w Yvel,x					;his y speed
	cmp.w #$8000
	ror a							;half
	clc
	adc.b r3						;plus the pass
	sta.w puckvy					;puck y speed
	dec.b a0
	dec.b a0
	lda.b [a0]						;unit vector x
	cmp.w #$8000					;x step
	ror a							;sign into carry
	tax								;half
	lda.w #$0050
	jsl.l Mul8XS					;x 80
	asl a							;x2
	sta.b r3
	ldx.b curobj
	lda.w Xvel,x					;his x speed
	cmp.w #$8000
	ror a							;half
	clc
	adc.b r3						;plus the pass
	sta.w puckvx					;puck x speed
	jsl.l RandomWord				;random
	and.w #$0FFF					;lift 0-$FFF
	sta.w puckvz					;puck z speed
; dopass once the puck velocity is set: a goalie never passes back toward his net, then the pass animation
; (SPAgswing / SPApassf); assdumpin ends here too
dopass_swing:						; called from assdumpin, dopass
	lda.w position,x				;goalie?
	bne .2							;no: swing
	lda.w pfgoal,x					;attacking end
	beq .t1							;top
	lda.w puckvy					;y speed
	bmi .1							;toward his net: reverse
	bra .2

.t1:								;y speed
	lda.w puckvy					;toward his net?
	bmi .2
.1:									; eor #$FFFF, increment a, puckvy = A
	eor.w #$FFFF					;reverse
	inc a
	sta.w puckvy					;puck y speed
.2:									; d0 = puckvx, d1 = puckvy, call vtoa, ...
	lda.w puckvx					;puck direction
	sta.b d0
	lda.w puckvy					;from the speed
	sta.b d1
	jsl.l vtoa						; direction of the vector d0 / d1
	ldy.w #SPAgswing				;goalie swing
	lda.w position,x				;goalie?
	beq .1x							;yes
	ldy.w #SPApassf					;forehand pass
	jsl.l Findhittype				;forehand or backhand?
	beq .1x							;forehand
	ldy.w #SPApassb					;backhand pass
.1x:								; d1 = Y, call SetSPA, pfalock,x = $0001, ...
	sty.b d1						;animation
	jsl.l SetSPA					;start it
	lda.w #$0001					; lock the assignment
	sta.w pfalock,x					;locked
	lda.w position,x				;goalie?
	bne .rtl						;no: done
	lda.w playerpad,x				;his pad
	bmi .rtl						;none: done
	stz.w Xvel,x					;goalie stops
	stz.w Yvel,x
	sta.b d4						;pad
	jsl.l findpc					;pad goes to a skater
.rtl:								; return
	rtl
dopass_count:						; called from dopass
	jsl.l loadTeamStruct			; a2 = player X's team, a1 = the other team
	lda.w gmclock					;clock stopped?
	bne .1							;yes: no stat
	ldy.b a2						;team
	lda.w tmpassatt,y				;pass attempts
	inc a							;plus one
	sta.w tmpassatt,y
.1:									; temp1,x = aidef,x / 2 + $0001 + temp1,x, passReceiverPlayerNum = a0, ...
	ldx.w topgoalie,y				;opposing goalie
	lda.w aidef,x					;his defense
	lsr a							;half
	clc
	adc.w #$0001					;plus his wait
	adc.w temp1,x					;he reacts later
	sta.w temp1,x
	lda.b a0						;receiver
	sta.w passReceiverPlayerNum		;pass receiver
	ldx.b a0
	lda.w #$0015					;assignment $15: take the pass
	sta.b d0
	jsl.l assinsert					; give player X assignment d0 on top of the current one
	ldx.b a3						;passer
	ldy.b a0						;receiver
	lda.w frame,y					;his frame
	pha								;keep it
	lda.w attribute,y				;attribute
	bit.w #$0800					;flipped?
	beq .t1							;no
	lda.w #$0000
	sec
	sbc.w facedir,y					;facing
	bra .2

.t1:								; attribute,y bits $0800 clear: falls through
	lda.w facedir,y					;his facing
.2:									; and #$0007, asl a, frame,y = SPAonetimerf&$FF0000,x, ...
	and.w #$0007					;mod 8
	asl a							;word index
	tax
	lda.l SPAonetimerf,x			;one-timer animation
	tax
	lda.l SPAonetimerf&$FF0000,x	;first frame
	ldx.b a3
	ldy.b a0
	sta.w frame,y					;use it for the hot spot
	lda.b a0
	jsl.l GetHot					;stick spot
	ldy.b a0
	pla								;restore
	sta.w frame,y					;his frame
	lda.b d1						;stick y offset
	clc
	adc.w Ypos,y					;plus his y
	sec
	sbc.w pucky						;minus the puck y
	sta.b d1						;d1 = dy to the stick
	lda.b d0						;stick x offset
	clc
	adc.w Xpos,y					;plus his x
	sec
	sbc.w puckx						;minus the puck x
	sta.b d0						;d0 = dx to the stick
	lda.w #$0018					;24 frames ahead
	sta.b d6
	lda.b d6
	asl a							;x16
	asl a
	asl a
	asl a
	ldy.b a0
	ldx.w Xvel,y					;his x speed
	jsl.l Mul16XS					;times the lead
	lda.b r2+2						;predicted
	clc
	adc.b d0						;d2
	sta.b d2
	lda.b d6
	asl a							;x16
	asl a
	asl a
	asl a
	ldx.w Yvel,y					;his y speed
	jsl.l Mul16XS					;times the lead
	lda.b r2+2						;predicted
	clc
	adc.b d1						;d3
	sta.b d3
	ldy.b d2
	jsl.l ApproxLength				;distance to the lead spot
	sta.b d4						;d4
	asl a							;x2
	tax
	lda.w #$0003					;3
	jsl.l DivX8U					;2d / 3
	cmp.w #$0040					;short pass?
	bcc .t1x						;yes: slow
	cmp.w #$0050					;medium?
	bcc .4							;yes: speed as is
	ldx.b d4
	lda.w #$0005					;distance
	jsl.l DivX8U					; X / A into A with the hardware divider
	sta.b d6						;/5: frames to get there
	lda.w #$0050					;lead
	bra .3							;long: speed $50

.t1x:								; d6 = d4 / 2 / 2
	lda.b d4						;distance
	lsr a
	lsr a							;/4
	sta.b d6						;lead
	lda.w #$0040					;speed $40
.3:									; call Mul16XS, d2 = r2+2 + d0, call Mul16XS, ...
	pha								;keep the speed
	lda.b d6						;lead
	asl a
	asl a
	asl a							;x16
	asl a
	ldy.b a0
	ldx.w Xvel,y					;his x speed
	jsl.l Mul16XS					;times the lead
	lda.b r2+2
	clc
	adc.b d0						;plus dx
	sta.b d2						;d2
	lda.b d6
	asl a							;x16
	asl a
	asl a
	asl a
	ldx.w Yvel,y					;his y speed
	jsl.l Mul16XS					;times the lead
	lda.b r2+2
	clc
	adc.b d1						;plus dy
	sta.b d3						;d3
	ldy.b d2
	jsl.l ApproxLength				;distance again
	sta.b d4						;d4
	pla								;speed
.4:									; d5 = A, passspeed = A, call randomd0s, ...
	sta.b d5						;d5
	sta.w passspeed					;pass speed
	ldx.b curobj					;passer
	lda.w #$0010					;16
	sec
	sbc.w passacc,x					;minus his accuracy
	jsl.l randomd0s					;random spread
	clc
	adc.b d5						;plus the speed
	sta.b d5						;d5
	ldx.b d2						;dx
	jsl.l Mul16x8XS					;times the speed
	lda.b d4
	sta.b r1						;divided by
	jsl.l Div32S					;the distance
	lda.b r0
	xba								;to 8.8
	and.w #$FF00
	sta.w puckvx					;puck x speed
	lda.b d5						;speed
	ldx.b d3						;dy
	jsl.l Mul16x8XS					;times the speed
	lda.b d4
	sta.b r1						;divided by
	jsl.l Div32S					;the distance
	lda.b r0
	xba								;to 8.8
	and.w #$FF00
	sta.w puckvy					;puck y speed
	lda.b d2						;dx
	clc
	adc.w puckx						;plus the puck x
	sta.w passtargetx				;target x
	lda.b d3						;dy
	clc
	adc.w pucky						;plus the puck y
	sta.w passtargety				;target y
	lda.b d4						;distance
	asl a
	asl a
	asl a							;x8
	sta.w puckvz					;lift
	lda.w #$000A					;10 frames
	sta.w nopuck+puckscnum			;puck can't be touched
	ldy.b a0						;receiver
	lda.b d6						;lead
	clc
	adc.w #$0006					;plus 6
	sta.w passwait,y				;his wait
	ldx.b curobj					;passer
	lda.b d6
	sta.w nopuck,x					;he waits that long
	ldy.b a2						;team
	lda.w playerpad,x				;his pad
	sta.w passpad,y					;pass pad
	lda.w position,x				;goalie?
	bne .rtl						;no: done
	lda.w playerpad,x				;his pad
	bmi .rtl						;none: done
	stz.w Xvel,x					;goalie stops
	stz.w Yvel,x
	lda.w playerpad,x				;pad
	sta.b d4						;d4
	lda.w passReceiverPlayerNum		;receiver
	sta.b d0						;d0
	jsl.l AssignPadIfFree			;pad goes to the receiver
	lda.w playerpad,x				;his pad
	bmi .rtl						;none: done
	jsl.l findpc					;choose the player
.rtl:								; return
	rtl
