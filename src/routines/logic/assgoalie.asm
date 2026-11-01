; Assignment: the goalie
assgoalie:							; called from assnearest, asstab
	lda.w #$0006					;flags 2 and 4
	ora.w goalieflags,x
	sta.w goalieflags,x				;set flags 2 and 4
	lda.w Xpos,x					;his x
	cmp.w #$FFD8					;left edge?
	bmi .2							;outside
	cmp.w #$0029					;right edge?
	bpl .2							;outside
	lda.w Ypos,x					;his y
	bit.w #$8000
	beq .1							;which end?
	eor.w #$FFFF					; negate: two's complement
	inc a
.1:									; r0 = A, if minus go to .2, ...
	sta.b r0						;depth
	cmp.w #$00E4					;inside $E4?
	bmi .2							;outside: keep flag 4
	cmp.w #$0104					;past $104?
	bpl .2							;outside: keep flag 4
	lda.w #$FFFB					;not flag 4
	and.w goalieflags,x
	sta.w goalieflags,x				;clear flag 4
.2:									;wide box: flag 2 when out of it
	lda.w Xpos,x					;his x
	cmp.w #$FFD0					;left edge?
	bmi .4							;outside the wide box
	cmp.w #$0031					;right edge?
	bpl .4							;outside the wide box
	lda.w Ypos,x					;his y
	bit.w #$8000
	beq .3							;which end?
	eor.w #$FFFF					; negate: two's complement
	inc a
.3:									; r0 = A, if minus go to .4, ...
	sta.b r0						;depth
	cmp.w #$00E4					;deep?
	bmi .4							;not deep: keep flag 2
	lda.w #$FFFD					;not flag 2
	and.w goalieflags,x
	sta.w goalieflags,x				;clear flag 2
.4:									;check the bench
	jsl.l check4bench				;line change?
	lda.w pflags,x					;flags
	bit.w #pfna						;new assignment?
	beq .5							;not new
	and.w #$FFFD					;clear pfna
	sta.w pflags,x					;clear the flag
	stz.w temp1,x					;clear the timers
	stz.w temp2,x					;clear the timers
	lda.w #$0008
	sta.w temp2b,x					;timer 8
	lda.w #$FFFF					;none
	sta.w temp4,x					;no target
.5:									;computer goalie: stay in the crease
	ldy.w playerpad,x				;pad of the goalie
	bpl .t2							;pad goalie
	lda.w Xpos,x					;his x
	cmp.w #$FFCB					;left edge?
	bmi .7							;left of the crease
	cmp.w #$0035					;right edge?
	bpl .7							;right of the crease
	lda.w Ypos,x					;his y
	bit.w #$8000
	beq .6
	eor.w #$FFFF					; negate: two's complement
	inc a
.6:									;check the depth
	cmp.w #$010F					;past the goal line?
	bcs .7							;behind the net
	cmp.w #$00D3					;near the goal line?
	bcs .10							;in the crease
.7:									;out of the crease: skate back
	lda.w #rtss>>16					;no avoid
	sta.b a0+2
	lda.w #rtss						;no avoid
	sta.b a0
	ldy.w #$0004					;x 4
	lda.w Xpos,x					;his x
	bpl .8							;right of centre?
	ldy.w #$FFFC					;left post
.8:									;target in front of the net
	sty.b d0						;target x
	lda.w #$00F4					;target y
	sta.b d1						;y $F4
	lda.w pfgoal,x					;top end?
	beq .9							;which end?
	lda.w #$FF0C					;bottom net: y -$F4
	sta.b d1						;bottom end
.9:									; go to skateto
	jml.l skateto					;skate back

.t1:								; return
	rtl

.t2:								;pad goalie
	lda.w gmclock					;clock stopped?
	bne .t1x						;clock stopped
	cpx.w puckc						;the carrier?
	beq .t1x						;holding the puck: flag
	jmp.w .12						;pad control

.t1x:								;clock stopped or holding: flag 1
	lda.w goalieflags,x				;goalie flags
	ora.w #$0001					;flag 1
	sta.w goalieflags,x
.10:								;in the crease
	jmp.w .13						;goalie control
.11:								;pad goalie: back toward the net
	lda.w #rtss>>16					;no avoid
	sta.b a0+2
	lda.w #rtss						;no avoid
	sta.b a0
	ldy.w #$0004					;x 4
	lda.w Xpos,x					;his x
	bpl .1x							;right side?
	ldy.w #$FFFC					;left side
.1x:								;target set
	sty.b d0						;target x
	lda.w #$00F9					;goal line
	sta.b d1						;y $F9
	lda.w pfgoal,x
	beq .2x							;top end?
	lda.w #$FF07					;bottom end
	sta.b d1
.2x:								;target set
	stz.w temp2,x					;no slowdown
	jml.l skateto					;skate there
