; The player skates in direction d0 (or glides or stops), turning toward it
;
; Takes player X and the wanted direction in d0 (low nibble: 0-7 direction, 8 none, 9 stop),
; d7 = frames elapsed. Decides skating backwards (pfrev), turns facedir toward the
; wanted direction and then accelerates through playeracc.
;
; Called from assgoalietopuck, assnothing, doinput, lineinput, skateto and skatetopuck.
doplayeracc:						; player X skates toward d0
	lda.w position,x				; goalie?
	bne .t4							; skater: .t4
	jml.l goalieacc					; the goalie has his own version

.t4:								; skater: not while a goalie sweep check is playing
	lda.w SPA,x						; sweep check in progress: nothing to do
	cmp.w #SPAsweepchk
	beq .t2
	lda.w #SPAglide					; d1 = glide animation
	sta.b d1
	lda.w pfrev,x					; skating backwards?
	beq .1							; not backwards: keep SPAglide
	lda.w #SPAglideback				; glide back animation
	sta.b d1
.1:									; low nibble of the wanted direction
	lda.b d0
	and.w #$000F					; low nibble: direction or 8/9
	sta.b d0
	cmp.w #$0008					; 0-7 is a real direction
	bcc .t3							; 0-7 is a real direction: .t3
	cmp.w #$0009					; 9 = stop
	bne .t1							; 8: no direction, just glide
	lda.w Xvel,x
	ora.w Yvel,x
	beq .t1							; not moving: glide
	jmp.w dostop					; still moving: slow down

.t1:								; no turn needed or no direction: glide unless already animating
	lda.w pf2aip,x
	bne .t2							; animation in progress: leave it
	jmp.w SetSPA					; start animation d1

.t2:								; return
	rtl

.t3:								;a direction: pfrev, then the turn
	lda.b d1						; save the animation
	pha								; 3,s = the animation (d1)
	lda.b d0						; and the wanted direction
	pha								; 1,s = the wanted direction (d0)
	sta.b d2						; d2 = wanted direction
	cpx.w puckc						; puck carrier?
	bne .t2x
	jmp.w .4						; the carrier never skates backwards

.t2x:								; dx to the puck
	lda.w puckx						; dx to the puck
	sec
	sbc.w Xpos,x					; minus the x of X
	sta.b d0						; d0 = puck x minus X x
	lda.w Ypos,x
	sta.b d3						; d3 = my y
	lda.w puckvy					; puck y velocity / 256
	xba
	and.w #$00FF
	cmp.w #$0080
	bcc .1x							; positive: no sign extension
	ora.w #$FF00
.1x:								; sign extended
	clc
	adc.w pucky						; plus the puck y
	sec
	sbc.b d3						; dy to the puck, led by its y velocity
	sta.b d1
	lda.w pfgoal,x					; mirror for the team shooting toward +y
	bne .2
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
	lda.w #$0000
	sec
	sbc.b d3
	sta.b d3
	lda.b d2						; and the wanted direction
	eor.w #$0004
	sta.b d2
.2:									; already skating backwards?
	lda.w pfrev,x					; already skating backwards?
	bne .t1x						; yes: .t1x
	lda.b d3						; backwards only in his own half (d3 negative)
	bpl .4
	lda.b d2						; and only when the wanted direction is 4
	cmp.w #$0004
	bne .4
	jsl.l vtoa						; vector to direction
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .4							; forward unless the puck direction is 7, 0 or 1
	bra .3

.t1x:								; already backwards: stay so only if the wanted direction allows
	lda.b d2						; already backwards: wanted direction 3, 4 or 5
	sec
	sbc.w #$0003
	and.w #$0007
	cmp.w #$0003
	bcs .4
	jsl.l vtoa						; vector to direction
	inc a
	inc a
	and.w #$0007
	cmp.w #$0005
	bcs .4
