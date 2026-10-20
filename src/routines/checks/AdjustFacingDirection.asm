; Turn goalie X's facing one step toward d0, at most one step per 6 ticks ($0BCB,x)
; Takes: X = goalie object, d0 = wanted direction (0-7). Turns facedir one step the short way (+1 or -1,
; mod 8) unless the goalie's turn wait (goalieturnwait) is still running; then the wait is set to 6.
; Called from assgoalie, assgoalietopuck and assdumpin.
AdjustFacingDirection:				; turn the goalie one step toward d0
	lda.w facedir,x					; current facing
	sta.b r3
	lda.w goalieturnwait,x			; turn wait still running?
	bne .t1							; yes: count it down
	lda.b d0						; wanted direction
	sec
	sbc.b r3						; difference to the current facing
	beq .t1							; same: nothing to do
	eor.w #$FFFF					; negate the difference
	inc a
	and.w #$0004					; bit 2 of the negated difference tells the shorter way
	lsr a
	dec a							; step of +1 or -1
	sta.b d0
	clc								; add the step to the facing
	adc.b r3
	and.w #$0007					; wrap to 0-7
	sta.w facedir,x
	lda.w #$0006					; wait 6 ticks before the next step
	sta.w goalieturnwait,x
	rtl								; return

.t1:								; turn wait running: count it down
	lda.w goalieturnwait,x
	beq .rtl						; zero: nothing to do
	sec
	sbc.w timestep					; minus the time step
	bpl .1
	lda.w #$0000					; not below zero
.1:									; wait over
	sta.w goalieturnwait,x			; store the wait
.rtl:								; return
	rtl