.12:								;pad goalie in his crease
	lda.w goalieflags,x				;goalie flags
	bit.w #$0001					;flag 1?
	bne .10							;flag 1: done
	bit.w #$0002					;flag 2?
	bne .11							;flag 2: back to the crease
	ldy.w playerpad,x				;pad of the goalie
	lda.w paddir,y					;pad direction
	cmp.w #$0008					;neutral?
	bne .13							;not neutral: skip
	jsl.l stopna					;stop
.13:								;goalie control
	lda.w pf2aip,x					;animating?
	bne .1xx						;animating already
	lda.w #SPAgready				;ready stance
	jsl.l SetSPAFromA				;start it
.1xx:								;ready stance unless animating
	lda.w gmclock					;clock stopped?
	bne .14							;clock stopped: done
	lda.w temp5,x					;hold timer
	bmi .16							;no hold timer
	cpx.w puckc						;holding the puck?
	bne .t1xx						;not holding the puck
	lda.w Ypos,x					;his y
	cmp.w #$00BB					;out of the crease?
	bpl .15							;far out (top)
	cmp.w #$FF45					;far out (bottom)?
	bmi .15							;far from the net
	stz.w temp5,x					;start the hold count
	bra .15							;count it

.t1xx:								;not the carrier: no hold timer
	lda.w #$FFFF					;none
	sta.w temp5,x					;stop counting
	bra .16
.14:								; return
	rtl
.15:								;count down the hold timer
	lda.w temp5,x					;hold timer
	sec
	sbc.b d7						;minus the frame count
	sta.w temp5,x
	bpl .16							;time left
	lda.w #PenGhold					;penalty: holding the puck
	sta.b d0
	jsl.l AddPenalty2				;holding too long: penalty
.16:								;run the goalie
	lda.w pf2aip,x					;animating?
	beq .t1xxx
	jmp.w .14						;animating: done

.t1xxx:								;not animating: run the timer
	lda.w temp1,x					;think timer
	sec
	sbc.b d7
	sta.w temp1,x					;count down
	bmi .t2x						;timer out: think
	jmp.w .45

.t2x:								;time to think again
	lda.w aidef,x					;defense rating
	lsr a							;half his defense
	clc
	adc.w temp1,x					;plus the old timer
	cmp.w #$0000
	bpl .1xxx						;timer >= 0
	lda.w #$0000					;not below 0
.1xxx:								;timer set
	sta.w temp1,x
	lda.w playerpad,x				;pad?
	bpl .3x							;pad goalie: own handling
	lda.w pucky						;puck y
	sta.b d0
	lda.w Ypos,x
	eor.b d0						;puck on the other side?
	sta.b d1
	bpl .t1xxxx						;puck on his side?
	stz.b d0						;x 0
	lda.w #$00F4
	sta.b d2						;y $F4 in front of the net
	lda.w pfgoal,x
	beq .2xx						;top end?
	lda.w #$FF0C					;bottom end
	sta.b d2
.2xx:								;go there
	jmp.w .44

.t1xxxx:							;puck on his side: count temp4 down
	dec.w temp4,x					;count down
	bpl .1xxxx
	lda.w #$FFFF					;clamp at -1
	sta.w temp4,x
.1xxxx:								;holding the puck? count the hold
	cpx.w puckc
	beq .17
.3x:								; go to .23
	jmp.w .23
.17:								; if temp5,x >= 0 go to .1xxxxx, ...
	lda.w temp5,x					;holding the puck already?
	bpl .1xxxxx
	lda.w #$005A					;90 frames
	sta.w temp5,x					;start counting
.1xxxxx:							;holding: pass or keep it
	lda.w #$FFFF					;none
	sta.w temp4,x					;no hold
	lda.w temp5,x					;hold count
	sec
	sbc.w #$005A					;held 90 frames?
	bpl .18							;under 90: hold
	jsl.l RandomWord				;random
	cmp.w #$C000					;1 in 4?
	bcc .18							;no pass yet
	lda.w #$0005					;6 players
	sta.b d0						;6 players
	stz.b a0						;home first
	lda.w pfteam,x					;which team?
	bne .2xxx						;visiting goalie: opponents are home
	lda.w #$000C					;home goalie: away team
	sta.b a0						;away team's first player
.2xxx:								;any opponent near the puck?
	ldy.b a0						;player index
	lda.w pflags,y					;flags
	bit.w #pf2unav					;off the ice?
	bne .3xx						;skip
	lda.w puckdist,y				;distance to the puck
	cmp.w #$0023					;within $23?
	bcc .19							;close: cover it
.3xx:								; increment a0, increment a0, decrement d0, ...
	inc.b a0						;next player
	inc.b a0
	dec.b d0						;one less
	bpl .2xxx						;next player
	lda.w #$0001					; threat = 1, chk4pass
	sta.w threat					;under threat
	jsl.l chk4pass					;pass it out
	lda.w puckc						;carrier now?
	bmi .20							;no pass: the puck carrier stays
.18:								; go to .24
	jmp.w .24						;position
.19:								;cover the loose puck
	ldy.w #$0000					;the puck
	cmp.w #$0014					;within $14?
	bcs .18							;too far: position
	lda.w #$005A					;90 frames
	sta.w pf2aip,x					;lock for 90 frames
	lda.w #SPAgcover				;cover the puck
	jsl.l SetSPAFromA				;start it
