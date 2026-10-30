; Assignment: a defenseman on defense stays between the furthest attacker and his goal
; Takes: X = player object. Called through asstab (assignment 2). The puck y plus its drift decides
; whether the defenseman may join the attack (-> assreplace with assignment 1, assdefo); otherwise he skates
; to a spot (temp3 = x, temp4 = y) behind the furthest opposing player, then checks for a check.
assdefd:							; assignment: defenseman on defense
	ldy.w puckc						; puck carrier
	bmi .16							; nobody has the puck: think about it
	lda.w pfteam,x
	cmp.w pfteam,y
	bne .16							; other team has the puck: think about it
	lda.w #$0001					; assignment 1: assdefo
	sta.b d0
	jmp.w assreplace				; replace the assignment with d0
.1:									; return
	rtl								; return
.2:									; clock running? no: do nothing
	jmp.w assnothing				; do nothing
.16:								; defend: only while the clock is running
	lda.w gmclock
	bne .2							; clock stopped: do nothing
	jsl.l check4bench				; may request a bench change
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
	sbc.b d7						; minus the frame count
	sta.w temp1,x
	bmi .t2							; expired: re-think
	jmp.w .15						; still counting: just skate

.t2:								; timer expired: reload from aidef
	clc
	adc.w aidef,x					; reload from aidef
	bpl .2x							; never below zero
.1xx:								; clamp at zero
	lda.w #$0000					; not below zero
.2x:								; store the re-think timer
	sta.w temp1,x
	lda.w pucky						; puck y
	sta.b d1
	lda.w puckvy					; puck y velocity / 64, sign extended
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200					; sign extend from 10 bits
	beq .3
	ora.w #$FC00
.3:									; d3 = puck y lead
	sta.b d3						; d3 = puck y lead
	lda.w pfgoal,x					; team direction
	bne .4
	lda.w #$0000					; mirror for the other goal: d1 = -d1, d3 = -d3
	sec
	sbc.b d1
	sta.b d1
	lda.w #$0000
	sec
	sbc.b d3
	sta.b d3
.4:									; only lead when moving up ice
	lda.b d3
	bpl .5
	stz.b d3
.5:									; d3 = puck y plus lead
	lda.b d3
	clc
	adc.b d1
	sta.b d3						; d3 = puck y plus lead
	sec								; compare with the line at $58 (Blueline)
	sbc.w #$0058
	bmi .7							; not past the line
	ldy.b a2						; team of this player
	lda.w tmflags,y					; team offsides: stay back
	bit.w #tmfoside					; team offsides: stay back
	bne .7
	lda.w puckc						; puck carrier index
	bmi .6							; puck carrier index halved
	lsr a
.6:									; store the carrier value
	sta.b d1						; check the puck
	bmi .7
	jsl.l chkpk						; does somebody own it?
	beq .7
	lda.b d1						; compare the carrier with this player
	sec
	sbc.w #$0006
	sta.b d1
	txa								; player index
	lsr a
	sec
	sbc.w #$0006
	sta.b d2
	eor.b d1						; signed test of the difference
	sta.b d1
.7:									; set the defense spot x: +65 for position 2, -65 otherwise
	lda.w #$0041
	sta.w temp3,x
	lda.w position,x				; position 2 is the right defenseman
	cmp.w #$0002
	beq .8
	lda.w #$FFBF					; left defenseman: x = -65
	sta.w temp3,x
.8:									; a0 = first player of the opposing team
	ldy.w #$0000					; home team: start at 0
	cpx.w #$000C					; X in the first team?
	bcs .9
	ldy.w #$000C					; visitors' object: start at 12 (second team)
.9:									; check 6 players
	lda.w #$0006
	sta.b d2
	lda.w #$FC18					; start y = -1000
	sta.b d0
	lda.w pfgoal,x					; which goal
	beq .14
	lda.w #$03E8					; other goal: start at 1000
	sta.b d0
.loop:								; each opponent in turn
	sty.b a0
	lda.w pflags,y					; unavailable (bit $1000, pf2unav)?
	bit.w #$1000
	bne .12
	lda.w position,y				; skip empty positions
	bmi .12
	lda.w Yvel,y					; negative y velocity only matters one way
	bmi .10
	lda.w #$0000
.10:								; y velocity / 32, sign extended
	lsr a							; y velocity / 16
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0400					; sign extend from 11 bits
	beq .11
	ora.w #$F800
.11:								; add the player y: projected y
	clc
	adc.w Ypos,y					; projected y of the attacker
	sta.b d1
	sec
	sbc.b d0						; further up than the best so far?
	bpl .12
	lda.b d1						; new best y
	sta.b d0
.12:								; next opponent
	ldy.b a0
	iny
	iny
	dec.b d2						; count down
	bne .loop
	lda.b d0						; 50 behind the furthest attacker ($28 = 40)
	sec
	sbc.w #$0028
	sta.b d0
	sec								; clamp at -190
	sbc.w #$FF42
	bpl .13
	lda.w #$FF24					; limit -220
	sta.b d0
.13:								; store the target y
	lda.b d0
	sta.w temp4,x					; target y
	lda.w puckx						; puck x
	sta.b d0
	lda.w temp3,x					; temp3 xor puck x
	eor.b d0
	sta.b d1
	bpl .15							; same side as the puck: keep temp3
	stz.w temp3,x					; opposite sign to puck x: clear temp3
	bra .15

.t1:								; unreferenced label
	rtl
.14:								; mirror of .loop for the other goal
	sty.b a0
	lda.w pflags,y
	bit.w #$1000					; unavailable (bit $1000, pf2unav)?
	bne .4x
	lda.w position,y				; skip empty positions
	bmi .4x
	lda.w Yvel,y					; y velocity
	bpl .1xxx
	lda.w #$0000
.1xxx:								; y velocity / 32
	lsr a							; y velocity / 32
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0400					; sign extend from 11 bits
	beq .3x
.2xx:								; unreferenced label
	ora.w #$F800
.3x:								; projected y of the attacker
	clc
	adc.w Ypos,y					; projected y of the attacker
	sta.b d1
	sec
	sbc.b d0						; further down than the best so far?
	bmi .4x
	lda.b d1						; new best y
	sta.b d0
.4x:								; next opponent
	ldy.b a0
	iny
	iny
	dec.b d2						; count down
	bne .14
	lda.b d0						; 40 behind the furthest attacker
	clc
	adc.w #$0028
	sta.b d0
	sec								; clamp at 190
	sbc.w #$00BE
	bmi .5x
	lda.w #$00DC					; limit 220
	sta.b d0
.5x:								; store the target y
	lda.b d0
	sta.w temp4,x					; target y
	lda.w #$0000					; temp3 = -temp3 (mirror)
	sec
	sbc.w temp3,x
	sta.w temp3,x
	lda.w puckx						; puck x
	sta.b d0
	lda.w temp3,x
	eor.b d0						; temp3 xor puck x
	sta.b d1
	bpl .15
	stz.w temp3,x					; opposite sign to puck x: clear temp3
.15:								; skate to (temp3,temp4) avoiding the puck carrier
	lda.w temp3,x					; target x
	sta.b d0
	lda.w temp4,x					; target y
	sta.b d1
	lda.w #rtss>>16					; a0 = rtss (no avoidance routine)
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jsl.l skateto					; skate to d0, d1
	jmp.w check4check				; then check for a check
