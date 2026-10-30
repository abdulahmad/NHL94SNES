; Animation, speed, position, input and assignment for every object
updateplayers:						; called from DoGameFrame
	lda.w #$FFFF					;none yet:
	sta.w topgoalie					;goalies at each end,
	sta.w botgoalie
	sta.w tmnear					;nearest players to the puck
	sta.w tmnear+2
	sta.w tmnearpl
	sta.w tmnearpl+2
	lda.w puckz
	sta.w puckoldz					;puck height of the last frame
	ldx.w #$001E					;from the last object
.2:									; curobj = X, OldXpos,x = Xpos,x, OldXfrac,x = Xfrac,x, ...
	stx.b curobj					;current object
	lda.w Xpos,x
	sta.w OldXpos,x					;keep the old position
	lda.w Xfrac,x
	sta.w OldXfrac,x
	lda.w Ypos,x
	sta.w OldYpos,x
	lda.w Yfrac,x
	sta.w OldYfrac,x
	cpx.w #$0018					;net 1?
	beq .1							;nets: just move
	cpx.w #$001A					;net 2?
	bne .t2
.1:									; go to .9
	jmp.w .9

.t2:								; if position,x >= 0 go to .t1, ...
	lda.w position,x				;on the ice?
	bpl .t1
	jmp.w .11						;no: distances only

.t1:								; position,x >= 0: if not zero go to .8, ...
	bne .8							;skater
	lda.w Ypos,x					;goalie: which end?
	bpl .t3
	stx.w botgoalie					;bottom goalie
	bra .8

.t3:								; Ypos,x >= 0: topgoalie = X
	stx.w topgoalie					;top goalie
.8:									; call updateanim, if plus go to .1x, ...
	jsl.l updateanim				; step object X's sprite animation, looping or ending it
	lda.w nopuck,x					;no-puck timer
	sec
	sbc.w timestep					;minus the frame time
	bpl .1x
	lda.w #$0000					;floor at 0
.1x:								; nopuck,x = A, if plus go to .2x, ...
	sta.w nopuck,x
	lda.w nopuckb,x					;no-body timer
	sec
	sbc.w timestep
	bpl .2x
	lda.w #$0000					;floor at 0
.2x:								; nopuckb,x = A, if sflags3 bits $0020 clear go to .4, ...
	sta.w nopuckb,x
	lda.w sflags3
	bit.w #$0020					;team structs on?
	beq .4							;no
	lda.w pnum,x
	and.w #$00FF					;roster byte
	cmp.w #$0080					;signed?
	bcc .3
	ora.w #$FF00					;sign extend
.3:									; d0 = A, if minus go to .4, ...
	sta.b d0
	cmp.w #$0000
	bmi .4							;none: skip
	asl.b d0						;word index
	jsl.l loadTeamStruct			; a2 = player X's team, a1 = the other team
.4:									; if goaliedivewait,x = 0 go to .6, ...
	lda.w goaliedivewait,x			;goalie dive wait
	beq .6							;none
	sec
	sbc.w timestep					;count it down
	bpl .5
	lda.w #$0000					;floor at 0
.5:									; goaliedivewait,x = A
	sta.w goaliedivewait,x
.6:									; if not zero go to .7, ...
	cpx.w passReceiverPlayerNum		;pass receiver?
	bne .7
	lda.w onetimer					;one timer coming?
	bne .10							;yes: hold his speed
.7:									; if SPA,x != SPAinjury1 go to .t1x, ...
	lda.w SPA,x
	cmp.w #SPAinjury1				;injured?
	bne .t1x
	jmp.w .11						;yes: no movement step

.t1x:								; SPA,x != SPAinjury1: if carry clear go to .t2x, ...
	cmp.w #SPAboardfront			;boards or later animations?
	bcc .t2x
	jmp.w .11						;yes: no movement step

.t2x:								; if not zero go to .9, ...
	cpx.w #$001C					;puck?
	bne .9
	lda.w puckz						;in the air?
	bne .10							;yes: no friction
.9:									; txy, d2 = .20,x & $00FF, if pflags,y bits $0001 clear go to .1xx, ...
	txy
	ldx.w timestep					;frame time
	lda.l .20,x						;friction factor for it
	and.w #$00FF
	sta.b d2
	lda.w pflags,y					;flags
	bit.w #$0001					;gliding?
	beq .1xx
	lda.l .22-1,x					;gliding friction
	and.w #$00FF
	sta.b d2
