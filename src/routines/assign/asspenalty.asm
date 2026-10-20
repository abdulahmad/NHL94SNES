; Assignment: the player skates to the penalty box
; Takes: X = player object. Called through asstab (assignment $0D). First frame: pad hand-over (.9),
; marks him unavailable and takes the box spot from PenBoxSpot (temp3 = sideline, temp4 = box y); temp5 is a
; timeout of 900 frames. He skates to the box door; when close (or at the timeout) he is put into the box
; and the assignment becomes assdopen (assignment $0E).
asspenalty:							; assignment: skate to the penalty box
	lda.w pflags,x					; player flags
	bit.w #pfna						; first frame of the assignment (pfna)?
	bne .t1
	jmp.w .2

.t1:								; first frame
	jsl.l .9						; pad hand-over
	lda.w pflags,x					; player flags
	and.w #$FFF9					; clear pfna and $0004
	ora.w #$1000					; set pf2unav ($1000)
	sta.w pflags,x
	lda.w #$0000					; d4 = 0
	sta.b d4
	jsl.l setpads					; set the pads
	stz.w temp2,x					; reset the timers
	lda.w #$0008
	sta.w temp2b,x
	jsl.l PenBoxSpot				; box spot of this player
	lda.b r2						; box y
	sta.b d1
	sta.w temp4,x					; target y
	lda.w #sideline					; target x at the side boards
	sta.w temp3,x
	stz.w temp1,x					; clear the door timer
	lda.w pflags,x					; player flags
	ora.w #$8000					; set bit $8000 (pf2npc, no player collision)
	sta.w pflags,x
	stz.w Wallcos,x					; no wall bounce
	stz.w Wallsin,x
	lda.w #$0384					; timeout of 900 frames
	sta.w temp5,x
.2:									; count the timeout down
	lda.w temp5,x
	sec
	sbc.w timestep
	sta.w temp5,x					; timeout minus the frame count
	bpl .6							; still time left
.1:									; timed out: put him in the box
	jmp.w .7						; put him in the box
.3:									; unreferenced label
	rtl								; return
.4:									; skate to the box door (temp3,temp4)
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #rtss>>16					; a0 = rtss
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jml.l skateto					; skate
.6:									; close to the door in y?
	lda.w Ypos,x
	sec
	sbc.w temp4,x					; distance in y
	cmp.w #$FFF3					; further than 13 above: keep skating
	bmi .4
	cmp.w #$000D					; further than 12 below: keep skating
	bpl .4
	lda.w Xpos,x					; distance in x
	sec
	sbc.w temp3,x
	sta.b d0						; d0 = distance in x
	sec
	sbc.w #$FFE8					; more than 24 to go: keep skating
	bmi .4
	lda.w temp1,x					; door timer minus the frame count
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .3							; still counting: return
	adc.w #$0008					; reload 8
	sta.w temp1,x
	cpx.w puckc						; the puck carrier drops the puck
	bne .2x
.1x:								; unreferenced label
	lda.w #$FFFF					; drop the puck
	sta.w puckc
	lda.w #$003C					; no pickup for 60 frames
	sta.w nopuck,x
.2x:								; glide into the door
	lda.w #SPAglide
	sta.w pfnc,x					; no collisions
	jsl.l SetSPAFromA
	lda.w #$0006					; face: 6 (2 for a right handed player)
	sta.b d2
	lda.w handed,x					; handed set = right handed
	beq .3x
	lda.w #$0002
	sta.b d2
.3x:								; turn one step towards d2
	lda.w facedir,x
	cmp.b d2
	beq .5							; facing d2 already?
.4x:								; turn one step
	inc a
	and.w #$0007
	sta.w facedir,x
.5:									; slide towards the door
	stz.w Yvel,x
	lda.w #$1000					; Xvel $1000
	sta.w Xvel,x
	lda.b d0						; distance in x
	sec
	sbc.w #$FFF8					; within 8 of the door?
	bmi .8							; no: return
	stz.w Xvel,x					; stop
	lda.w facedir,x
	cmp.b d2
	bne .8							; not facing the right way: return