.20:								; return
	rtl
.21:								;poke at the puck
	jsl.l vtoa						;direction to the puck
	lda.b d0						;direction
.22:								;poke check in direction A
	sta.w facedir,x					;face it
	sta.w pfalock,x					;lock his facing
	lda.w #SPAgpoke					;poke check
	jsl.l SetSPAFromA				;start it
	lda.w #$00F0					;240 frames
	sta.w goaliedivewait,x			;no poke for 4 s
	rtl
.23:								;pad goalie: poke or dive
	ldy.w playerpad,x				;pad of the goalie
	bmi .t3							;computer goalie
	lda.w padinputdone,y			;pad input state
	cmp.w #$0001					;ready?
	bne .t3							;pad not ready: computer
	cpx.w puckc						;the carrier?
	beq .18							;holding it: position
	lda.w puckx						;puck x
	sec
	sbc.w Xpos,x					;minus his x
	sta.b d0						;dx
	lda.w pucky						;puck y
	sec
	sbc.w Ypos,x					;minus his y
	sta.b d1						;dy
	lda.w PadRaw1,y					;held buttons
	bit.w #$4000					;B held?
	bne .t2xx						;B held: dive
	lda.w padnew,y					;new presses
	bit.w #$0040					;Y pressed?
	beq .18							;no press: position
	lda.w paddir,y					;pad direction
	cmp.w #$0008					;neutral?
	beq .21							;neutral: poke at the puck
	and.w #$0007					;direction 0-7
	bra .22							;poke in that direction

.t2xx:								;B held: dive
	lda.w paddir,y					;pad direction
	cmp.w #$0008					;neutral?
	bne .t1xxxxx					;direction pressed?
	jmp.w .t4						;no direction: dive at the puck

.t1xxxxx:							; paddir,y != $0008: and #$0007, go to .2xxxx
	and.w #$0007					;direction 0-7
	jmp.w .2xxxx					;dive in that direction

.t3:								;computer goalie: poke or dive
	lda.w puckx						;vector to the puck
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w pucky						;dx to the puck
	sec
	sbc.w Ypos,x					;dy to the puck
	sta.b d1
	lda.w puckc						;carrier?
	bmi .t1xxxxxx					;loose puck
	lsr a							;carrier index
	tay								;carrier index
	lda.w pfteam,y					;team of the carrier
	cmp.w pfteam,x					;same team as the goalie?
	beq .t2xxx						;own team: no poke
	lda.w goaliedivewait,x			;wait after a dive
	bne .t2xxx						;still waiting: no poke
	jsl.l RandomWord				;random
	cmp.w #$0A00					;1 in 6
	bcs .t2xxx						;no poke this time
	lda.w puckdist,x				;distance to the puck
	cmp.w #$0023					;within $23?
	bcs .24							;too far: no poke
	lda.w pucky						;puck y
	cmp.w #$FEF7					;beyond the bottom goal line?
	bmi .24							;behind the net: no poke
	cmp.w #$0109					;beyond the top goal line?
	bpl .24							;behind the net: no poke
	jmp.w .21						;poke check

.t1xxxxxx:							;loose puck: dive for it?
	lda.w temp4,x					;dive state
	bne .t2xxx						;already diving: no
	lda.w puckdist,x				;distance to the puck
	cmp.w #$002D					;within $2D?
	bcs .24							;too far: no dive
	lda.w pucky						;puck y
	cmp.w #$FEF7					;beyond the bottom goal line?
	bmi .24							;behind the net: no dive
	cmp.w #$0109					;beyond the top goal line?
	bpl .24							;behind the net: no dive
	lda.b a2
	eor.w #$0002					;other team
	tay
	lda.w tmnear,y					;opponent's nearest distance
	cmp.w #$003C					;near enough?
	bcs .24							;opponent close: no dive
	jsl.l RandomWord				;random
	cmp.w #$0800					;1 in 32
	bcs .24							;no dive
	bra .t4							;dive

.t2xxx:								; go to .24
	jmp.w .24						;no dive

.t4:								;dive toward the puck
	jsl.l vtoa						;direction to the puck
	lda.b d0						;direction
.2xxxx:								;dive at the puck
	sta.w facedir,x					;facing
	ldy.w #SPAgdive					;dive
	tya
	jsl.l SetSPAFromA				;start it
	lda.w #$0168					;360 frames
	sta.w goaliedivewait,x			;no dive for 6 s
	lda.w CwdExciteLvl				;crowd excitement
	clc
	adc.w #$000A					;plus 10
	bmi .1xxxxxx					;overflow: keep
	sta.w CwdExciteLvl				;crowd excitement
.1xxxxxx:							;lock him
	lda.w #$0096					;150 frames
	sta.w pfalock,x					;lock the animation
	clc
	adc.l Crowdlevel
	sta.l Crowdlevel				;crowd level
	lda.w #$001E					;30 frames
	sta.b crowdhold					;crowd hold 30
	rtl
