; Assignment: the puck carrier
asspuckc:							; X = puck carrier; asstab entry, others and pad players exit
	cpx.w puckc
	bne .1
	lda.w playerpad,x
	bmi .clk
.1:									; go to assexit
	jmp.w assexit					; end the player's current assignment and go back to the one under it

.t1:								; bare return, not branched to in this file
	rtl
.2:									; gmclock != 0: call GlideBack, go to assnothing
	jsl.l GlideBack					; start SPAglideback on player X unless his animation is locked
	jmp.w assnothing				; computer player stands still
.clk:								; playerpad,x negative: if gmclock != 0 go to .2, ...
	lda.w gmclock
	bne .2
	lda.w pflags,x
	bit.w #pfna
	beq .1x
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b
	lda.w seed						; random 0-3
	and.w #$0003
	sta.w temp3,x
.1x:								; temp1,x = temp1,x - d7, if plus go to .3, ...
	lda.w temp1,x					; every aioff frames: checkob, chk4lc, chk4shot, chk4pass
	sec
	sbc.b d7						; minus the frame count
	sta.w temp1,x
	bpl .3
	adc.w aioff,x
	bpl .3x
.2x:								; falls through
	lda.w #$0000
.3x:								; temp1,x = A, call checkob, if breakaway = 0 go to .t1x, ...
	sta.w temp1,x
	jsl.l checkob					; check the other team
	lda.w breakaway
	beq .t1x
	lda.w Ypos,x
	sta.b d0
	bpl .4
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.4:									; if plus go to .t1x, ...
	cmp.w #$0090
	bpl .t1x
	lda.w #$0010
	sta.b d0
	jsl.l assreplace
	bra .10

.t1x:								; no breakaway (or d0 >= $90): check line change and shot
	jsl.l chk4lc
	jsl.l chk4shot					; A computer player looks for a shot
	lda.w asscur,x
	cmp.w #$0011
	bne .3
	jsl.l chk4pass					; pass
.3:									; d0 = $0006 + temp3,x, a0 = PuckcSpots, if sflags bits $8000 clear go...
	lda.w #$0006					; spot index 6
	clc
	adc.w temp3,x
	sta.b d0
	lda.w #PuckcSpots>>16
	sta.b a0+2
	lda.w #PuckcSpots
	sta.b a0
	lda.w sflags
	bit.w #$8000
	beq .2xx
.1xx:								; d0 = position,x
	lda.w position,x				; position index
	sta.b d0
.2xx:								; d0 = [a0],y, Y + 1, Y + 1, ...
	lda.b d0						; d0/d1 = spot x/y, negated for pfgoal clear
	asl a
	asl a
	tay
	lda.b [a0],y					; spot x
	sta.b d0
	iny
	iny
	lda.b [a0],y					; spot y
	sta.b d1
	lda.w pfgoal,x					; which end
	bne .3xx
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.3xx:								; a0 = .chkdir, go to skateto
	lda.w #.chkdir>>16
	sta.b a0+2
	lda.w #.chkdir
	sta.b a0
	jml.l skateto					; d0/d1 = target, a0 = callback
.10:								; return
	rtl
.chkdir:							; skateto callback: turn away from an opponent near where the puck will be
	lda.b d0						; direction from skateto
	and.w #$00FF
	bit.w #$0080
	beq .2xxx
.1xxx:								; ora #$FF00
	ora.w #$FF00
.2xxx:								; d0 = A, if zero go to .3xxx, ...
	sta.b d0						; d2/d3 = puck + velocity
	lda.w Xvel+1,x					; x velocity high byte
	and.w #$00FF
	bit.w #$0080
	beq .3xxx
	ora.w #$FF00
.3xxx:								; adc puckx, d2 = A, if zero go to .4x, ...
	clc
	adc.w puckx						; plus the puck x
	sta.b d2						; d2 = future puck x
	lda.w Yvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .4x
	ora.w #$FF00
.4x:								; adc pucky, d3 = A, threat = 0, ...
	clc
	adc.w pucky						; plus the puck y
	sta.b d3						; d3 = future puck y
	stz.w threat					; no threat yet
	lda.w #$0005					; 6 opponents
	sta.b d4
	stz.b a0						; the 6 opponents
	cpx.w #$000C
	bcs .6
.5:									; a0 = $000C
	lda.w #$000C
	sta.b a0
.6:									; loop: if zero go to .7, ...
	ldy.b a0						; opponent
	lda.w Xvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .7
	ora.w #$FF00
.7:									; adc Xpos,y, sbc d2, if minus go to .9, ...
	clc
	adc.w Xpos,y					; plus his x
	sec
	sbc.b d2						; minus the future puck x
	cmp.w #$FFEB
	bmi .9
	cmp.w #$0015
	bpl .9
	lda.w Yvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .8
	ora.w #$FF00
.8:									; adc Ypos,y, sbc d3, if minus go to .9, ...
	clc
	adc.w Ypos,y					; plus his y
	sec
	sbc.b d3						; minus the future puck y
	cmp.w #$FFEB
	bmi .9
	cmp.w #$0015
	bpl .9
	inc.w threat					; threat +1; facing straight at it: turn one step either way
	lda.w Xpos,x					; vector from him to X
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa						; vector to direction
	lda.w facedir,x					; X's facing
	eor.w #$0004
	cmp.b d0						; facing straight at him?
	bne .9
	lda.w seed+2					; random
	and.w #$0001					; one step either way
	clc
	adc.b d0
	and.w #$0007					; new direction
	sta.b d0
.9:									; increment a0, increment a0, decrement d4, ...
	inc.b a0						; next opponent
	inc.b a0
	dec.b d4						; opponents left
	bmi .t1xx
	jmp.w .6

.t1xx:								; loop over, return
	rtl