.1xx:								; call Mul16x8HiXS, Xvel,y = A, call Mul16x8HiXS, ...
	ldx.w Xvel,y
	lda.b d2
	jsl.l Mul16x8HiXS				;slow x
	sta.w Xvel,y
	ldx.w Yvel,y
	lda.b d2
	jsl.l Mul16x8HiXS				;slow y
	sta.w Yvel,y
	tyx
.10:								; p0 = velstep, if Xvel,x = 0 go to .1xxx, ...
	lda.w velstep					;speed scale for the frame
	sta.b p0
	lda.w Xvel,x					;x speed
	beq .1xxx						;still
	tax
	lda.b p0
	jsl.l Mul16x8XS					;times the scale
	ldx.b curobj
	lda.b r2
	clc
	adc.w Xfrac,x					;plus the fraction
	sta.w Xfrac,x
	lda.b r2+2
	adc.w Xpos,x					;plus the carry
	sta.w Xpos,x					;new x
.1xxx:								; if Yvel,x = 0 go to .2xx, ...
	lda.w Yvel,x					;y speed
	beq .2xx						;still
	tax
	lda.b p0
	jsl.l Mul16x8XS					;times the scale
	ldx.b curobj
	lda.b r2
	clc
	adc.w Yfrac,x					;plus the fraction
	sta.w Yfrac,x
	lda.b r2+2
	adc.w Ypos,x					;plus the carry
	sta.w Ypos,x					;new y
.2xx:								; if not zero go to .11, ...
	cpx.w #$001C					;puck?
	bne .11							;no
	lda.w puckz						;height
	bmi .11							;below the ice: done
	bne .3x							;in the air
	lda.w puckvz					;rising?
	beq .11							;no: done
.3x:								; puckvz = puckvz - gravstep, call Mul16x8XS, puckzfrac = r2 + puckzfra...
	lda.w puckvz
	sec
	sbc.w gravstep
	sta.w puckvz
	tax								;speed z
	lda.w velstep
	jsl.l Mul16x8XS					;times the scale
	ldx.b curobj
	lda.b r2
	clc
	adc.w puckzfrac					;height fraction
	sta.w puckzfrac
	lda.b r2+2
	adc.w puckz						;height
	sta.w puckz
	bpl .11							;still above the ice
	stz.w puckz						;landed
	stz.w puckzfrac
	lda.w puckvz
	eor.w #$FFFF					;bounce up
	inc a
	lsr a							;half the speed
	sta.w puckvz
	cmp.w #$0200					;big bounce?
	bmi .11							;no: quiet
	asl a							;x4
	asl a
	sta.b p0						;sound velocity
	stz.b p0+2
	lda.w #$0007					;bounce sound
	jsl.l sfx						; play sound A with the velocity in p0 / p0+2
.11:								; d0 = puckx - Xpos,x, if plus go to .1xxxx, ...
	lda.w puckx						;puck x
	sec
	sbc.w Xpos,x					;minus his x
	sta.b d0						;d0 = dx
	bpl .1xxxx
	eor.w #$FFFF					;|dx|
	inc a
.1xxxx:								; lsr a, lsr a, call Mul8U, ...
	pha
	lsr a							;/4
	lsr a
	tax
	jsl.l Mul8U						;squared
	ldx.b curobj
	sta.w puckdist2,x				;dx^2/16
	lda.w pucky						;puck y
	sec
	sbc.w Ypos,x					;minus his y
	sta.b d1						;d1 = dy
	bpl .2xxx
	eor.w #$FFFF					;|dy|
	inc a
.2xxx:								; lsr a, lsr a, call Mul8U, ...
	pha
	lsr a							;/4
	lsr a
	tax
	jsl.l Mul8U						;squared
	ldx.b curobj
	clc
	adc.w puckdist2,x				;plus dx^2/16
	sta.w puckdist2,x				;squared distance
	cpx.w #$0018					;player?
	bcs .12							;no
	sta.b r3
	lda.w position,x				;on the ice?
	bmi .12							;no
	beq .12							;goalie: not counted
	lda.w pflags,x
	and.w #$1000					;falling flag
	ora.w pfalock,x					;or locked animation
	bne .12							;busy: not counted
	lda.b r3						;his distance
	cpx.w #$000C					;visitors?
	bcs .t1xx
	cmp.w tmnear					;nearer than the home best?
	bcs .12
	sta.w tmnear					;nearest home player
	stx.w tmnearpl
	bra .12
									;nearer than the visitors' best?