.24:								;position in front of the net
	lda.w pfgoal,x					;which end?
	bne .t1xxxxxxx					;bottom end?
	lda.w #$0000					;bank 0
	sta.b a0+2
	lda.w #$0D17					;top post table
	sta.b a0
	lda.w #$0104					;post y
	sta.b d3
	lda.w #$0108					;goal line
	sta.b d4
	bra .1xxxxxxx

.t1xxxxxxx:							;bottom end
	lda.w #$0D1B
	sta.b a0						;bottom post table
	lda.w #$FEFC
	sta.b d3						;post y
	lda.w #$FEF8
	sta.b d4						;goal line
.1xxxxxxx:							;face the puck
	cpx.w puckc						;the carrier?
	beq .t1xxxxxxxx					;holding the puck?
	jsr.w GoaliePuckVector			;vector to the puck
	jsl.l vtoa						;direction
	jsl.l AdjustFacingDirection		;turn toward it
	bra .2xxxxx						;positioned

.t1xxxxxxxx:						;holding: face up ice
	lda.w playerpad,x				;pad?
	bpl .2xxxxx						;pad goalie: no turn
	lda.w pfgoal,x					;his end
	eor.w #$0001					;away from his net
	asl a							;times 2
	asl a							;times 4
	sta.b d0						;facing 0 or 4
	jsl.l AdjustFacingDirection		;turn toward the far end
.2xxxxx:							;stay out front
	lda.w Ypos,x					;his y
	cmp.w #$FEFB					;behind the bottom goal line?
	bmi .4x							;behind the net
	cmp.w #$0105					;behind the top goal line?
	bpl .4x							;behind the net
.3xxx:								; d0 = puckx, d1 = pucky, call .49, ...
	lda.w puckx						;position against the puck
	sta.b d0						;puck x
	lda.w pucky
	sta.b d1						;puck y
	jsl.l .49						;angle on the puck
	lda.b d1
	cmp.w #$FFD2					;left of the posts?
	bmi .25							;not centred: predict
	cmp.w #$002E					;right of the posts?
	bpl .25							;not centred: predict
	lda.b d1
	pha								;save the target
	lda.b d0
	pha								;save the target
	jmp.w .31						;move to the angle
.4x:								;behind the net: back out front
	lda.w playerpad,x				;pad?
	bpl .3xxx						;pad goalie: track
	stz.b d2						;no target slot
	stz.b d0						;x 0
	lda.w Xpos,x					;his x
	cmp.w #$FFD3					;left edge?
	bmi .1xxxxxxxx
	cmp.w #$002D					;right edge?
	bpl .1xxxxxxxx
	lda.w #Sideline					;right wall
	sta.b d0						;right wall
	lda.w Xpos,x
	bpl .1xxxxxxxx					;right side: right wall
	lda.w #$FF78
	sta.b d0						;left wall
.1xxxxxxxx:							; go to .44
	jmp.w .44
.25:								;predict where the puck crosses
	lda.w puckvy					;puck y speed
	xba
	lsr a							;speed / 512
	and.w #$007F					;7 bits
	bit.w #$0040					;negative?
	beq .1xxxxxxxxx
	ora.w #$FF80					;sign extend
.1xxxxxxxxx:						; r3 = A, ror a, adc r3, ...
	sta.b r3						;keep the step
	cmp.w #$8000
	ror a							;half of it
	adc.b r3						;1.5 x the step
	clc
	adc.w pucky						;plus the puck y
	sta.b d1
	lda.b d1						;predicted y
	cmp.w #$00E0					;near the net (top)?
	bpl .2xxxxxx
	lda.b d1						;predicted y
	cmp.w #$FF20
	bpl .28							;inside: track the puck
.2xxxxxx:							; if passReceiverPlayerNum >= 0 go to .27, ...
	lda.w passReceiverPlayerNum		;pass receiver?
	bpl .27							;a pass on the way: predict it
	lda.w puckc						;puck carried?
	bmi .27							;loose puck: predict it
	lda.w seed
	and.w #$0180
	beq .29
.26:								; xba, and #$00FF, if zero go to .1xxxxxxxxxx, ...
	lda.w puckvx					;puck x speed, high byte
	xba
	and.w #$00FF					;8 bits
	bit.w #$0080					;negative?
	beq .1xxxxxxxxxx				;positive
	ora.w #$FF00					;sign extend
.1xxxxxxxxxx:						; r3 = A, ror a, adc r3, ...
	sta.b r3						;keep it
	cmp.w #$8000
	ror a							;half
	adc.b r3						;1.5 x
	clc
	adc.w puckx						;plus the puck x
	sta.b d0						;target x
	bra .30							;angle point
.27:								;predict the pass x
	lda.w puckvx					;puck x speed
	xba
	lsr a							;speed / 512
	and.w #$007F					;7 bits
	bit.w #$0040					;negative?
	beq .1xxxxxxxxxxx
	ora.w #$FF80					;sign extend
