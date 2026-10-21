; Player X skates to the puck, slowing down near it
;
; Takes player X. Aims at the point where the puck will be (skatetopuckinit) with a lead for
; his own velocity, re-aiming every few frames, then accelerates with doplayeracc. Skaters near
; the puck run Sweepcheck instead.
;
; Called from assnearest.
skatetopuck:						; player X skates to the puck
	jsl.l skatetopuckinit			; d0/d1 = puck spot
	lda.w temp2,x					; temp2 counts down frames to the next aim
	sec
	sbc.b d7
	sta.w temp2,x
	bmi .t1							; time up: aim again
	jmp.w .4						; else use the last direction

.t1:								; aim again: reload the timer
	adc.w #$0005
	sta.w temp2,x					; aim at the puck, steering around the goal
	jsl.l avdgoal
	lda.b d1
	pha								; save the avoid-goal target: 3,s = y (d1)
	lda.b d0
	pha								; 1,s = the avoid-goal target x (d0)
	txa
	jsl.l GetHot					; get the player's hot spot
	lda.b d0
	eor.w #$FFFF					; negate
	inc a
	sec
	sbc.w Xvel+1,x					; - high byte of Xvel
	and.w #$00FF
	bit.w #$0080
	beq .1
	ora.w #$FF00
.1:									; lead on the x velocity
	clc
	adc.b 1,s
	sec
	sbc.w Xpos,x
	sta.b d0						; d0 = X offset to the lead point
	lda.b d1
	eor.w #$FFFF					; negate
	inc a
org $9EB000
	sec
	sbc.w Yvel+1,x					; - high byte of Yvel
	and.w #$00FF
	bit.w #$0080
	beq .2
	ora.w #$FF00
.2:									; lead on the y velocity
	clc
	adc.b 3,s
	sec
	sbc.w Ypos,x
	sta.b d1						; d1 = Y offset to the lead point
	pla								; drop the saved target
	pla
	jsl.l vtoa						; vector to direction
	lda.b d0						; d0 = direction to the puck
	sta.w temp2b,x					; temp2b = direction to the puck
	lda.w position,x				; goalie?
	beq .4							; goalie: skate toward the puck
	lda.w puckvx					; puck direction of travel
	sta.b d0
	lda.w puckvy
	sta.b d1
	jsl.l vtoa						; vector to direction
	lda.b d0						; puck heading
	cmp.w #$0008					; puck not moving?
	beq .3							; not moving: face check
	eor.w #$0004					; opposite of the puck heading
	cmp.w facedir,x					; player faces that way?
	beq .4							; yes: skate
.3:									; check whether the player faces the puck
	lda.w pucky						; player to puck, Y
	sec
	sbc.w Ypos,x
	sta.b d1
	pha
	lda.w puckx
	sec								; player to puck, X
	sbc.w Xpos,x
	sta.b d0
	pha
	jsl.l vtoa						; vector to direction
	lda.b d0						; direction from player to puck
	sta.b tmp0
	pla								; restore the vector
	sta.b d0
	sta.b r0
	pla
	sta.b d1
	lda.w facedir,x					; facing direction
	cmp.b tmp0						; player must face the puck
	beq .5							; facing the puck: .5
.4:									; skate toward the stored direction
	lda.w temp2b,x
	sta.b d0
	jml.l doplayeracc
.5:									; puck loose?
	lda.w puckc
	bmi .4							; yes: skate
	lda.b r0						; distance to the puck scaled
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .1x
	ora.w #$E000
.1x:								; d0 term
	tax
	jsl.l Mul8S
	sta.b d0
	lda.b d1
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .2x
	ora.w #$E000
.2x:								; d1 term
	tax
	jsl.l Mul8S
	ldx.b a3						; player X again
	clc
	adc.b d0
	cmp.w #$000E					; puck too close: skate
	bcc .4
	cmp.w #$0028					; $28 or more away: skate
	bcs .t1x
	jmp.w Sweepcheck				; in between: sweep check

.t1x:								; skate
	bra .4							; skate
