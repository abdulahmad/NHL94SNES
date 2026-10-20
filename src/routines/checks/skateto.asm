; Skate toward d0 / d1, with a routine in a0 for avoiding others; slow down near the target
;
; Takes player X, d0 / d1 = target and a0 = routine that may change the direction (called
; through jmlvector). Every $0C frames it recalculates the direction from the target, the
; velocity lead and the distance left; direction 9 (stop) is used when close to the target.
;
; Called from assbench, assbreakaway, asscenterd, asscentero, assdefd, assdefo, assgoalie,
; assnearest, asspenalty, asspuckc, assscore, asswingd and asswingo.
skateto:							; player X skates toward d0 / d1
	lda.w temp2,x					; skateto timer
	sec
	sbc.w timestep
	sta.w temp2,x
	bmi .t2							; time up: aim again
	jmp.w .7						; else keep the direction from last time

.t2:								; aim again: reload the timer
	adc.w #$000C
	sta.w temp2,x
	lda.b d0						; target kept in d0+2 / d1+2
	sta.b d0+2
	lda.b d1
	sta.b d1+2
	jsl.l avdgoal					; steer the target around the goal
	lda.w Xvel,x					; x velocity high byte
	xba
	and.w #$00FF
	bit.w #$0080
	beq .1
	ora.w #$FF00
.1:									; lead on the x velocity
	eor.w #$FFFF
	inc a
	sta.b r3
	clc
	adc.b d0						; plus the target x
	sec
	sbc.w Xpos,x					; minus my x
	sta.b d0
	lda.w Yvel,x					; y velocity high byte
	xba
	and.w #$00FF
	bit.w #$0080
	beq .2
	ora.w #$FF00
.2:									; lead on the y velocity
	eor.w #$FFFF
	inc a
	sta.b r3+2
	clc
	adc.b d1						; plus the target y
	sec
	sbc.w Ypos,x					; minus my y
	sta.b d1
	lda.w position,x				; goalie?
	bne .3							; yes: .3
	lda.w goalieflags,x
	bit.w #$0002
	beq .5							; skater: direction only (.5)
.3:									; goalie or flag bit 1: slow down near the target
	lda.b d0
	pha
	lda.b d1
	pha
	ldy.w Xvel,x					; speed of the player (ApproxLength of Xvel, Yvel)
	lda.w Yvel,x
	jsl.l ApproxLength
	pha								; keep the speed
	lda.b r3						; target minus the lead
	clc
	adc.b d0+2
	sec
	sbc.w Xpos,x					; minus my x
	tay
	lda.b r3+2
	clc
	adc.b d1+2
	sec
	sbc.w Ypos,x					; minus my y
	jsl.l ApproxLength				; distance left to the target
	tay
	pla
	sta.b r3						; r3 = speed
	pla
	sta.b d1
	pla
	sta.b d0
	lda.b r3						; fast (>= $1000)?
	cmp.w #$1000
	bcs .t1							; yes: stop only within 12
	cpy.w #$0005					; slow: stop within 5
	bpl .5							; farther: aim
	bra .4							; close: stop

.t1:								; fast: farther than 12 away?
	cpy.w #$000C
	bpl .5
.4:									; close to the target: direction 9 = stop
	lda.w #$0009
	sta.b d0
	bra .6							; then the avoid routine
.5:									; direction toward the target
	jsl.l vtoa
.6:									; call the avoid routine in a0
	lda.b a0						; caller's avoidance routine
	sta.w jmlvector+1
	lda.b a0+1
	sta.w jmlvector+2
	jsl.l jmlvector					; may adjust the direction in d0
	lda.b d0						; remember the direction
	sta.w temp2b,x
	cmp.w #$0008
	bcc .7							; a real direction: done
	lda.w Xvel,x					; no direction: moving?
	ora.w Yvel,x
	bne .7							; moving: keep it
	lda.w puckx						; stand still: face the puck
	sec
	sbc.w Xpos,x					; minus my x
	sta.b d0
	lda.w pucky
	sec
	sbc.w Ypos,x					; minus my y
	sta.b d1
	jsl.l vtoa						; vector to direction
.7:									; use the stored direction
	lda.w temp2b,x					; stored direction
	sta.b d0
	jml.l doplayeracc				; accelerate that way
