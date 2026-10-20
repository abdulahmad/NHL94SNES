; Player X skates to the puck, slowing down near it
skatetopuck:
	jsl.l skatetopuckinit			; d0/d1 = puck spot
	lda.w temp2,x					; temp2 counts down frames to the next aim
	sec
	sbc.b d7
	sta.w temp2,x
	bmi .t1
	jmp.w .4

.t1:
	adc.w #$0005
	sta.w temp2,x					; aim at the puck, steering around the goal
	jsl.l avdgoal
	lda.b d1
	pha								; save the avoid-goal target
	lda.b d0
	pha
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
.1:
	clc
	adc.b r0+1,s
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
.2:
	clc
	adc.b r0+3,s
	sec
	sbc.w Ypos,x
	sta.b d1
	pla								; drop the saved target
	pla
	jsl.l vtoa						; vector to direction
	lda.b d0						; d0 = direction to the puck
	sta.w temp2b,x					; temp2b = direction to the puck
	lda.w position,x
	beq .4
	lda.w puckvx					; puck direction of travel
	sta.b d0
	lda.w puckvy
	sta.b d1
	jsl.l vtoa						; vector to direction
	lda.b d0
	cmp.w #$0008
	beq .3
	eor.w #$0004
	cmp.w facedir,x
	beq .4
.3:
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
	pla
	sta.b d0
	sta.b r0
	pla
	sta.b d1
	lda.w facedir,x
	cmp.b tmp0						; player must face the puck
	beq .5
.4:
	lda.w temp2b,x
	sta.b d0
	jml.l doplayeracc
.5:
	lda.w puckc
	bmi .4
	lda.b r0
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .1x
	ora.w #$E000
.1x:
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
.2x:
	tax
	jsl.l Mul8S
	ldx.b a3
	clc
	adc.b d0
	cmp.w #$000E
	bcc .4
	cmp.w #$0028
	bcs .t1x
	jmp.w Sweepcheck

.t1x:
	bra .4