.7:									; in the box
	lda.w temp4,x					; put him on the box spot
	sta.w Ypos,x
	lda.w #sideline					; x at the side boards
	sta.w Xpos,x
	lda.w #$0002					; face left
	sta.w facedir,x
	sta.w pfalock,x					; lock the assignment
	lda.w #SPAwallright				; wall animation
	jsl.l SetSPAFromA
	lda.w pflags,x					; player flags
	and.w #$BFFF					; clear bit $4000 (pf2pen)
	sta.w pflags,x
	lda.w #$000E					; assignment $0E: assdopen
	sta.b d0
	jml.l assreplace				; replace the assignment with d0
.8:									; return
	rtl								; return
.9:									; pad hand-over (probably): his pad goes to a teammate
									; when the team has pads to spare
	ldy.b a2						; team index
	lda.w teampads,y				; pads of the team
	cmp.w #$0004					; below 4: no pad to pass
	bcc .3xx
.1xx:								; d1 = number of pads
	sta.b d1
	lda.w #$0006					; check 6 players
	sta.b d0
	lda.w tmsort,y					; first object of the team
	tax
	ldy.w #$0000					; count the skaters in the game
.loop:								; each skater of the team
	lda.w position,x				; goalies and empty slots are not counted
	bmi .2xx
	beq .2xx
	iny								; count this skater
.2xx:								; next slot
	inx
	inx
	dec.b d0						; next slot
	bne .loop
	cpy.b d1						; compare with the pad count
	beq .4xx						; skaters fewer or equal: move a pad away
	bcc .4xx
.3xx:								; hand the pad of this player to a teammate
	ldx.b curobj					; restore the player object
	lda.w playerpad,x				; his pad
	bpl .t1x						; no pad: done
	jmp.w .8						; done

.t1x:								; pass the pad
	sta.b d4						; pad number
	jsl.l PassPadToTeammate			; pass the pad to a teammate
	rtl								; return
.4xx:								; exactly 3 skaters: give the team a pad back
	cpy.w #$0003
	bne .2xxx						; other counts
	ldx.b a2						; team index
	ldy.w padsitnext,x				; round robin from padsitnext
.loopx:								; next pad
	iny
	iny								; wrapped past the last?
	cpy.w #$000A
	bne .1xxx
	ldy.w #$0000
.1xxx:								; search from padsitnext
	lda.w padside,y					; pad side table
	bpl .loopx						; pad belongs to a team?
	and.w #$00FF					; team of the pad
	cmp.b a2
	bne .loopx						; not this team: next
	sta.w padside,y					; mark the pad as used
	inc a
	inc a
	lsr a
	sta.w cont1team,y				; set the controller team
.2xxx:								; free this player's pad
	ldx.b a2						; team index
	ldy.w padsitnext,x				; round robin from padsitnext
	bra .6x							; search the pads
.5x:								; next pad
	iny
	iny
	cpy.w #$000A					; wrapped past the last?
	bne .6x
	ldy.w #$0000
.6x:								; search for a pad of this team
	lda.w padside,y					; pad side table
	cmp.b a2
	bne .5x							; not this team: next
	ora.w #$FF00					; mark the pad as moved
	sta.w padside,y					; no longer on a team
	lda.w #$0000
	sta.w cont1team,y				; clear the controller team
	phy								; keep the pad index
	iny								; step padsitnext on
	iny
	cpy.w #$000A					; wrapped?
	bne .1xxxx
	ldy.w #$0000
.1xxxx:								; store padsitnext
	tya
	sta.w padsitnext,x				; store padsitnext
	ply								; restore the pad index
	ldx.w c1playernum,y				; player object of the pad
	lda.w #$FFFF					; no player any more
	sta.w c1playernum,y
	sta.w playerpad,x				; player no longer has a pad
	jmp.w .3xx						; finish