.t1xx:								; r3 >= $000C: if carry set go to .12, ...
	cmp.w tmnear+2
	bcs .12
	sta.w tmnear+2					;nearest visitors' player
	stx.w tmnearpl+2
.12:								; call ApproxLength_abs, puckdist,x = A, if carry set go to .14, ...
	ply								;|dy|
	pla								;|dx|
	jsl.l ApproxLength_abs			;true distance
	ldx.b curobj
	sta.w puckdist,x				;distance to the puck
	cpx.w #$0018					;player?
	bcs .14							;no
	cmp.w #$001E					;within 30?
	bcs .14							;no
	lda.w iflags					;icing flags
	bit.w #$0004					;icing pending?
	beq .14							;no
	bit.w #$0001					;already waved?
	bne .14							;yes
	and.w #$0002					;which side iced?
	beq .t1xxx
	lda.w pfgoal,x					;defending this end?
	bne .14							;no
	bra .13

.t1xxx:								; if pfgoal,x = 0 go to .14
	lda.w pfgoal,x					;defending this end?
	beq .14							;no
.13:								; if puckz >= $000D go to .14, ...
	lda.w puckz						;puck height
	cmp.w #$000D					;above 13?
	bcs .14							;yes: still icing
	lda.w puckvy					;puck y speed
	cmp.w #$2400					;fast?
	bcs .14							;yes: still icing
	cmp.w #$DC00					;fast the other way?
	bmi .14							;yes: still icing
	lda.w #$0005					;cancel the icing
	trb.w iflags					;he touched it
.14:								; call vtoa, puckdir,x = A, X - 1, ...
	jsl.l vtoa						;direction to the puck
	sta.w puckdir,x					;puck direction
	dex
	dex
	bmi .t1xxxx						;all objects?
	jmp.w .2						;no: next

.t1xxxx:							; X counted below 0: if Ypos+$18 - $011F negative go to .1xxxxx, ...
	lda.w Ypos+netobj1				;net 1 y
	cmp.w #$011F					;above $11F?
	bmi .1xxxxx						;no
	lda.w #$011F					;clamp
.1xxxxx:							; Ypos+$18 = A, if Ypos+$1A - $FED2 >= 0 go to .2xxxx, ...
	sta.w Ypos+netobj1
	lda.w Ypos+netobj2				;net 2 y
	cmp.w #$FED2					;below -$12E?
	bpl .2xxxx						;no
	lda.w #$FED2					;clamp
.2xxxx:								; Ypos+$1A = A
	sta.w Ypos+netobj2
	ldy.w #$000C					;7 pads
	lda.w #$000F					;object $0F: none
.loop:								; loop: PadControlObj,y = A, Y - 1, Y - 1, ...
	sta.w PadControlObj,y			;no pad object yet
	dey
	dey
	bpl .loop
	ldx.w #$0008					;5 pads
	lda.w #$0000
.loop2:								; loop: padinputdone,x = A, X - 1, X - 1, ...
	sta.w padinputdone,x			;no input read yet
	dex
	dex
	bpl .loop2
	lda.w #$0000
	sta.b curobjteam				;home first
	lda.w #$0002
	sta.b curobjopp					;opponent visitors
	ldx.w #$0000					;from object 0
.15:								; a3 = X, curobj = X, if not zero go to .1xxxxxx, ...
	stx.b a3
	stx.b curobj
	cpx.w #$000C					;visitors start?
	bne .1xxxxxx
	lda.w #$0002					;team visitors
	sta.b curobjteam
	lda.w #$0000					;opponent home
	sta.b curobjopp
.1xxxxxx:							; PlayersUnused = $FFFF, if position,x >= 0 go to .t2xx, ...
	lda.w #$FFFF
	sta.b PlayersUnused
	lda.w position,x
	bpl .t2xx						;on the ice?
	jmp.w .19						;no: next

.t2xx:								; position,x >= 0: d6 = X / 2, if not zero go to .1xxxxxxx, ...
	txa
	lsr a							;object number
	sta.b d6						;d6 = object / 2
	cpx.w puckc						;puck carrier?
	bne .1xxxxxxx					;no
	lda.w sfhormode					;horizontal mode?
	bne .1xxxxxxx					;yes: no marker
	lda.w #$0000
	sta.b d4						;marker 0
	jsl.l setpads					; pad marker d4 follows player X
