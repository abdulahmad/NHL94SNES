; Assignment: the puck carrier on a breakaway (asstab $10): skate in on the goal and shoot; anyone else exits
assbreakaway:						; X = puck carrier; others and non-pad players exit (asstab $10)
	cpx.w puckc						;the carrier?
	bne .1							;not the carrier: leave
	lda.w playerpad,x				;pad of the player
	bmi .8							;computer carrier: breakaway
.1:									;not the computer carrier: leave
	jmp.w assexit					;leave the assignment

.t1:								;(not branched to)
	rtl
.2:									;clock stopped: glide and stand
	jsl.l GlideBack					;glide
	lda.w #$003C					;60 frames
	sta.w nopuck,x					;no puck for 60 frames
	jmp.w donothing					;stand still
.8:									;computer carrier: skate in and shoot
	lda.w gmclock					;clock stopped?
	bne .2							;clock stopped: glide
	lda.w Ypos,x					;his y
	sta.b d0						;distance up the ice
	ldy.w pfgoal,x					;which end?
	bne .2x							;top end: keep
	lda.w #$0000
	sec
	sbc.b d0						;negate
	sta.b d0						;distance up the ice
.2x:								;new assignment: start the path
	lda.w pflags,x					;flags
	bit.w #$0002					;new assignment?
	beq .1x							;not new
	and.w #$FFFD					;clear bit 1
	sta.w pflags,x					;clear the flag
	stz.w temp1,x					;clear
	stz.w temp2,x					;clear
	lda.w #$0008					;timer 8
	sta.w temp2b,x					;timer
	stz.w sopathpoint				;first path point
	lda.w seed						;seed
	and.w #$0003					;random 0-3
	sta.w temp3,x					;random 0-3
	jsr.w .11						;pick the path
.1x:								;follow the path
	lda.w sopathnext				;end of the path?
	bmi .4							;path done: shoot
	lda.b d0						;distance up the ice
	cmp.w sopathnext				;past the point?
	bmi .3							;not there yet
	jsr.w .9						;next point
	lda.w facedir,x					;his facing
	sta.w sopathface				;facing at the point
.3:									;skate to the current point
	lda.w sopathx					;path x
	sta.b d0						;target x
	lda.w sopathy					;path y
	sta.b d1						;target y
	lda.w pfgoal,x					;which end?
	bne .1xx						;top end: keep
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1						;mirror y for the bottom end
.1xx:								;skate to the point
	lda.w #.nocallback>>16			;no avoid callback
	sta.b a0+2
	lda.w #.nocallback				;no avoid callback
	sta.b a0
	lda.w temp2,x					;speed
	sec
	sbc.w impactstep				;minus the impact step
	sta.w temp2,x					;slow down
	jml.l skateto					;skate to it
.4:									;end of the path: shoot when facing
	lda.w facedir,x					;his facing
	sec
	sbc.w sopathface				;minus the path facing
	beq .3							;facing the path: keep skating
	inc a							;plus 1
	and.w #$0007					;mod 8
	cmp.w #$0003					;within 2 steps?
	bcs .t1x						;off by more than 2: lower odds
	jsl.l RandomWord				;random
	and.w #$0F80					;odds $F80
	bne .3							;no shot this frame
	bra .5							;shoot

.t1x:								;facing away: lower odds
	jsl.l RandomWord				;random
	and.w #$0600					;odds $600
	bne .3							;no shot this frame
.5:									;shoot: pick a direction
	jsl.l RandomWord				;random
	and.w #$0001					;random bit
	inc a							;1 or 2
	inc a							;plus 2
	sta.b d0						;direction 2 or 3
	ldy.w sopathside				;which side?
	bpl .1xxx						;right side: keep
	lda.b d0
	clc
	adc.w #$0003					;plus 3
	sta.b d0						;offset by 3
.1xxx:								;aim the shot
	lda.b d0						;direction
	sta.w passdir					;shot direction
	lda.w #$0014					;speed $14
	sta.w passspeed					;shot speed
	lda.w #$0000
	sec
	sbc.w Xpos,x					;minus his x
	sta.b d0						;dx to the centre
	lda.w pfgoal,x					;which end?
	bne .t1xx						;top goal?
	lda.w #$FEF8					;bottom goal: y -$108
	sec
	sbc.w Ypos,x					;minus his y
	sta.b d1						;dy
	bra .6							;aim

.t1xx:								;attacking the top goal
	lda.w #$0108					;top goal: y $108
	sec
	sbc.w Ypos,x					;minus his y
	sta.b d1						;dy
.6:									;shoot at the goal
	jsl.l vtoa						;direction to the goal
	jsl.l Findhittype				;swing type
	beq .t1xxx						;forehand?
	lda.w #SPAonetimerb				;one timer backhand
	bra .7							;set it