.1xxxxxxxxxxx:						; adc puckx, d0 = A, go to .30
	clc
	adc.w puckx						;plus the puck x
	sta.b d0						;target x
	bra .30							;angle point
.28:								;in front: lead the puck sometimes
	lda.w seed						;random
	and.w #$0380					;1 in 8: lead it
	beq .26							;no lead
.29:								;predict x one step further
	lda.w puckvx					;puck x speed
	xba								;speed / 256
	and.w #$00FF					;8 bits
	bit.w #$0080					;negative?
	beq .1xxxxxxxxxxxx
	ora.w #$FF00					;sign extend
.1xxxxxxxxxxxx:						; adc puckx, d0 = A
	clc
	adc.w puckx						;plus the puck x
	sta.b d0						;target x
.30:								;angle point
	jsl.l .49						;angle point toward d0 / d1
	lda.b d1
	pha								;save it
	lda.b d0
	pha								;save it
.31:								;how far is the angle point?
	lda.b d0						;x
	ldy.b d1						;y
	jsl.l ApproxLength				;length of the vector
	sta.b d0
	cmp.w #$001E					;within 30?
	bcs .t1xxxxxxxxx				;far: scale it
	pla								;target x
	sta.b d0						;target x
	pla
	sta.b d1						;target y
	bra .5x							;set the target

.t1xxxxxxxxx:						;scale the vector to the speed
	lda.b d0						;distance
	inc a
	sta.b d2						;distance + 1
	lda.w #$0014					;speed $14
	sta.b d4						;speed $14
	lda.w sflags					;flags
	bit.w #sfssdir					;sflags bit 3?
	beq .1xxxxxxxxxxxxx				;normal
	lda.w #$001C					;$1C when bit 3
	sta.b d4						;fast speed
.1xxxxxxxxxxxxx:					;scale the vector to the speed
	pla								;x
	sta.b d0						;x
	pla
	sta.b d1						;y
	tax								;y
	lda.b d4						;speed
	jsl.l Mul16x8XS					;y * speed
	lda.b d2
	sta.b r1						;divisor
	jsl.l Div32S					;/ distance+1
	lda.b r0						;quotient
	sta.b d1						;scaled y
	lda.b d4
	adc.w #$0006					;plus 6
	sta.b d4						;speed + 6
	ldx.b d0						;x
	jsl.l Mul16x8XS					;x * speed
	lda.b d2
	sta.b r1						;divisor
	jsl.l Div32S					;/ distance+1
	lda.b r0						;quotient
	sta.b d0						;scaled x
	ldx.b curobj					;goalie index
.5x:								;set the target
	lda.b d1
	clc
	adc.b d3
	sta.b d1						;plus the post y
	sta.b d2						;target y
	ldy.w playerpad,x				;pad?
	bmi .t1xxxxxxxxxx				;computer
	cpx.w puckc						;the carrier?
	beq .1xxxxxxxxxxxxxx			;holding the puck: skate
	lda.w PadRaw1,y					;pad buttons
	bit.w #$0080					;A?
	bne .t3x						;A pressed: save
.1xxxxxxxxxxxxxx:					; go to .43
	jmp.w .43						;skate

.t1xxxxxxxxxx:						;computer goalie: save when near
	ldy.w #$0002					;y word
	lda.b [a0],y
	cmp.w #$0023					;target y
	bcc .t2xxxx						;near the net?
	jmp.w .44						;far: skate there

.t2xxxx:							;near: save if the puck is in the crease
	lda.b [a0]						;target x
	cmp.w #$FFE7					;left of the crease?
	bmi .t1xxxxxxxxxxx				;wide of the crease
	cmp.w #$0019					;right of the crease?
	bpl .t1xxxxxxxxxxx				;wide of the crease
	lda.b [a0],y					;target y
	cmp.w #$0013					;within $13?
	bcs .1xxxxxxxxxxxxxxx			;not in the crease: skate
	lda.w pucky						;puck y
	cmp.w #$FEF7					;beyond the bottom goal line?
	bmi .1xxxxxxxxxxxxxxx			;behind: skate
	cmp.w #$0109					;beyond the top goal line?
	bmi .t3x						;shot near the net: save
.1xxxxxxxxxxxxxxx:					;not saving
	jmp.w .43						;skate there

.t1xxxxxxxxxxx:						; go to .48
	jmp.w .48						;wide: skate there

.t3x:								;save: halve his speed
	lda.w Xvel,x					;half x speed
	cmp.w #$8000
	ror a
	sta.w Xvel,x					;half speed
	lda.w Yvel,x					;half y speed
	cmp.w #$8000
	ror a							;half speed
	sta.w Yvel,x					;half speed
	lda.w goalieflags,x				;goalie flags
	bit.w #$0002					;flag 2?
	beq .t1x2						;not flag 2
	jmp.w .40						;flag 2: face the puck

.t1x2:								;where the puck goes: pick a save
	lda.w puckvx					;puck x speed
	xba
	lsr a
	lsr a							;speed / 1024
	and.w #$003F					;6 bits
	bit.w #$0020					;negative?
	beq .1x2
	ora.w #$FFC0					;sign extend
