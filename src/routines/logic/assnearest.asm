; Assignment: the player nearest the puck who does not have it
assnearest:							; X = player; asstab entry
	lda.w pflags,x
	bit.w #pfna						;new assignment?
	beq .1							;no
	and.w #(~pfna&$FFFF)			;clear the new flag
	sta.w pflags,x
	stz.w temp3,x					;no chase timer
	stz.w temp2,x					;reaction timer 0
	lda.w #$0008					;8
	sta.w temp2b,x
	stz.w temp1,x					;decide now
.1:									; if position,x = 0 go to .t2, ...
	lda.w position,x				;goalie?
	beq .t2							;yes: goalie assignment
	cpx.w puckc						;carrying the puck?
	bne .t3							;no
	lda.w #$0011					;assignment $11: carry it
	sta.b d0
	lda.w playerpad,x				;pad player?
	bpl .t1							;yes: the pad drives him
	jmp.w assinsert					; give player X assignment d0 on top of the current one

.t1:								; pad-controlled player (playerpad >= 0): return
	rtl

.t2:								; position 0 (goalie): jump to assgoalie
	jml.l assgoalie					; Assignment: the goalie

.t3:								; X is not the puck carrier: run the temp1 timer
	lda.w temp1,x					; timer
	sec
	sbc.b d7						;reaction timer
	sta.w temp1,x
	bmi .t2x						;ran out: decide
	jmp.w .9						;not yet: move

.t2x:								; temp1 ran out: add aioff,x to it and reload
	adc.w aioff,x					;plus his offense delay
	bpl .1x							;not negative
	lda.w #$0000					;floor at 0
.1x:								; temp1,x = A, if puckc negative go to .t1x, ...
	sta.w temp1,x
	ldy.w puckc						;carrier
	bmi .t1x						;loose
	lda.w position,y				;goalie has it?
	beq .t1x						;yes
	sty.b a1						;carrier
	lda.w pfteam,y					;his team
	eor.w pfteam,x					;same as ours?
	bne .t1x						;no
	jmp.w .2						;teammate has it

.t1x:								; puck not held by a teammate: use the team's nearest player
	ldy.b a2
	lda.w tmnear,y					;nearest distance
	sta.b d2
	lda.w tmnearpl,y				;nearest player
	sta.b a1
	lda.b d2						;none?
	bmi .3							;yes
.2:									; if zero go to .3, ...
	cpx.b a1						;me?
	beq .3							;yes: chase
	lda.w gmclock					;clock stopped?
	bne .3							;yes
	ldy.b a1						;the other player
	lda.w pflags,y
	bit.w #pf2unav					;unavailable?
	bne .3							;yes
	lda.w position,y				;goalie?
	beq .3							;yes
	lda.w asscur,y					;his assignment
	cmp.w #$0015					;taking a pass?
	beq .3							;yes: leave him
	ldx.b a1
	lda.w pflags,x					;his flags
	and.w #(~pfdoff&$FFFF)			;clear bit 0
	sta.w pflags,x
	lda.w #$0012					;assignment $12: support
	sta.b d0
	jsl.l assinsert					;give it to him
	ldx.b curobj
	jmp.w assexit					;end mine
.3:									; d1 = $0002, if d2 >= $00E2 go to .1xx, ...
	lda.w #$0002					;shift 2 (aggressive)
	sta.b d1
	lda.b d2						;nearest distance
	cmp.w #$00E2					;far (226+)?
	bcs .1xx						;yes: aggressive
	stz.b d1						;shift 0
	lda.w position,x				;goalie?
	beq .9							;yes: no chase
.1xx:								; if sflags bits $2000 clear go to .2x, ...
	lda.w sflags					;power play?
	bit.w #sf2pwrplay				;no
	beq .2x							;shift 0
	dec.b d1
	dec.b d1						;short handed?
	jsl.l chkpk2					;no: shift 0
	bne .2x							;short handed: shift 2
	inc.b d1
	inc.b d1
	inc.b d1
	inc.b d1
.2x:								; d0 = $0014 - checking,x, tmp0 = d1
	lda.w #$0014					;20
	sec
	sbc.w checking,x				;minus his checking
	sta.b d0						;chance range
	lda.b d1						;shift count
	sta.b tmp0
.loop:								;count
	dec.b tmp0						;done: roll
	bmi .8							;double the range
	asl.b d0
	bra .loop						;loop
