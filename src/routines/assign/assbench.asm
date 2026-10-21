; Assignment: the player skates to the bench door and leaves
; Takes: X = player object. Called through asstab (assignment $0C) by the player update.
; Phase 1 skates to the bench door (temp3/temp4 = door x/y, temp1 = door timer, 100 = at the wall);
; phase 2 hides the player and brings on the new one (newpnum/newpos).
assbench:							; assignment: skate to the bench door and swap players
	lda.w temp1,x					; door timer; 100 = already at the wall
	cmp.w #$0064
	bne .t2
	jmp.w .5

.t2:								; not at the wall yet: look for a bench change
	jsl.l check4bench				; may request a bench change for this player
	lda.w pflags,x
	bit.w #$4000					; bit $4000 = pf2pen (caused a penalty)
	beq .t1x
.1x:								; unreferenced label
	jml.l assexit					; penalised: leave this assignment

.t1x:								; first frame of the assignment?
	bit.w #$0002					; bit pfna (new assignment)
	beq .2
	and.w #$FFFD					; clear pfna
	sta.w pflags,x
	stz.w temp2,x					; reset the timers
	lda.w #$0008
	sta.w temp2b,x
	lda.w #$0050					; bench y: +80 for the visitors, -80 for the home team
	sta.b d0
	lda.w pfteam,x
	bne .1xx
	lda.w #$FFB0
	sta.b d0
.1xx:								; store the door position
	lda.b d0						; target y at the bench
	sta.w temp4,x					; target y at the bench
	lda.w #$FF70					; door x = -144
	sta.w temp3,x					; target x at the bench
	stz.w temp1,x					; clear the door timer
.2:									; same player coming on?
	lda.w newpnum,x					; same player: just change position
	cmp.w pnum,x					; same player: only the position changes
	bne .t3
.3:									; unreferenced label
	jmp.w .7

.t3:								; different player: head for the door
	lda.w position,x
	bne .1x2						; not the goalie: skip
	lda.w goalieflags,x				; goalie: set goalie flags $0003
	ora.w #$0003
	sta.w goalieflags,x
.1x2:								; count the door timer down by the frame count
	lda.w temp1,x					; count the door timer down
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .t1x2
	jmp.w .6						; still counting: just skate

.t1x2:								; timer expired: re-check the arrival
	lda.w temp1,x
	adc.w #$0008
	sta.w temp1,x
	lda.w Ypos,x					; distance from the bench y, absolute value
	sec
	sbc.w temp4,x
	bit.w #$8000					; absolute value
	beq .2x
.1xx2:								; negate
	eor.w #$FFFF
	inc a
.2x:								; within 40 of the door y?
	cmp.w #$0029
	bcc .t2x
	jmp.w .6						; too far: keep skating

.t2x:								; distance in x to the door
	lda.w Xpos,x					; distance from the bench in x
	sec
	sbc.w temp3,x
	sta.b d0
	sec
	sbc.w #$0020					; within 32 of the door x?
	beq .t1xx
	bmi .t1xx
	jmp.w .6

.t1xx:								; near the door: start gliding in
	lda.w #SPAglide					; glide animation (goalie: ready animation)
	ldy.w position,x
	bne .1x2x
	lda.w #SPAgready
.1x2x:								; start the animation
	jsl.l SetSPAFromA				; start sprite animation A on object X
	lda.w #$0001					; no collisions while gliding
	sta.w pfnc,x
	lda.w facedir,x					; turn one step towards facedir 4 (the wall)
	cmp.w #$0004
	beq .2xx
	inc a							; turn one step
	and.w #$0007
	sta.w facedir,x
.2xx:								; slide left towards the door
	stz.w Yvel,x					; stop moving in y
	lda.w #$F800					; slide toward the door
	sta.w Xvel,x
	lda.b d0						; distance in x
	sec
	sbc.w #$0010					; within 16 of the door?
	beq .3x
	bpl .1
.3x:								; reached the wall: stop sliding
	stz.w Xvel,x
	lda.w facedir,x					; facing the wall?
	cmp.w #$0004
	bne .1
	lda.w #$F800
	sta.w Xvel,x
	lda.w #$0002					; face left
	sta.w facedir,x
	lda.w #SPAwallleft				; wall animation (goalie has its own)
	ldy.w position,x
	bne .4
	lda.w #SPAgwallleft
.4:									; start the animation
	jsl.l SetSPAFromA				; start sprite animation A on object X
	lda.w #$0064					; door timer 100: arrived
	sta.w temp1,x					; door timer 100: at the door
	sta.w pfalock,x					; lock the assignment
.1:									; return
	rtl
.5:									; at the door: mark this roster slot as on the bench
	lda.w pnum,x					; player number
	asl a
	sta.b d0
	stz.b a0
	lda.w pfteam,x					; which team
	beq .1xxx
	lda.w #$0002					; visitors use the second half of tmpdst
	sta.b a0
.1xxx:								; team offset chosen
	lda.b a0
	beq .2xxx
	lda.w #$0034					; second team offset (26 roster slots * 2 bytes)
.2xxx:								; index this player's bench slot
	clc
	adc.b d0
	tay
	lda.w #$FFFE					; TMPDBENCH: on the bench
	sta.w tmpdst,y
	lda.w newpnum,x					; the player who comes on
	sta.b d3
	jsl.l .8						; put him in his position
	jmp.w setplayer					; set up the new player
.6:									; not at the door yet: skate there
	lda.w pfnc,x					; already gliding: leave him
	bne .1
	lda.w pflags,x					; bit $4008 = pf2pen or pfjoycon
	bit.w #$4008
	bne .1
	lda.w temp3,x					; skate to (temp3,temp4) avoiding the puck carrier
	sta.b d0
	lda.w temp4,x					; target y at the bench
	sta.b d1
	lda.w #EvadePC>>16				; a0 = EvadePC
	sta.b a0+2
	lda.w #EvadePC
	sta.b a0
	jml.l skateto					; player X skates toward d0 / d1
.7:									; same player: clear the unavailable flag
	lda.w pflags,x
	and.w #$EFFF					; clear pf2unav ($1000)
	sta.w pflags,x
.8:									; take the new position (newpos) and clear the requests
	lda.w newpos,x					; new position
	sta.b d0
	sta.w position,x				; take it
	jsl.l Setplass					; set up the position
	lda.w #$FFFF					; clear newpnum and newpos
	sta.w newpnum,x
	sta.w newpos,x
	rtl
