; The goalie skates in direction d0, turning one step toward it
;
; Takes goalie X and the wanted direction in d0. Runs a turn pause (goalieturnwait),
; turns facedir one eighth toward d0 and skates with playeracc, or just slows down.
;
; Called from doplayeracc.
goalieacc:							; goalie X skates toward d0
	lda.w #SPAgready				; SPAgready (2)
	sta.b d1						; ready animation
	lda.b d0						; direction
	and.w #$000F					; 4 bits
	sta.b d0						; keep it
	cmp.w #$0008					; 8 = no direction
	bcc .t2							; 0-7 is a real direction: .t2
	ldy.w playerpad,x				; pad of the goalie
	bpl .1							; has a pad: only stop when moving
	cmp.w #$0009					; no pad: only direction 9 stops
	bne .2
.1:									; stop requested: still moving?
	lda.w Xvel,x
	ora.w Yvel,x
	bne .t3							; yes: slow down
.2:									; nothing to do: ready animation
	lda.w pf2aip,x					; animation in progress?
org $9ED002
	bne .t1							; yes: leave it
	jml.l SetSPA					; start the ready animation

.t1:								; return
	rtl

.t2:								;d0 = wanted direction: step facedir one eighth toward it
	cpx.w puckc						; puck carrier?
	beq .t4							; carrier: turn one step
	lda.w asscur,x					; assignment of the goalie
	cmp.w #$000C					; assignment $0C: turn one step
	beq .t4
	lda.w Ypos,x					; distance from the middle (abs y)
	bit.w #$8000
	beq .1x
	eor.w #$FFFF
	inc a
.1x:								; abs y
	cmp.w #$0098					; less than $98 from the middle: turn one step
	bcc .t4							; near his goal: turn one step
	ldy.w playerpad,x				; human controlled?
	bmi .2x							; no: skate
	lda.w SPA,x						; diving or injured animation?
	cmp.w #SPAgdive
	bcc .2x
	cmp.w #SPAinjury1
	bcc .t3							; diving: only friction
.2x:								; skate toward d0 without turning
	lda.b d0
	cmp.w facedir,x					; already facing it?
	beq .3							; yes: no turn needed
	sta.b d2						; d2 = direction for playeracc
	lda.w #SPAgready				; ready animation
	jsl.l SetSPAFromA
	jml.l playeracc					; accelerate

.t3:								; friction only
	jmp.w StopNA					; slow down

.t4:								; turn one step toward d0
	lda.w goalieturnwait,x			; turn pause running?
	bne .3							; yes: wait
	lda.b d0
	sec
	sbc.w facedir,x					; difference to the facing
	sta.b d0						; d0 = difference
	beq .3							; facing the wanted way: nothing to turn
	eor.w #$FFFF					; negate
	inc a
	and.w #$0004					; one step (+1/-1) toward d0
	lsr a							; +1 or -1
	dec a
	clc								; plus the facing
	adc.w facedir,x
	and.w #$0007					; 0-7
	sta.b d0						; d0 = new direction
	sta.w facedir,x					; new facing
	lda.w #$0006					; wait 6 before the next turn step
	sta.w goalieturnwait,x
.3:									; count down the turn pause
	lda.w goalieturnwait,x			; turn pause left?
	beq .2xx
	sec								; minus the frames elapsed
	sbc.w timestep
	bpl .1xx						; not below zero
	lda.w #$0000
.1xx:								; store the countdown
	sta.w goalieturnwait,x
.2xx:								; goalie flag bit 2: skating
	lda.w goalieflags,x
	bit.w #$0002
	bne .t1x						; skating: skate animation
	lda.w #SPAgready
	bra .4

.t1x:								; skating animation
	lda.w #SPAgskate
.4:									; start the animation
	jsl.l SetSPAFromA				; animation in A
	lda.w facedir,x
	sta.b d2						; skate that way
	jml.l playeracc					; d2 = facedir, bank $8F (d2 = direction)