.1xxxxxxx:							; if carry set go to .t1xxxxx, ...
	cpx.w #$0018					;player?
	bcs .t1xxxxx					;no: no input
	lda.w playerpad,x				;his pad
	bmi .t1xxxxx					;none: AI
	tay
	lda.w padinputdone,y			;pad read already?
	bne .t1xxxxx					;yes
	lda.w #$0001
	sta.w padinputdone,y			;mark it read
	lda.w JoyPad,y
	sta.b d3						;held buttons
	lda.w padchange,y
	sta.b d2						;changed buttons
	lda.w padnew,y
	sta.b d1						;new presses
	lda.w paddir,y
	sta.b d0						;direction
	iny
	iny
	sty.b d4
	jsl.l doinput					; pad input for player X
	bra .t1xxxxx

.t1xxxxx:							; if pfalock,x != 0 go to .1xxxxxxxx, ...
	lda.w pfalock,x					;animation locked?
	bne .1xxxxxxxx					;yes: no assignment
	lda.w asscur,x					;current assignment
	asl a
	asl a							;4 bytes each
	tax
	lda.l asstab,x					;routine low
	sta.w jmlvector+1				;into the jump vector
	lda.l asstab+1,x				;routine high
	sta.w jmlvector+2
	ldx.b curobj
	jsl.l loadTeamStruct			;team pointers
	jsl.l jmlvector					;run the assignment
.1xxxxxxxx:							; ora gmclock, if not zero go to .17, ...
	lda.w position,x
	ora.w gmclock					;goalie with the clock stopped?
	bne .17							;no: no clamp
	cpx.w #$0018					;player?
	bcs .17							;no
	cpx.w puckc						;puck carrier?
	beq .17							;yes: no clamp
	lda.w goalieflags,x
	bit.w #$0001					;out of the crease?
	bne .17							;yes: no clamp
	lda.w Xpos,x					;his x
	cmp.w #$FFD5					;left of the crease?
	bpl .t3x						;no
	cmp.w #$FFCF					;far left?
	bmi .16							;yes: leave it
	lda.w #$FFD5					;left crease edge
	stz.w Xvel,x					;stop
	bra .16

.t3x:								; Xpos,x - $FFD5 >= 0: if minus go to .16, ...
	cmp.w #$002C					;right of the crease?
	bmi .16							;no
	cmp.w #$0031					;far right?
	bpl .16							;yes: leave it
	lda.w #$002B					;right crease edge
	stz.w Xvel,x					;stop
.16:								; Xpos,x = A, if Ypos,x >= 0 go to .t1xxxxxx, ...
	sta.w Xpos,x					;clamped x
	lda.w Ypos,x					;his y
	bpl .t1xxxxxx					;bottom end
	cmp.w #$FF1C					;above the crease?
	bmi .17							;yes: done
	cmp.w #$FF21					;inside the edge band?
	bpl .17							;no
	lda.w #$FF1B					;crease top
	sta.w Ypos,x
	stz.w Yvel,x					;stop
	bra .17

.t1xxxxxx:							; Ypos,x >= 0: if plus go to .17, ...
	cmp.w #$00E5					;below the crease?
	bpl .17							;yes: done
	cmp.w #$00E0					;inside the edge band?
	bmi .17							;no
	lda.w #$00E5					;crease bottom
	sta.w Ypos,x
	stz.w Yvel,x					;stop
.17:								; Wallcos,x = 0, Wallsin,x = 0, d3 = Ypos,x, ...
	stz.w Wallcos,x					;no wall contact
	stz.w Wallsin,x
	lda.w Ypos,x
	sta.b d3
	lda.w Xpos,x					;new x
	sta.b d2
	cmp.w OldXpos,x					;moved in x?
	bne .t1xxxxxxx					;yes: check
	lda.b d3
	cmp.w OldYpos,x					;moved in y?
	bne .t1xxxxxxx					;yes: check
	jmp.w .18						;still: no collision

.t1xxxxxxx:							; call checkcoll, if carry set go to .18, ...
	jsl.l checkcoll					;move with collisions
	cpx.w #$0018					;player?
	bcs .18							;no
	lda.w position,x				;goalie?
	beq .18							;yes: can enter the net
	lda.w pflags,x
	and.w #$8000					;no-clip flag
	ora.w sfhormode					;or horizontal mode
	bne .18							;no net check
	lda.w Xpos,x
	cmp.w #$FFE7					;beside the net?
	bmi .18							;no
	cmp.w #$0019					;beside the net?
	bpl .18							;no
	lda.w Ypos,x					;his y
	bit.w #$8000
	beq .1xxxxxxxxx					;top half
	eor.w #$FFFF					; negate: two's complement
	inc a							;|y|
