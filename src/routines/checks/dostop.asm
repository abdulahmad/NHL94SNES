; The player stops
;
; Takes player X. Players slower than $1000 on both axes only lose speed (StopNA);
; faster players start the glide animation (backwards) or the stop animation, and the puck
; carrier plays the stop sound.
;
; Called from doplayeracc and noturn0.
dostop:								; player X stops or glides
	lda.w Xvel,x					; both speeds within +-$1000?
	cmp.w #$EFFF
	bmi .1
	cmp.w #$1001
	bpl .1
	lda.w Yvel,x
	cmp.w #$EFFF
	bmi .1
	cmp.w #$1001
	bmi StopNA						; slow already: just apply friction
.1:									; moving fast: glide or stop animation
	lda.w #SPAglide					; glide animation
	ldy.w pfrev,x					; skating backwards?
	bne .3							; yes: glide only
	cpx.w puckc						; puck carrier?
	bne .2							; no: stop animation
	lda.w Xvel,x					; carrier: velocity into p0 for the stop sound
	sta.b p0
	lda.w Yvel,x
	sta.b p0+2
	lda.w #$0011					; skate stop sound $11
	jsl.l sfx						; play sound A with the velocity in p0 / p0+2
.2:									; stop animation
	lda.w #SPAstop					; SPAstop
	sta.w pf2aip,x					; pf2aip: animation in progress
.3:									; start the animation
	jsl.l SetSPAFromA				; animation in A

; Takes player X and d7 = frames elapsed. Human goalies lose half their speed per call,
; everybody else gets friction of ($70 + legstr) * timestep per axis, down to zero.
;
; Falls in from dostop; called from assgoalie and goalieacc.
StopNA:								; slow player X: no animation change
	lda.w position,x				; goalie?
	bne .t1							; skater: friction
	lda.w playerpad,x				; goalie without a pad?
	bmi .t1							; computer goalie: friction
	cpx.w puckc						; puck carrier?
	beq .t1							; carrier: friction
	lda.w Xvel,x					; human goalie: halve both velocities
	cmp.w #$8000
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	cmp.w #$8000
	ror a
	sta.w Yvel,x
	rtl								; return

.t1:								; friction by the leg strength
	phx								; friction = ($70 + legstr) * timestep
	lda.w #$0070
	clc
	adc.w legstr,x
	ldx.w timestep
	jsl.l Mul8U						; r2 = friction step
	sta.b r2
	plx
	lda.w Xvel,x					; X velocity toward zero
	bpl .t2							; positive: subtract
	clc
	adc.b r2
	sta.w Xvel,x
	bmi .2							; still negative: keep
	bra .1							; crossed zero: clear

.t2:								; positive X velocity
	sec
	sbc.b r2
	sta.w Xvel,x
	bpl .2							; still positive: keep
.1:									; clear X velocity
	stz.w Xvel,x
.2:									; same for Y
	lda.w Yvel,x
	bpl .t1x
	clc
	adc.b r2
	sta.w Yvel,x
	bmi .4
	bra .3

.t1x:								; positive Y velocity
	sec
	sbc.b r2
	sta.w Yvel,x
	bpl .4
.3:									; clear Y velocity
	stz.w Yvel,x
.4:									; return
	rtl