.t1xxx:								;forehand swing
	lda.w #SPAonetimerf				;one timer forehand
.7:									;start the shot animation
	jsl.l SetSPAFromA				;start it
	jsl.l updateanim				;step it
	lda.w #$0002					;two frames in
	sta.w SPAcnt,x					;2 frames into the swing
	jsl.l doshot					;shoot
	rtl
.nocallback:						;skateto callback: nothing to avoid
	rtl
.9:									;load the next path point
	lda.w sopathpoint				;point number
	asl a							;times 2
	adc.w sopathpoint				;times 3
	asl a							;times 6
	tay								;offset
	lda.w #.10>>16					;path points
	sta.b a0+2
	lda.w #.10						;path points
	sta.b a0
	lda.b [a0],y					;x of the point
	sta.b d0						;path x
	lda.w sopathside				;which side?
	bpl .1xxxx						;right side: keep
	lda.w #$0000					;left: mirror x
	sec
	sbc.b d0
	sta.b d0
.1xxxx:								;side applied
	lda.b d0						;x of the point
	sta.w sopathx					;path x
	iny
	iny
	lda.b [a0],y					;y
	sta.w sopathy					;path y
	iny
	iny
	lda.b [a0],y					;next y
	sta.w sopathnext				;y where the next point starts
	inc.w sopathpoint				;next point
	rts
.10:								;path points: x, y, next y
	dw 40,120,74,-22,151,134,-22,224,177,44,227,-1	;path points: x, y and the y of the next point
.11:								;pick the breakaway path
	lda.b d0						;distance up the ice
	cmp.w #$002C					;still far from the goal?
	bpl .4x							;close to the goal: pick by x
	jsl.l RandomWord				;random
	and.w #$00C0					;random bits
	beq .t1xxxx						;bits clear: roll again
	lda.w attribute,x				;attribute
	bit.w #$0800					;attribute bit $800?
	bne .1xxxxx						;flag set: right
	bra .2xx						;left side

.t1xxxx:							;roll again
	jsl.l RandomWord				;another roll
	and.w #$00F0					;roll 0-$F0
	sta.b d0						;roll 0-$F0
	lda.w #$007F					;limit
	sec
	sbc.b d0						;$7F minus the roll
	bmi .2xx						;high roll: left
.1xxxxx:							;path on the right
	lda.w #$002D					;right side
	bra .3x							;right side
.2xx:								;path on the left
	lda.w #$FFD3					;left side
.3x:								;pick the end
	ldy.w pfgoal,x					;which end?
	bne .2xxx						;attacking the top end: keep
.1xxxxxx:							;mirror
	eor.w #$FFFF					;other end: mirror the side
	inc a							;negate
.2xxx:								;side picked
	sta.w sopathside				;side of the path
	sta.w sopathx					;path x
	lda.w #$0028					;y $28
	sta.w sopathy					;first point at y $28
	lda.w #$001E					;then y $1E
	sta.w sopathnext				;next point at y $1E
	rts
.4x:								;close to the goal: pick a side from his x
	lda.w Xpos,x					;his x
	cmp.w #$0020					;far right?
	bpl .8x							;far right: path from the centre
	cmp.w #$FFE0					;far left?
	bmi .8x							;far left: path from the centre
	jsl.l RandomWord				;random
	and.w #$00C0					;random bits
	beq .t1xxxxx					;bits clear: roll again
	lda.w attribute,x				;attribute
	bit.w #$0800					;attribute bit $800?
	bne .1xxxxxxx					;flag set: right
	bra .5x							;left side

.t1xxxxx:							;roll again
	jsl.l RandomWord				;another roll
	and.w #$00F0					;roll 0-$F0
	sta.b d0
	lda.w #$007F					;limit
	sec
	sbc.b d0						;$7F minus the roll
	bmi .5x							;high roll: left
.1xxxxxxx:							;right side
	lda.w #$002C					;right side
	bra .6x							;path on the right
.5x:								;left side
	lda.w #$FFD4					;path on the left
.6x:								; if pfgoal,x != 0 go to .1xxxxxxxx, ...
	ldy.w pfgoal,x					;which end?
	bne .1xxxxxxxx					;attacking the top end: keep
	eor.w #$FFFF					;other end: mirror the side
	inc a							;mirror for the other end
.1xxxxxxxx:							;side picked
	sta.w sopathside				;side of the path
	sta.w sopathx					;path x
.7x:								;start the path further up the ice
	lda.w #$0002					;point 2
	sta.w sopathpoint				;start at point 2
	lda.w #$0097
	sta.w sopathy					;first point at y $97
	lda.w #$0086					;then y $86
	sta.w sopathnext				;next point at y $86
	rts
.8x:								;in the middle: path from the centre
	sta.w sopathside				;side of the path
	stz.w sopathx					;path starts at x 0
	bra .7x
