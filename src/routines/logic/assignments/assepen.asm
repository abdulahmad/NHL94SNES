; Assignment: the player leaves the penalty box and comes onto the ice
; Takes: X = player object. Called through asstab (assignment $0B).
; First frame: takes one man off PBnum, puts the player at the box door (x Sideline, y +-60) and starts the
; wall animation. Later frames: push him onto the ice and give him a human pad of his team (probably).
assepen:							; assignment: leave the penalty box
	lda.w pflags,x					; player flags
	bit.w #pfna						; first frame of the assignment (pfna)?
	bne .t1
	jmp.w .t2						; no: step out onto the ice

.t1:								; first frame of the assignment
	and.w #$FFFD					; clear pfna
	sta.w pflags,x
	ldy.w #$0010					; box count unit: $10 for the home team
	lda.w pfteam,x
	beq .1							; team 0
	ldy.w #$0001					; 1 for team 1
.1:									; box count unit
	sty.b d0						; take one man out of PBnum
	lda.w PBnum						; box count
	sec
	sbc.b d0						; minus the step
	sta.w PBnum						; store it
	stz.w Xvel,x					; stand still
	stz.w Yvel,x
	lda.w #$003C					; box door y: 60 for the visitors
	sta.b d0
	lda.w pfteam,x					; visitors?
	bne .2
	lda.w #$FFC4
	sta.b d0
.2:									; box door y chosen
	lda.b d0						; y
	sta.w Ypos,x
	lda.w #Sideline					; x at the side boards
	sta.w Xpos,x
	lda.w #$0002					; face left
	sta.w facedir,x
	sta.w pfalock,x					; lock the assignment
	lda.w #SPAwallleft				; wall animation
	jsl.l SetSPAFromA				; start sprite animation A on object X
	jml.l SprSort					; sort the sprites

.t2:								; animation over: out on the ice
	lda.w #$0004					; face right
	sta.w facedir,x
	lda.w #$FFFF					; no player/position requests
	sta.w newpnum,x
	sta.w newpos,x
	lda.w pflags,x					; clear the flags in $9008
	and.w #(~(pfjoycon|pf2unav|pf2npc)&$FFFF)
	sta.w pflags,x
	stz.w pfnc,x					; collisions on
	lda.w #$F000					; skate out at Xvel -$1000
	sta.w Xvel,x
	ldx.b a2						; team of this player
	lda.w teampads,x				; pads of the team
	cmp.w #$0004					; below 4: nothing to hand over (probably)
	bcc .2x
	ldy.w padsitnext,x				; round robin from padsitnext
.loop:								; each pad in turn
	iny
	iny
	cpy.w #$000A					; wrapped past the last?
	bne .1x
	ldy.w #$0000
.1x:								; pad side table index chosen
	lda.w padside,y					; pad of another team or used: next
	bpl .loop
	and.w #$00FF					; team of the pad
	cmp.b a2
	bne .loop						; not this team: next
	sta.w padside,y					; mark the pad as used
	inc a
	inc a
	lsr a
	sta.w cont1team,y				; set the controller team
	ldx.b curobj					; restore the player object
	tya
	sta.w playerpad,x				; player pad
	txa
	sta.w c1playernum,y				; remember the player for the pad
.2x:								; all done
	ldx.b curobj					; restore the player object
	jml.l assexit					; assignment over
