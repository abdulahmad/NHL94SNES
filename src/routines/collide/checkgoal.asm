; Collision with the goal: over the top, into the net, off a post or off the side
checkgoal:							; called from checkwallcoll
	cpx.w #$001C					;the puck?
	beq .t3							;yes
	jmp.w checkgoalp				; player X runs into the goal a2

.t3:								; if puckc negative go to .1, ...
	ldy.w puckc						;carrier
	bmi .1							;loose
	lda.w position,y				;goalie carries it?
	beq .t1							;yes: no goal check
.1:									; if puckz - $000D >= 0 go to .t1, ...
	lda.w puckz						;puck height
	cmp.w #$000D					;over the net (13+)?
	bpl .t1							;yes: no contact
	ldy.b a2
	lda.b d2						; x of the object
	sec
	sbc.w Xpos,y					; minus the goal x
	sta.b d2
	cmp.w #$0017					;right of the net?
	bpl .t1							;yes: no contact
	lda.b d2
	cmp.w #$FFEA					;left of the net?
	bmi .t1							;yes: no contact
	lda.w #$0009					;net depth 9
	sta.b d5
	lda.b d3						; y of the object
	sec
	sbc.w Ypos,y					; minus the goal y
	sta.b d3
	cmp.w #$000A					;in front?
	bpl .t1							;yes: no contact
	lda.w #$0000
	sec
	sbc.b d5						;minus the depth
	sta.b d5
	lda.b d3
	cmp.w #$FFF7					;behind?
	bmi .t1							;yes: no contact
	lda.w #$FFFF					;collision handled
	sta.w collflag
	lda.w puckoldz					;height last frame
	cmp.w #$000D					;came over the top?
	bmi .t2							;no
	lda.w puckoldz
	sta.w puckz						;lands on the net
	jmp.w .10						;bounce off the top

.t1:								; return
	rtl

.t2:								;pfgoal of the puck = the carrier shot into his own goal
	stz.w pfgoal+puckobj			; clear pfgoal
	lda.w puckc						; carrier: loses the puck, nopuck 8
	bmi .2
	tay
	lda.w #$FFFF					; puck is loose
	sta.w puckc						;loose
	lda.w #$0008
	sta.w nopuck,y					; lockout 8
	lda.w pucky						;puck y
	sta.b d1
	lda.w pfgoal,y					;attacking the top?
	bne .1x							;yes
	lda.w #$0000
	sec
	sbc.b d1						;other end
	sta.b d1						;d1
.1x:								; if d1 >= 0 go to .2, ...
	lda.b d1						;which end?
	bpl .2							;own end: no
	lda.w #$0001
	sta.w pfgoal+puckobj			;shot into his own net
.2:									; d0 = $FF01, p0 = $FF01, d1 = Yfrac,x - OldYfrac,x, ...
	lda.w #$FF01					;-1 step x
	sta.b d0
	lda.w #$FF01					;-1 step y
	sta.b p0
	lda.w Yfrac,x					; y movement
	sec
	sbc.w OldYfrac,x
	sta.b d1
	lda.w Ypos,x					;minus old y
	sbc.w OldYpos,x					; minus old y
	sta.b d1+2
	lda.b d1+1						;whole pixels
	sta.b d1						; d1 = y movement
	cmp.w #$0000					;moving in y?
	beq .6							;no: off the side
	bmi .3							;upward
	lda.w #$0000
	sec
	sbc.b d0						;reversed
	sta.b d0
	lda.w #$0000
	sec
	sbc.b p0						;reversed
	sta.b p0
	lda.w #$0000
	sec
	sbc.b d5						;reversed
	sta.b d5
.3:									; d5 = d5 + d3, r2 = d5 + d3, d3 = Xfrac,x - OldXfrac,x, ...
	lda.b d5						; crossing depth
	clc
	adc.b d3						;plus the depth
	sta.b d5						;distance to the goal mouth
	sta.b r2						;r2
	lda.w Xfrac,x					; d3 = (Xpos - OldXpos) >> 8; d5*d3
	sec
	sbc.w OldXfrac,x				;minus old x
	sta.b d3
	lda.w Xpos,x
	sbc.w OldXpos,x					;minus old x
	sta.b d3+2
	lda.b d3+1						;whole pixels
	sta.b d3						;x movement
	ldx.b r2
	jsl.l Mul16S					;times the distance
	ldx.b a3
	lda.b d1						;y movement
	bit.w #$8000
	beq .4							;plus
	eor.w #$FFFF					; negate: two's complement
	inc a							;|dy|
.4:									; r1 = A, if r2+2 bits $8000 clear go to .5, ...
	sta.b r1						;r1
	lda.b r2+2						;product
	bit.w #$8000
	beq .5							;plus
	eor.w #$FFFF					; negate: two's complement
	inc a							;|product|