.1x2:								; adc puckx, sbc Xpos,x, d0 = A, ...
	clc
	adc.w puckx						;plus the puck x
	sec
	sbc.w Xpos,x
	sta.b d0						;minus his x
	sta.b r0+2						;dx
	bit.w #$8000
	beq .2xxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xxxxxxx:							; r0 = A, xba, lsr a, ...
	sta.b r0						;|dx|
	lda.w puckvy					;puck y speed
	xba
	lsr a
	lsr a							;speed / 1024
	and.w #$003F					;6 bits
	bit.w #$0020					;negative?
	beq .3xxxx
	ora.w #$FFC0					;sign extend
.3xxxx:								; adc pucky, sbc Ypos,x, d1 = A, ...
	clc
	adc.w pucky						;plus the puck y
	sec
	sbc.w Ypos,x					;minus his y
	sta.b d1						;dy
	bit.w #$8000
	beq .4xx
	eor.w #$FFFF					; negate: two's complement
	inc a
.4xx:								; r1 = A, call vtoa, if d0 = $0008 go to .33, ...
	sta.b r1						;|dy|
	jsl.l vtoa						;direction to the puck
	lda.b d0
	cmp.w #$0008					;no direction?
	beq .33							;no direction: side save
	sec
	sbc.w facedir,x					;minus his facing
	and.w #$0007					;mod 8
	sta.b d3						;turn steps
	beq .33							;facing it: side save
	jmp.w .41						;pick the save
.32:								;puck coming slowly: stand-up save
	lda.w puckvy					;puck y speed
	cmp.w #$0800					;fast down?
	bpl .33							;fast: pick a side
	cmp.w #$F800					;fast up?
	bmi .33							;fast: pick a side
	lda.w #$0008					;stand-up save
	sta.b d0						;stand-up save
	jmp.w .42						;save it
.33:								;pick a side save by facing
	lda.w facedir,x					;his facing
	beq .t1xxxxxxxxxxxx				;facing 0
	cmp.w #$0004					;facing 4?
	beq .35							;facing 4
	cmp.w #$0001
	beq .37							;facing 1
	cmp.w #$0005
	beq .37							;facing 5
	cmp.w #$0007
	beq .38							;facing 7
	cmp.w #$0003
	beq .38							;facing 3
	lda.w seed						;random
	and.w #$0001					;random side
	bra .41							;save

.t1xxxxxxxxxxxx:					;facing 0
	lda.b r0+2						;puck dx sign
	bpl .36							;puck to the right: right
.34:								;turn left
	lda.w #$0007					;left
	bra .41							;save
.35:								;facing 4
	lda.b r0+2						;puck to the left?
	bpl .34							;save
.36:								;turn right
	lda.w #$0001					;right
	bra .41							;save
.37:								;facing 1 or 5
	lda.b r0						;dx
	cmp.b r1						;compare
	bpl .36							;dx >= dy: right
	bra .34							;left
.38:								;facing 3 or 7
	lda.b r1						;dy
	cmp.b r0						;compare
	bpl .36							;dy >= dx: right
	bra .34							;left
.39:								;wide save
	lda.b d0						;save row
	clc
	adc.w #$0006					;plus 6
	sta.b d0						;wide save
	jmp.w .42						;save it
.40:								;flag 2: face the puck direction
	lda.w puckdir,x					;puck direction
	sec
	sbc.w facedir,x					;minus his facing
	and.w #$0007					;mod 8
	sta.b d3						;turn steps
	beq .33							;facing the puck: side save
.41:								;pick the save for a turn of d3 steps
	cmp.w #$0004					;4 steps off?
	beq .32							;opposite: centre save
	lsr a							;half
	lsr a
	sta.b d0						;save side 0 / 1
	lda.w attribute,x				;attribute
	bit.w #$0800					;glove side?
	beq .1xxxxxxxxxxxxxxxx			;right-handed: keep
	lda.b d0
	eor.w #$0001					;other side
	sta.b d0						;flip for a left-handed goalie
.1xxxxxxxxxxxxxxxx:					; if d3 < $0004 go to .2xxxxxxxx, ...
	lda.b d3						;turn steps
	cmp.w #$0004
	bcc .2xxxxxxxx					;4 or less
	eor.w #$FFFF					;more than 4: count the other way
	adc.w #$0008					;steps the other way
.2xxxxxxxx:							; if carry set go to .39, ...
	cmp.w #$0002					;2 or more steps?
	bcs .39							;3 or more: wide save
	lda.w puckz						;puck height
	sec
	sbc.w #$0008					;above 8?
	bpl .42							;in the air: keep
	lda.w puckvz					;puck z speed
	sec
	sbc.w #$0800					;rising?
	bpl .42							;coming up: keep
	lda.b d0
	clc
	adc.w #$0004					;plus 4
	sta.b d0						;low save
	ldy.w #$0002					; more than 8 frames, facing up/down, puck carried: stack (-2)
	lda.b [a0],y					;target y
	cmp.w #$0009					;far enough?
	bcc .42							;close: keep
	lda.w facedir,x
	cmp.w #$0002					;facing 2?
	beq .42							;facing sideways: keep
	cmp.w #$0006
	beq .42
	lda.w puckc						;puck carried?
	bmi .42							;loose: keep
	dec.b d0						;carried puck: one row less
	dec.b d0