.1xxxxxxxxx:						; sbc #$010D, r0 = A, if OldYpos,x bits $8000 clear go to .2xxxxx, ...
	sec
	sbc.w #$010D					;minus the goal line
	sta.b r0						;side of the goal line now
	lda.w OldYpos,x					;old y
	bit.w #$8000
	beq .2xxxxx						;top half
	eor.w #$FFFF					; negate: two's complement
	inc a							;|old y|
.2xxxxx:							; sbc #$010D, eor r0, if minus go to .4x, ...
	sec
	sbc.w #$010D					;minus the goal line
	eor.b r0						;crossed it?
	bmi .4x							;yes: blocked
	lda.w Ypos,x					;his y
	bit.w #$8000
	beq .3xx						;top half
	eor.w #$FFFF					; negate: two's complement
	inc a							;|y|
.3xx:								; if carry clear go to .18, ...
	cmp.w #$0103					;in front of the net?
	bcc .18							;yes: fine
	cmp.w #$0117					;behind the net?
	bcs .18							;yes: fine
.4x:								;inside the net: undo the move
	lda.w OldXpos,x
	sta.w Xpos,x
	lda.w OldYpos,x
	sta.w Ypos,x
.18:								; if plus go to .19, ...
	lda.w impact,x					;hit strength
	sec
	sbc.w impactstep				;fades each frame
	bpl .19
	lda.w #$0000					;floor at 0
.19:								; impact,x = A, X + 1, X + 1, ...
	sta.w impact,x
	inx
	inx
	cpx.w #$0020					;all objects?
	beq .t1xxxxxxxx
	jmp.w .15						;no: next

.t1xxxxxxxx:						; if puckz >= $0018 go to .2xxxxxx, ...
	lda.w puckz						;puck height
	cmp.w #$0018					;high: no side clamp
	bcs .2xxxxxx
	lda.w puckx
	cmp.w #$FF78					;past the left boards?
	bpl .1xxxxxxxxxx
	lda.w #$FF78					;clamp
	sta.w puckx
	ldx.w frame+puckscnum				;puck frame
	cpx.w #SPFpuck					;on the ice?
	bne .1xxxxxxxxxx
	sta.w Xpos+puckscnum+2			;move the shadow too
.1xxxxxxxxxx:						; if puckx - Sideline negative go to .2xxxxxx, ...
	lda.w puckx
	cmp.w #Sideline					;past the right boards?
	bmi .2xxxxxx
	lda.w #Sideline					;clamp
	sta.w puckx
	ldx.w frame+puckscnum
	cpx.w #SPFpuck					;on the ice?
	bne .2xxxxxx
	sta.w Xpos+puckscnum+2			;move the shadow too
.2xxxxxx:							; if puckz != 0 go to .4xx, ...
	lda.w puckz
	bne .4xx						;in the air: no end clamp
	lda.w pucky
	cmp.w #$FEC2					;inside the rink ends?
	bmi .4xx						;no: in a net, leave it
	cmp.w #$013E					;inside the rink ends?
	bpl .4xx						;no: leave it
	lda.w pucky
	cmp.w #$FEDB					;past the back boards?
	bpl .3xxx
	lda.w #$FEDB					;clamp
	sta.w pucky
	sta.w Ypos+puckscnum+2			;shadow too
.3xxx:								; if pucky - $012A negative go to .4xx, ...
	lda.w pucky
	cmp.w #$012A					;past the front boards?
	bmi .4xx
	lda.w #$012A					;clamp
	sta.w pucky
	sta.w Ypos+puckscnum+2			;shadow too
.4xx:								; if puckc negative go to .20, ...
	lda.w puckc
	bmi .20							;loose puck
	lda.w pucky
	sta.l carriedy					;carried puck y
.20:								; return
	rtl
.21:								;friction per frame time (indexed from .20, timestep 1-10)
	db $FD,$FA,$F7,$F4,$F1,$EE,$EB,$E8,$E6,$E3
.22:								;gliding friction per frame time
	db $FF,$FF,$FE,$FE,$FE,$FD,$FD,$FD,$FC,$FC
