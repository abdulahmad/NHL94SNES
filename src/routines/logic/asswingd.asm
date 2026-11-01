; Assignment: a wing on defense covers his side between the puck and the goal
; Takes: X = player object. Called through asstab (assignment 3). If his team has the puck the wing is
; replaced by assignment 4 (asswingo). Otherwise he skates to x +-100 (position 5 is the left wing) and
; to a y that follows the puck, limited per end of the ice, and stays on the puck side (skateto).
asswingd:							; assignment: wing on defense
	ldy.w puckc						; puck carrier
	bmi .8							; nobody has the puck: defend
	lda.w pfteam,x
	cmp.w pfteam,y
	bne .8							; other team has it: defend
	lda.w #$0004					; assignment 4: asswingo
	sta.b d0
	jmp.w assreplace				; replace the assignment with d0
.1:									; return
	rtl								; return
.2:									; clock stopped?
	jmp.w donothing					; do nothing
.8:									; defend
	lda.w gmclock
	bne .2							; clock stopped: do nothing
	jsl.l check4bench				; may request a bench change
	lda.w playerpad,x				; player has a pad (human controlled): leave him alone
	bpl .1
	lda.w pflags,x					; player flags
	bit.w #pfna						; first frame of the assignment (pfna)?
	beq .1x
	and.w #(~pfna&$FFFF)			; clear pfna
	sta.w pflags,x
	stz.w temp1,x					; reset the timers
	stz.w temp2,x
	lda.w #$0008					; temp2b = 8
	sta.w temp2b,x
.1x:								; re-think timer
	lda.w temp1,x					; countdown minus the frame count
	sec
	sbc.b d7						; minus the frame count
	sta.w temp1,x
	bpl .4							; still counting
	clc								; reload from aidef
	adc.w aidef,x
	bpl .3							; not below zero
.2x:								; clamp at zero
	lda.w #$0000
.3:									; store the re-think timer
	sta.w temp1,x
.4:									; target x 100
	lda.w #$0064
	sta.b d0
	lda.w position,x				; position 5 is the left wing
	cmp.w #$0005
	bne .5
	lda.w #$FF9C					; left wing: x = -100
	sta.b d0
.5:									; team goal direction
	ldy.w puckc						; puck carrier index
	lda.w pfgoal,x					; which goal
	beq .t3							; pfgoal 0: the other end (.t3)
	lda.w #$0000					; mirror x
	sec
	sbc.b d0
	sta.b d0
	lda.w #$FF62					; d1 = default target y -158
	sta.b d1
	lda.w #$FFB2					; d2 = blue line y -78
	sta.b d2
	lda.w position,y				; carrier a goalie? (position 0)
	beq .6
	ldy.b a2						; team of this player
	lda.w tmflags,y					; offsides: stay at the blue line
	bit.w #tmfoside					; team offsides: use the limit
	bne .6
	lda.b d2						; compare puck y with the blue line
	sec
	sbc.w pucky
	bpl .t2							; puck y at or above d2?
	lda.w pucky						; puck y becomes the target y
	sta.b d1
	bra .7

.t1:								; unreferenced label
	rtl

.t2:								; d2 = far limit y -264
	lda.w #$FEF8
	sta.b d2
	sec								; puck y beyond -264?
	sbc.w pucky
	bmi .7
	bra .6							; use the limit

.t3:								; other goal
	lda.w #$009E					; d1 = default target y 158
	sta.b d1
	lda.w #$004E					; d2 = blue line y 78
	sta.b d2
	lda.w position,y				; carrier a goalie?
	beq .6
	ldy.b a2						; team of this player
	lda.w tmflags,y
	bit.w #tmfoside					; team offsides: use the limit
	bne .6
	lda.b d2						; compare puck y with the blue line
	sec
	sbc.w pucky
	bmi .t1x
	lda.w pucky						; puck y becomes the target y
	sta.b d1
	bra .7

.t1x:								; d2 = far limit y 264
	lda.w #$0108
	sta.b d2
	sec								; puck y beyond 264?
	sbc.w pucky
	bpl .7
.6:									; use the limit d2
	lda.b d2
	sta.b d1
.7:									; target y chosen
	lda.w #rtss>>16					; a0 = rtss
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	lda.w puckx						; puck x
	eor.b d0						; same side as the target x?
	sta.b d2
	bmi .1xx						; opposite side: keep d0
	lda.w puckx						; same side: use the puck x
	sta.b d0
.1xx:								; skate
	jmp.w skateto					; skate to d0, d1