.4:									; playerpad,x >= 0: return
	rtl
.5:									; if puckc negative go to .7, ...
	ldy.w puckc						;carrier
	bmi .7							;loose: to the puck
	lda.w position,y				;goalie has it?
	bne .7							;no: to the puck
	lda.w puckx						;puck x
	sta.b d0						;x
	lda.w #$0058					;y $58
	ldy.w pfgoal,x					;attacking end
	bne .1xxx						;top
	lda.w #$FFA8					;y -$58
.1xxx:								; d1 = A, a0 = rtss, call skateto, ...
	sta.b d1						;y
	lda.w #rtss>>16
	sta.b a0+2						;route
	lda.w #rtss
	sta.b a0
	jsl.l skateto					;skate there
	jmp.w check4check				; look for a good chance to check an opponent
.6:									; gmclock != 0: call GlideBack, go to donothing
	jsl.l GlideBack					; start SPAglideback on player X unless his animation is locked
	jmp.w donothing					; computer player stands still
.7:									; call skatetopuck, go to check4check
	jsl.l skatetopuck				; player X skates to the puck
	jmp.w check4check				; look for a good chance to check an opponent
.8:									; tmp0 counted below 0: call randomd0, if d0 >= $0002 go to .9, ...
	jsl.l randomd0					;random
	lda.b d0						;roll
	cmp.w #$0002					;2 or more?
	bcs .9							;yes: no chase
	lda.w #$00F0					;4 seconds
	sta.w temp3,x					;chase timer
.9:									; if playerpad,x >= 0 go to .4, ...
	lda.w playerpad,x				;pad player?
	bpl .4							;yes: done
	lda.w gmclock					;clock stopped?
	bne .6							;yes: glide back
	ldy.b a2						;team
	lda.w tmflags,y					;flags
	bit.w #tmfmid					;midfield mode?
	bne .1xxxx						;yes: cover
	lda.w puckc						;carrier
	bmi .5							;loose: to the puck
	lda.w temp3,x					;chase timer
	sec
	sbc.b d7						;minus the frames
	sta.w temp3,x
	cmp.w #$0000					;still chasing?
	bpl .5							;yes: to the puck
	stz.w temp3,x					;timer off
.1xxxx:								; call skatetopuckinit, d0 = -(d0), d1 = -(d1) + $00F4, ...
	jsl.l skatetopuckinit			;puck soon
	lda.b d1
	pha								;keep y
	lda.b d0
	pha								;keep x
	eor.w #$FFFF					;negate
	inc a
	sta.b d0						;-x
	lda.b d1						;y
	eor.w #$FFFF					;negate
	inc a
	clc
	adc.w #$00F4					;toward the goal at the bottom
	sta.b d1						;attacking end
	lda.w pfgoal,x					;bottom
	beq .2xx						;y
	lda.b d1
	sec
	sbc.w #$01E8					;toward the top goal
	sta.b d1
.2xx:								; ror a, d0 = A, ror a, ...
	lda.b d0						;x
	pha
	asl a							;sign into carry
	pla
	ror a							;half
	sta.b d0						;d0
	lda.b d1						;y
	pha
	asl a							;sign into carry
	pla
	ror a							;half
	sta.b d1						;d1
	pla								;puck x
	clc								; add the puck spot
	adc.b d0						;plus half the gap
	sta.b d0						;d0
	pla								;puck y
	clc
	adc.b d1						;plus half the gap
	sta.b d1						;d1
	ldy.b a2						;team
	lda.w tmflags,y					;flags
	bit.w #tmfmid					;midfield mode?
	beq .4x							;no
.3x:								; if pfgoal,x = 0 go to .t1xx, ...
	lda.w pfgoal,x					;attacking end
	beq .t1xx						;bottom
	lda.b d1						;y
	sec
	sbc.w #$0053					;past $53?
	bmi .4x							;no
	lda.w #$0044					;cap at $44
	sta.b d1
	bra .4x

.t1xx:								; pfgoal clear: if d1 < $FFAD then d1 = $FFBC
	lda.b d1						;y
	sec
	sbc.w #$FFAD					;past -$53?
	bpl .4x							;no
	lda.w #$FFBC					;cap at -$44
	sta.b d1
.4x:								; a0 = rtss, call skateto, go to check4check
	lda.w #rtss>>16					;route
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jsl.l skateto					;skate there
	jmp.w check4check				; look for a good chance to check an opponent