.42:								;start save d0
	asl.b d0						;word index
	lda.w #assgoalie_list>>16
	sta.b a1+2
	lda.w #assgoalie_list			;save table
	sta.b a1
	ldy.b d0
	lda.b [a1],y					;save animation
	sta.w pfalock,x					;lock for the animation
	jsl.l SetSPAFromA				;start the save
	lda.l Crowdlevel
	clc
	adc.w #$0096					;crowd +150
	sta.l Crowdlevel
	lda.w #$001E
	sta.b crowdhold					;crowd hold 30
.43:								;move to the target
	lda.b [a0]						;target x from the slot
	sta.b d0						;target x
	lda.w pucky						; puck near the goal line: hug the post (+-$18)
	sec
	sbc.w #$00FC					;deep at the top?
	bpl .1xxxxxxxxxxxxxxxxx			;deep
	lda.w pucky
	sec
	sbc.w #$FF04					;deep at the bottom?
	bpl .44							;not deep
.1xxxxxxxxxxxxxxxxx:				;puck deep in the corner: hug a post
	lda.w #$0018					;right post
	sta.b d0
	lda.w puckx						;right side?
	bpl .44
	lda.w #$FFE8					;left post
	sta.b d0
.44:								; if playerpad,x negative go to .t1xxxxxxxxxxxxx, ...
	lda.w playerpad,x				;pad?
	bmi .t1xxxxxxxxxxxxx
	jmp.w .50						;pad goalie

.t1xxxxxxxxxxxxx:					;computer goalie: stop when the shooter winds up
	ldy.w puckc						;carrier
	bmi .7x							;loose puck: skate
	lda.w pfteam,x					;goalie's team
	cmp.w pfteam,y					;opponent carries?
	beq .7x							;own carrier: skate
	lda.w SPA,y						;shooter's animation
	cmp.w #SPAshotf					;in a shot animation?
	bcc .t2xxxxx					;not shooting
	cmp.w #$F021
	bcs .t2xxxxx					;not shooting
	lda.w Yvel,y					;shooter's y speed
	bit.w #$8000					;|vy|
	beq .1xxxxxxxxxxxxxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.1xxxxxxxxxxxxxxxxxx:				; r0 = A, if Xvel,y bits $8000 clear go to .2xxxxxxxxx, ...
	sta.b r0						;|vy|
	lda.w Xvel,y
	bit.w #$8000
	beq .2xxxxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xxxxxxxxx:						; lsr a, if carry set go to .t2xxxxx, ...
	lsr a
	cmp.b r0						;|vx| / 2 against |vy|
	bcs .t2xxxxx					;moving sideways more: skate
	lda.w goaliestopped				;stopped already?
	bne .7x							;already stopped once: skate
	stz.w Xvel,x					;stop the goalie
	stz.w Yvel,x
	inc.w goaliestopped				;stopped once
	rtl

.t2xxxxx:							; goaliestopped = 0
	stz.w goaliestopped				;moving again
.7x:								; d1 = d2, xba, and #$00FF, ...
	lda.b d2						;target y
	sta.b d1
	pha
	lda.b d0
	pha
	lda.w Xvel,x					;his x speed
	xba								;x speed / 256
	and.w #$00FF					;8 bits
	bit.w #$0080
	beq .1xxxxxxxxxxxxxxxxxxx
	ora.w #$FF00					;sign extend
.1xxxxxxxxxxxxxxxxxxx:				; eor #$FFFF, increment a, d0 = A, ...
	eor.w #$FFFF					;negate
	inc a
	sta.b d0
	pla
	clc
	adc.b d0						;plus the target x
	sec
	sbc.w Xpos,x					;minus his x
	sta.b d0						;dx
	lda.w Yvel,x					;his y speed
	xba								;y speed / 256
	and.w #$00FF					;8 bits
	bit.w #$0080
	beq .2xxxxxxxxxx
	ora.w #$FF00					;sign extend
.2xxxxxxxxxx:						; eor #$FFFF, increment a, d1 = A, ...
	eor.w #$FFFF					;negate
	inc a
	sta.b d1
	pla
	clc
	adc.b d1						;plus the target y
	sec
	sbc.w Ypos,x					;minus his y
	sta.b d1						;dy
	lda.w #$0005					; within 5 (10 with the puck): stop
	sta.b tmp0						;step 5
	cpx.w puckc						;the carrier?
	bne .3xxxxx						;not holding
	asl.b tmp0						;holding: step 10