.5:									; if carry set go to .6, ...
	cmp.b r1						;more than |dy|?
	bcs .6							;yes: off the side
	lda.b d1						;dy
	sta.b r1						;r1
	jsl.l Div32S					;product / dy
	lda.b r0
	sta.b d5						;x shift back to the mouth
	ldx.b a3
	lda.b d2						; d2 = crossing x
	sec
	sbc.b d5						; minus
	sta.b d2
	cmp.w #$FFEA					;left of the mouth?
	bmi .6							;yes: off the side
	lda.b d2
	cmp.w #$0017					;right of the mouth?
	bmi .9							;no: into the mouth
.6:									; go to .11
	jmp.w .11
.7:									; if puckvy - $0800 >= 0 go to .1xx, ...
	lda.w puckvy					;y speed
	cmp.w #$0800					;fast?
	bpl .1xx						;yes
	cmp.w #$F800					;fast the other way?
	bmi .1xx						;yes
	cmp.w #$0000					;which way?
	bpl .t1x						;down: cap
	lda.w #$F800					;slow: at least -$800
	sta.w puckvy
	bra .1xx

.t1x:								;slow: at least $800
	lda.w #$0800
	sta.w puckvy
.1xx:								; go to wallcoll
	jmp.w wallcoll					; bounce object X off a wall
.8:									; d2 - $FFEF >= 0: go to Goal
	jmp.w Goal						; the puck is in the net: score, log, scoreboard, celebration
.9:									; d2 - $0017 negative: d1 = 0, eor p0, if minus go to .7, ...
	stz.b d1
	lda.w pucky						;puck y
	eor.b p0						;same side as the step?
	bmi .7							;no: off the back
	lda.w #$0000
	sec
	sbc.b p0						;reversed
	sta.b p0
	lda.w #$0000
	sec
	sbc.b d0						;reversed
	sta.b d0
	lda.w pfgoal+puckobj			;own goal shot?
	bne .7							;yes: bounce
	lda.w puckz						;height
	cmp.w #$000D					;exactly 13?
	beq .1xxx						;yes: off the crossbar
	lda.b d2
	cmp.w #$0012					;right post?
	bpl .1xxx						;yes: off the post
	lda.b d2
	cmp.w #$FFEF					;inside the left post?
	bpl .8							;yes: goal
.1xxx:								; call ChkShotStat, breakaway = 0, onetimer = 0, ...
	jsl.l ChkShotStat				; if a shot was taken, add it to the shooting team's shots
	stz.w breakaway					;no breakaway
	stz.w onetimer					;no one-timer
	lda.w #$0009					;post sound
	jsl.l PuckSfx					; play sound A with half the puck velocity
	lda.l Crowdlevel
	clc
	adc.w #$012C					;crowd
	sta.l Crowdlevel
	lda.w #$003C					;1 second
	sta.b crowdhold					;crowd holds
	lda.w CwdExciteLvl
	clc
	adc.w #$0028					;plus 40
	bmi .2x							;overflow: keep
	sta.w CwdExciteLvl				;excitement
.2x:								; call RandomWord, and #$0FFF, d0 = A, ...
	jsl.l RandomWord				;random
	and.w #$0FFF					;up to $FFF
	sta.b d0
	lda.w pucky						;puck y
	bmi .3x							;top: as is
	lda.w #$0000
	sec
	sbc.b d0						;reversed
	sta.b d0						;d0
.3x:								; puckvy = d0, call RandomWord, and #$1FFF, ...
	lda.b d0						;off the post
	sta.w puckvy					;puck y speed
	jsl.l RandomWord
	and.w #$1FFF					;random x
	sec
	sbc.w #$1000					;-$1000 to $FFF
	sta.w puckvx					; puck x velocity
	jsl.l RandomWord				;random
	and.w #$1FFF
	sec
	sbc.w #$1000
	sta.w puckvz					; puck z velocity
	jmp.w puckflip					;flip it
.10:								; if puckvz bits $8000 clear go to .1xxxx, ...
	lda.w puckvz					;z speed
	bit.w #$8000
	beq .1xxxx						;up: keep
	eor.w #$FFFF					;down
	inc a
.1xxxx:								;reversed
	sta.w puckvz
	rtl
.11:								; if puckvx - $0800 >= 0 go to .2xx, ...
	lda.w puckvx					;x speed
	cmp.w #$0800					;fast?
	bpl .2xx						;yes
	cmp.w #$F800					;fast the other way?
	bmi .2xx						;yes
	cmp.w #$0000					;which way?
	bpl .t1xx						;right: cap
	lda.w #$F800					;slow: at least -$800
	sta.w puckvx
	bra .2xx

.t1xx:								; puckvx = $0800
	lda.w #$0800
	sta.w puckvx
.2xx:								; d0 = 0, d1 = $00FF, d2 = puckx - OldXpos+puckobj, ...
	stz.b d0
	lda.w #$00FF
	sta.b d1
	lda.w puckx						; puck x
	sec
	sbc.w OldXpos+puckobj			; minus the old x
	sta.b d2
	bmi .1xxxxx
	lda.w #$FF01
	sta.b d1
.1xxxxx:							; go to wallcoll
	jmp.w wallcoll					; bounce object X off a wall