.3:									; backwards wanted: already so?
	lda.w pfrev,x
	bne .9							; yes: nothing to change
	lda.w Xvel,x
	sta.b d0						; moving?
	ora.w Yvel,x
	beq .1xx						; standing still: start backwards
	lda.w Yvel,x
	sta.b d1
	jsl.l vtoa						; vector to direction
	sec
	sbc.b 1,s
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .9							; not within one step of the wanted direction: stay forward
.1xx:								; start skating backwards
	inc a
	sta.w pfrev,x
	bra .9
.4:									; skate forwards
	stz.w pfrev,x					; skate forwards
.9:									; restore d0 and d1 from the stack
	pla								; d0 = wanted direction
	sta.b d0
	pla								; d1 = animation
	sta.b d1
	lda.w facedir,x					; facing direction
	sta.b d2
	lda.b d0
	sec
	sbc.b d2
	and.w #$0007					; d0 = wanted - facing
	asl a
	sta.b d0
	tax
	lda.l .10,x						; turn step for that difference
	ldx.b a3
	cmp.w #$0000					; no turn: noturn0
	bne .t2xx
	jmp.w noturn0

.t2xx:								; turning: build the speed measure d3 from the velocity high bytes
	tax
	lda.b d7
	jsl.l Mul8XS
	ldx.b a3
	sta.b tmp0
	lda.w Xvel,x
	xba
	and.w #$00FF
	cmp.w #$0080
	bcc .1xxx
	ora.w #$FF00
.1xxx:								; x velocity high byte, sign extended
	tax
	jsl.l Mul8S
	sta.b d4
	ldx.b a3
	lda.w Yvel,x
	xba
	and.w #$00FF
	cmp.w #$0080
	bcc .2x
	ora.w #$FF00
.2x:								; y velocity high byte, sign extended
	tax
	jsl.l Mul8S
	clc
	adc.b d4
	sta.b d3						; d3 = speed class
	lda.w #$0300					; turn rate base $300
	sec
	sbc.b d3						; falls as speed rises
	sta.b d4
	sec
	sbc.w #$0180					; down to $180
	bpl .3x
	lda.w #$0180
	sta.b d4
.3x:								; turn rate = $300 minus speed, at least $180
	lda.b tmp0						; turn step
	ldx.b d4
	jsl.l Mul16x8S
	lda.b r2+2
	sta.b d4+2
	lda.b r2
	sta.b d4
	ldx.b a3
	lda.w pfrev,x					; backwards: turn the other way
	beq .4x
	lda.w #$0000
	sec
	sbc.b d4
	sta.b d4
	lda.w #$0000
	sbc.b d4+2
	sta.b d4+2
.4x:								; add the turn to facefrac:facedir (16.16)
	lda.w facefrac,x				; facing fraction
	clc
	adc.b d4
	sta.w facefrac,x
	lda.w facedir,x					; facing direction
	adc.b d4+2
	and.w #$0007					; 0-7
	sta.w facedir,x
	sta.b d2						; d2 = new facing for playeracc
	lda.b d3						; fast enough for a turn animation?
	cmp.w #$0015					; slow: keep the animation
	bcc .7							; no: keep d1
	stz.b d1
	lda.b tmp0
	bpl .5
	lda.w #$FFCE
	sta.b d1
.5:									; pick the left or right turn animation
	lda.w attribute,x
	bit.w #$0800
	beq .6
	lda.b d1
	eor.w #$FFCE
	sta.b d1
.6:									; add the turn animation base
	lda.b d1
	clc
	adc.w #SPAturnr					; SPAturnr or SPAturnl
	sta.b d1
.7:									; start the turn animation unless one is running
	lda.w pf2aip,x
	bne .8
	jsl.l SetSPA
	lda.w #$0001
	sta.w pf2aip,x
.8:									; speed measure below 3: no acceleration
	lda.b d3
	cmp.w #$0003
	bcc .t1xx
	jmp.w revplayeracc				; accelerate (revplayeracc flips d2 when backwards)

.t1xx:								; return
	rtl
.10:								; steps for eight directions
	dw $0000,$0011,$0011,$0011,$0000,$FFEF,$FFEF,$FFEF
