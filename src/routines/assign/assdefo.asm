; Assignment: a defenseman on offense holds the blue line on his side
; Takes: X = player object. Called through asstab (assignment 1). Replaced by assinsert (puck carrier ->
; assignment $11) or assreplace (other team has the puck / offsides -> assignment 2, assdefd). Otherwise
; skates to the blue line spot (x +-80, y +-98) on his side, halfway to the puck x when it is on that side.
assdefo:							; assignment: defenseman on offense
	cpx.w puckc						; is this player the puck carrier?
	beq .2							; yes: take the puck
	ldy.w puckc						; puck carrier of either team
	bmi .11							; nobody has the puck
	lda.w pfteam,x
	cmp.w pfteam,y					; same team has it: keep holding the line
	beq .11
	lda.w #$0002					; other team has the puck: assignment 2 (assdefd)
	sta.b d0
	jmp.w assreplace				; replace the assignment with d0
.1:									; return
	rtl								; return

.t1:								; unreferenced label
	jmp.w assnothing				; do nothing
.2:									; this player carries the puck
	lda.w #$0011					; assignment $11 (asspuckc)
	sta.b d0
	jmp.w assinsert					; insert it in front of this assignment
.11:								; clock stopped? (gmclock nonzero: do nothing)
	lda.w gmclock
	beq .t2							; clock running: go on
	jmp.w assnothing				; do nothing

.t2:								; bench check
	jsl.l check4bench				; may request a bench change for this player
	lda.w playerpad,x				; player has a pad (human controlled): leave him alone
	bpl .1
	lda.w pflags,x					; player flags
	bit.w #pfna						; first frame of the assignment (pfna)?
	beq .1x
	and.w #$FFFD					; clear pfna
	sta.w pflags,x
	stz.w temp1,x					; reset the timers
	stz.w temp2,x
	lda.w #$0008					; temp2b = 8
	sta.w temp2b,x
.1x:								; re-think timer
	lda.w temp1,x					; countdown minus the frame count
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .4							; still counting
	clc								; reload from aioff
	adc.w aioff,x
	bpl .3							; not below zero
.2x:								; clamp at zero
	lda.w #$0000
.3:									; store the re-think timer
	sta.w temp1,x
.4:									; skate to the spot
	lda.w #EvadePC>>16				; a0 = EvadePC
	sta.b a0+2
	lda.w #EvadePC
	sta.b a0
	ldy.w #$0050					; spot x = 80 for position 2 (right), -80 otherwise
	lda.w position,x
	cmp.w #$0002
	beq .5
	ldy.w #$FFB0
.5:									; spot x chosen
	lda.w pfgoal,x					; which goal
	bne .6
	tya								; mirror x for the other goal
	eor.w #$FFFF
	inc a
	tay
.6:									; spot x chosen
	sty.b d0						; d0 = spot x
	lda.w puckx						; puck x
	eor.b d0						; same side as the spot?
	bmi .t3
	lda.w puckx						; same side: skate to the puck x
	bra .7

.t1x:								; unreferenced label
	rtl								; unreferenced label

.t3:								; opposite sides: halfway
	lda.w puckx						; puck x
	pha								; halve it keeping the sign
	asl a
	pla
	ror a
	clc								; plus the spot x
	adc.b d0
.7:									; target x
	sta.b d0
	ldy.b a2						; team of this player
	lda.w tmflags,y
	bit.w #tmfoside					; team offsides (tmfoside): hold at the blue line
	bne .10
	lda.w pucky						; puck y
	sta.b d2
	lda.w pfgoal,x					; which goal
	bne .1xx
	lda.w #$0000					; mirror y
	sec
	sbc.b d2
	sta.b d2
.1xx:								; d2 = puck y from our goal
	lda.b d2						; d2 = puck y seen from our goal
	cmp.w #$FFA8					; puck far back (y < -88)?
	bmi .t2x
	cmp.w #$0058					; puck y below 88: mid-ice
	bmi .t1xx
	lda.w #$0062					; puck forward: y 98
	sta.b d1
	bra .8							; skate

.t1xx:								; puck mid-ice: y -78
	lda.w #$FFB2
	sta.b d1
	bra .8							; skate

.t2x:								; puck far back: y -216
	lda.w #$FF28
	sta.b d1
.8:									; y chosen
	lda.w pfgoal,x					; which goal
	bne .9
	lda.w #$0000					; mirror y
	sec
	sbc.b d1
	sta.b d1
.9:									; y chosen
	jmp.w skateto					; skate to d0, d1
.10:								; offsides: stay at y 98
	ldy.w #$0062					; y 98
	lda.w pfgoal,x					; which goal
	beq .1xxx
	ldy.w #$FF9E					; other goal: y -98
.1xxx:								; y chosen
	sty.b d1						; target y
	bra .9							; skate