.3xxxxx:							; if d0 bits $8000 clear go to .4xxx, ...
	lda.b d0						;dx
	bit.w #$8000
	beq .4xxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.4xxx:								; if carry set go to .6x, ...
	cmp.b tmp0						;within the step?
	bcs .6x							;far in x: move
	lda.b d1						;dy
	bit.w #$8000
	beq .5xx
	eor.w #$FFFF					; negate: two's complement
	inc a
.5xx:								; if carry set go to .6x, ...
	cmp.b tmp0						;within the step?
	bcs .6x							;far in y: move
	stz.b d0						;close: stand still
	stz.b d1						;close: stand still
.6x:								; call vtoa, temp2b,x = d0
	jsl.l vtoa						;direction
	lda.b d0
	sta.w temp2b,x					;wanted direction
.45:								;move the computer goalie
	ldy.w playerpad,x				;pad?
	bpl .47							;pad goalie: done
	lda.w temp2b,x					;wanted direction
	sta.b d2						;direction
	sec
	sbc.w #$0007					;8 = none?
	beq .t1xxxxxxxxxxxxxx			;direction 0-7
	bmi .t1xxxxxxxxxxxxxx			;direction 0-7
	jmp.w stopna					;no direction: slow down

.t1xxxxxxxxxxxxxx:					; go to playeracc
	jml.l playeracc					;accelerate toward d2
.46:								; go to .44
	jmp.w .44
.47:								; playerpad,x >= 0: return
	rtl
.48:								;loose puck coming off the boards: go get it
	lda.w puckc						;loose puck?
	bpl .46							;carried: stay
	lda.w iflags					;icing flags
	bit.w #ifok						;icing?
	bne .46							;icing: stay
	lda.w puckx						;|puck x|
	bit.w #$8000
	beq .1xxxxxxxxxxxxxxxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.1xxxxxxxxxxxxxxxxxxxx:				; if minus go to .46, ...
	cmp.w #$0068					;wide?
	bmi .46							;near the middle: stay
	lda.w puckvy					;|puck y speed|
	bit.w #$8000
	beq .2xxxxxxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xxxxxxxxxxx:						; if minus go to .46, ...
	cmp.w #$3800					;fast?
	bmi .46							;slow: stay
	lda.w pucky						;puck y
	cmp.w #$00B8					;deep at the top?
	bpl .3xxxxxx					;deep
	lda.w pucky
	cmp.w #$FF48					;deep at the bottom?
	bpl .46							;in front: stay
.3xxxxxx:							; if pfgoal,x = 0 go to .4xxxx, ...
	lda.w puckvy					;puck y speed
	ldy.w pfgoal,x
	beq .4xxxx						;top end: keep
	eor.w #$FFFF					; negate: two's complement
	inc a
.4xxxx:								; if minus go to .46, ...
	cmp.w #$FC00					;fast enough toward him?
	bmi .46							;not toward his net
	stz.b a1						;home first
	lda.w #$0002
	sta.b a2						;visitors second
	lda.w pfteam,x					;which team?
	beq .5xxx
	stz.b a2						;home
	lda.w #$0002
	sta.b a1						;visitors
.5xxx:								; if tmnear,y < $0132 go to .t1xxxxxxxxxxxxxxx, ...
	ldy.b a1						; tmnear of my team >= $1324 and of the other >= $9C4
	lda.w tmnear,y					;nearest distance
	cmp.w #$0132					;within $132?
	bcc .t1xxxxxxxxxxxxxxx			;teammate close: stay
	ldy.b a2
	lda.w tmnear,y					;other team's nearest
	cmp.w #$0132					;within $132?
	bcc .t1xxxxxxxxxxxxxxx			;opponent close: stay
	lda.w #$000F					;assignment 15
	sta.b d0
	jmp.w assinsert					;clear the puck from the zone

.t1xxxxxxxxxxxxxxx:					; go to .44
	jmp.w .44
.49:								;clamp the target to the goal lines
	lda.w Ypos,x					;his y
	cmp.w #$0108					;past the top goal line?
	bpl .3xxxxxxx					;behind the net: no clamp
	cmp.w #$FEF8
	bmi .3xxxxxxx					;behind the net: no clamp
	cpx.w puckc						;the carrier?
	bne .1xxxxxxxxxxxxxxxxxxxxx		;not holding
	stz.b d0						;holding: centre x
.1xxxxxxxxxxxxxxxxxxxxx:			; if d1 - $0103 negative go to .2xxxxxxxxxxxx, ...
	lda.b d1
	cmp.w #$0103
	bmi .2xxxxxxxxxxxx				;inside
	lda.w #$0103					;top goal line
	sta.b d1						;clamp to the top goal line
.2xxxxxxxxxxxx:						; if d1 - $FEFD >= 0 go to .3xxxxxxx, ...
	lda.b d1
	cmp.w #$FEFD
	bpl .3xxxxxxx					;inside
	lda.w #$FEFD					;bottom goal line
	sta.b d1						;clamp to the bottom goal line
.3xxxxxxx:							; d1 = d1 - d3
	lda.b d1
	sec
	sbc.b d3						;minus the post y
	sta.b d1						;relative to the post
.50:								; return
	rtl
