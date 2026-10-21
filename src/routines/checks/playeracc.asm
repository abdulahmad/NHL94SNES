; Accelerate player X in direction d2, up to his top speed
;
; Takes player X in curobj, d2 = direction (0-7) and d7 = frames elapsed. Adds a step in that
; direction to the velocity scaled by weight and leg strength, refuses it if the speed would pass
; the limit for his rating and energy, and wears the energy down (1 call in 64).
;
; Called from assgoalie, assstanley, goalieacc and noturn0.
playeracc:							; player X accelerates toward direction d2
	asl.b d2						; 4 bytes per direction entry
	asl.b d2
	ldx.b d2						; index of the direction
	lda.l .8+2,x					; y step of the direction
	sta.b d1
	lda.l .8,x						; x step of the direction
	sta.b d0
	ldx.b curobj					; player X
	lda.w Wallsin,x					; wall sin of the last wall collision
	beq .1
	eor.b d0						; pushing into the wall in x?
	bpl .1
	stz.b d0						; yes: cancel the x step
.1:									; wall cos
	lda.w Wallcos,x					; wall cos of the last wall collision
	beq .2
	eor.b d1						; pushing into the wall in y?
	bmi .2
	stz.b d1						; yes: cancel the y step
.2:									; acceleration factor: $20 - weight/8 + 1.5 * leg strength
	lda.w weight,x					; weight / 8
	lsr a
	lsr a
	lsr a
	eor.w #$FFFF					; negate
	inc a
	clc
	adc.w #$0020
	clc
	adc.w legstr,x					; plus leg strength
	sta.b d2
	lda.w legstr,x					; half the leg strength again
	lsr a
	adc.b d2
	sta.b d2
	lda.w position,x				; skater: .7
	bne .7							; skaters keep the factor
	lda.w playerpad,x				; goalie without a pad?
	bmi .t1
	cpx.w puckc						; puck carrier?
	beq .t1
	lda.w legstr,x					; human goalie: plus twice the leg strength and 8
	asl a
	adc.b d2
	adc.w #$0008
	sta.b d2
	bra .7

.t1:								; computer goalie or carrier
	lda.b d2
	ldy.w passReceiverPlayerNum		; a pass receiver exists?
	bmi .1x							; no receiver: keep the factor
	sec
	sbc.w legstr,x					; receiver: minus leg strength
.1x:								; store the factor
	clc								; plus 8
	adc.w #$0008
	sta.b d2
.7:									; step * factor * frames elapsed added to the velocity
	lda.b d2
	pha								; keep the factor
	ldx.b d0						; x step
	jsl.l Mul8XS					; A * X, 8 by 8 bits, X signed, into A
	tax
	lda.b d7						; d7 = frames elapsed
	jsl.l Mul16x8XS
	ldx.b curobj
	lda.b r2
	adc.w Xvel,x					; plus the old x velocity
	sta.b d0						; d0 = new x velocity
	xba								; x velocity high byte, sign extended
	and.w #$00FF
	cmp.w #$0080
	bcc .1xx
	ora.w #$FF00
.1xx:								; x speed squared
	tax
	jsl.l Mul8S						; d3 = x term
	sta.b d3
	pla								; factor again
	ldx.b d1						; y step
	jsl.l Mul8XS					; A * X, 8 by 8 bits, X signed, into A
	tax
	lda.b d7
	jsl.l Mul16x8XS
	ldx.b curobj
	lda.b r2
	adc.w Yvel,x					; plus the old y velocity
	sta.b d1						; d1 = new y velocity
	xba								; y velocity high byte, sign extended
	and.w #$00FF
	cmp.w #$0080
	bcc .2x
	ora.w #$FF00
.2x:								; y speed squared
	tax
	jsl.l Mul8S						; y speed squared
	clc
	adc.b d3						; d3 = squared speed measure
	sta.b d3
	lda.b d1						; keep the new velocities
	pha
	lda.b d0
	pha
	ldx.b curobj
	jsl.l getpde					; energy of the player
	lda.w legspd,x					; leg speed
	pha
	lda.l OptLine					; line change option
	cmp.w #$0002					; automatic?
	bne .3							; no: use the energy
	lda.w #$1000					; automatic: fixed energy $1000
	sta.b d0
.3:									; energy to a speed class
	lda.b d0						; energy / 2 + $800
	lsr a
	clc
	adc.w #$0800
	tax
	pla								; leg speed * 16
	asl a
	asl a
	asl a
	asl a
	jsl.l Mul16x8U					; scaled by the energy
	lda.b r2+2
	asl a							; index into the table of 4 byte entries
	asl a
	tax
	lda.l MaxSpeed,x				; max speed squared for the rating level
	sta.b d2
	lda.l MaxSpeed+2,x
	sta.b d2+2
	ldx.b curobj
	lda.w position,x				; skater: no goalie reduction
	bne .4
	lda.w playerpad,x				; goalie with a pad?
	bmi .4
	lda.w goalieflags,x				; goalie flags bit 2 set?
	bit.w #$0004
	bne .4
	lda.b d2+2						; goalie: a quarter off the limit
	lsr a
	lsr a
	eor.w #$FFFF
	inc a
	adc.b d2+2
	sta.b d2+2
.4:									; restore the new velocities
	pla								; new velocities back
	sta.b d0
	pla
	sta.b d1
	lda.b d2+2						; limit not below the new speed measure?
	cmp.b d3
	bcc .5							; too fast: keep the old velocity
	lda.b d0
	sta.w Xvel,x					; store the new velocity
	lda.b d1
	sta.w Yvel,x
.5:									; energy drain
	lda.l OptLine					; only with line changes on
	beq .t1x
	lda.w seed						; 1 call in 64
	and.w #$003F
	bne .t1x
	jsl.l getpde					; d0 = the energy of player X
	lda.b d0
	sec
	sbc.w #$0021					; lower the energy by 33
	sta.b d0
	cmp.w #$0C00					; below $C00: just lower it
	bmi .6
	lda.w endurance,x				; above $C00: also add the endurance byte
	sta.b d2
	clc
	adc.b d0
	sta.b d0
.6:									; store the energy
	jml.l setpde					; store the energy

.t1x:								; return
	rtl
.8:									; x and y steps (words) for eight directions
	dw $0000,$0006,$0004,$0004,$0006,$0000,$0004,$FFFC
	dw $0000,$FFFA,$FFFC,$FFFC,$FFFA,$0000,$FFFC,$0004
