; Assignment: the face off and the setup for play
puckfaceoff2:						; called from asstab
	lda.w pflags,x					; new assignment?
	bit.w #pfna
	bne .t2
	jmp.w .18

.t2:								; pflags,x bit pfna set: and #$FFFD, pflags,x = A, xsave = X, ...
	and.w #$FFFD
	sta.w pflags,x
	stx.b xsave						; keep X
	ldx.w #$0000
.loop:								; save d0 and the words after it (16 words)
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .loop
	ldx.b xsave						; restore X
	stx.b xsave						; keep X
	ldx.w #$0000
.loop2:								; save a0 and the words after it (14 words)
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .loop2
	ldx.b xsave						; restore X
	lda.w #$7000
	sta.b SfxVelocity
	lda.w #$0012
	jsl.l QueueSound				; queue sound A
	lda.w #$0013
	jsl.l QueueSound				; queue sound A
	lda.w #$FFFF
	sta.w recsfx
	sta.w recsfx2
	lda.w #$0000
	sta.l hattrick
	lda.l Crowdlevel
	cmp.w #$0258
	bcc .1
	lda.w #$0258
	sta.l Crowdlevel
.1:									; if brightness = 0 go to .2, ...
	lda.w brightness
	beq .2
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
	stz.w brightness
.2:									; call FadeIn, fadestep = $000A, if MusicOn != 0 go to .4, ...
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	lda.w #$000A
	sta.w fadestep
	lda.w MusicOn
	bne .4
	lda.w PBnum
	beq .t3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b r3
	lda.w PBnum
	and.w #$000F
	cmp.b r3
	beq .t3
	bcs .t1
.3:									; call PlayTeamSong, go to .4
	lda.w #$0004
	jsl.l PlayTeamSong				; play song slot A of the home team
	bra .4

.t1:								; call PlayTeamSong, go to .4
	lda.w #$0001
	jsl.l PlayTeamSong				; play song slot A of the home team
	bra .4

.t3:								; if percue != 0 go to .1x, ...
	ldy.w percue
	bne .1x
	lda.l OptPlayMode
	cmp.w #$0004
	beq .4
	jsl.l RandomWord
	and.w #$0003
	bne .4
.1x:								; if percue != 0 go to .3x
	lda.w #$0000
	ldy.w percue
	bne .3x
.2x:								; falls through
	lda.w #$0002
.3x:								; call PlayTeamSong, percue = 0
	jsl.l PlayTeamSong				; play song slot A of the home team
	stz.w percue
.4:									; trb sflags, trb sflags3, iflags = 0, ...
	lda.w #$000D
	trb.w sflags
	lda.w #$0001
	trb.w sflags3
	stz.w iflags					; no icing, no lower lc box, glove spots cleared
	stz.w replaydelay
	lda.w #$FFFF					; -1 marks the ref count, crossings, puck carrier and receiver as none
	sta.w RefCnt
	sta.w puckcross+pcframes
	sta.w puckcross+pcsize+pcframes
	sta.w puckz
	sta.w passReceiverPlayerNum
	asl a
	sta.w puckc
	lda.w #$8200
	trb.w sflags
	lda.w #$0000
	sta.l refwindow
	sta.l penmsgbox
	lda.w #$0500
	tsb.w sflags
	jsl.l ClrHor					; back to the vertical rink
	stz.w Vpos						; Vpos = Hpos = 0
	stz.w Hpos
	lda.l fox
	sta.w puckx
	lda.l foy
	sta.w pucky
	stz.w puckvx
	stz.w puckvy
	stz.w puckvz
	stz.w Xvel+netobj1				; goal nets (objects 12/13) at y +-268
	stz.w Yvel+netobj1
	stz.w Xpos+netobj1
	lda.w #$010C
	sta.w Ypos+netobj1
	stz.w Xvel+netobj2				; goal net 2 at y -268
	stz.w Yvel+netobj2
	stz.w Xpos+netobj2
	lda.w #$FEF4
	sta.w Ypos+netobj2
	lda.w #SPFpuck					; object 15 (puck shadow) = SPFpuck
	sta.w frame+puckobj+2
	stz.w SPA+puckobj+2
	stz.w attribute+puckobj+2
	stz.w attribute+puckobj
	lda.w #$0040
	trb.w sflags
	lda.w #$0064					; 100 scroll steps
	sta.b d4
.loopx:								;scroll to the faceoff spot
	jsl.l checkwindow				; move the view so the screen follows the puck
	dec.b d4
	bpl .loopx
	lda.w #$003C					; yleader = 60
	sta.w yleader
	jsl.l ResetBench				; ResetBench
	stz.b a2
	jsl.l setpersonel				; update the players on the ice
	jsl.l forcepldata				; face offs: move team a2's players straight to their new positions
	inc.b a2
	inc.b a2
	jsl.l setpersonel				; update the players on the ice
	jsl.l forcepldata				; face offs: move team a2's players straight to their new positions
	jsl.l resetplstuff				; resetplstuff
	lda.w #$FFFF
	sta.w tmtouch2
	sta.w tmtouch3
	sta.w tmtouch2+2
	sta.w tmtouch3+2
	lda.b a3+2						; push a3
	pha
	lda.b a3
	pha
	stz.b a3
	lda.w #$000B					; 12 objects
	sta.b d2
	lda.b d2
	pha
.14:								; if a3 >= $0018 go to .1xx, ...
	ldx.b a3
	cpx.w #$0018
	bcs .1xx
	lda.w pfteam,x
	lsr a
	eor.w gmode
	and.w #$0002
	lsr a
	eor.w #$0001
	sta.w pfgoal,x
.1xx:								; if carry clear go to .2xx, ...
	lda.w pnum,x
	asl a
	cpx.w #$000C
	bcc .2xx
	clc
	adc.w #$0034
.2xx:								; if tmpdst,x negative go to .t2x, ...
	tax
	lda.w tmpdst,x
	bmi .t2x
	bit.w #$1000
	bne .t2x
	jmp.w .16

.t2x:								;each player: assignment and faceoff position
	ldx.b a3
	lda.w #$FF10					; Xpos = -240, off the screen
	sta.w Xpos,x
	stz.w Ypos,x
	lda.w #$0001
	sta.w frame,x
	lda.w position,x
	sta.b d1						; d1 = position
	bpl .t1x
	jmp.w .16

.t1x:								; if zero go to .5, ...
	beq .5
	lda.w penshot
	beq .2xxx
	phx
	ldx.w #$0008
	lda.w BA_Team
	beq .1xxx
	ldx.w #$0014
.1xxx:								; pnum,x = BA_Skater_Offset, d3 = BA_Skater_Offset
	lda.w BA_Skater_Offset
	sta.w pnum,x
	sta.b d3
	plx
.2xxx:								; d0 = $0016, if d1 != $0004 go to .4x, ...
	lda.w #$0016
	sta.b d0
	lda.b d1						; centers take the faceoff
	cmp.w #$0004
	bne .4x
	stz.b a2						; center: team touches = him only
	lda.w pfteam,x
	beq .3xx
	inc.b a2
	inc.b a2
.3xx:								; tmtouch1,y = pnum,x & $00FF, tmflags,y = $0004, d0 = $0017
	ldy.b a2
	lda.w pnum,x
	and.w #$00FF
	sta.w tmtouch1,y
	lda.w #$0004
	sta.w tmflags,y
	lda.w #$0017
	sta.b d0
.4x:								; call assinsert
	jsl.l assinsert					; insert assignment d0
.5:									; d4 = tmap, if pfteam,x = 0 go to .6, ...
	lda.w tmap						; d4 = (6-tmap)*8: .apl row
	sta.b d4
	ldx.b a3
	lda.w pfteam,x
	beq .6
	lda.w tmap+2
	sta.b d4
.6:									; d4 = -(d4) + $0006 * 2 * 2 * 2, a1 = long .19 + d4, ...
	lda.b d4
	eor.w #$FFFF					; negate
	inc a
	clc
	adc.w #$0006
	asl a
	asl a
	asl a
	sta.b d4
	lda.w #.19>>16
	sta.b a1+2
	lda.w #.19
	clc
	adc.b d4
	sta.b a1
	lda.w penshot
	beq .7
	lda.w #.20>>16
	sta.b a1+2
	lda.w #.20
	sta.b a1
.7:									; d4 = [a1],y & $00FF * 2 * 2, a1 = long .21, ...
	ldy.b d1
	lda.b [a1],y					; table entry for the position
	and.w #$00FF
	asl a							; entry to a .ptab offset
	asl a
	sta.b d4
	lda.w #.21>>16
	sta.b a1+2
	lda.w #.21
	sta.b a1
	ldy.b d4
	lda.b [a1],y					; X and Y offsets of the position
	sta.b d0
	iny
	iny
	lda.b [a1],y
	sta.b d1
	lda.w pfgoal,x					; mirror for the top goal
	bne .8
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.8:									; if position,x = 0 go to .13, ...
	lda.w position,x
	beq .13
	lda.b d4						; defense (entry <= 2*4): shift by fox/foy
	cmp.w #$0009
	bpl .12
	lda.l fox
	eor.b d0
	bpl .10
	lda.l foy
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .9
	ora.w #$E000
.9:									; eor #$FFFF, increment a, adc d1, ...
	eor.w #$FFFF					; negate
	inc a
	clc
	adc.b d1
	sta.b d1
.10:								; if zero go to .11, ...
	lda.l fox
	lsr a
	lsr a
	bit.w #$2000
	beq .11
	ora.w #$C000
.11:								; d3 = A, d0 = d0 - d3
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	sta.b d0
.12:								; d0 = d0 + fox, d1 = d1 + foy
	lda.b d0						; add the faceoff spot
	clc
	adc.l fox
	sta.b d0
	lda.b d1
	clc
	adc.l foy
	sta.b d1
.13:								; Xpos,x = d0, d0 = -(d0 - puckx), Ypos,x = d1, ...
	lda.b d0						; store X
	sta.w Xpos,x
	sec
	sbc.w puckx
	eor.w #$FFFF					; negate
	inc a
	sta.b d0
	lda.b d1						; store Y
	sta.w Ypos,x
	sec
	sbc.w pucky
	eor.w #$FFFF					; negate
	inc a
	sta.b d1
	stz.w Xvel,x					; stand still
	stz.w Yvel,x
	jsl.l vtoa						; face the puck
	lda.b d0
	sta.w facedir,x
	lda.w pflags,x
	and.w #$EFFF
	sta.w pflags,x
	stz.w pfalock,x
	stz.w SPA,x
	lda.w position,x
	bne .t3x
	lda.w #SPAgready
	bra .15

.t3x:								; position,x != 0: falls through
	lda.w #SPAglide
.15:								; call SetSPAFromA, call updateanim
	jsl.l SetSPAFromA				; start sprite animation A on object X
	jsl.l updateanim				; step object X's sprite animation, looping or ending it
.16:								; increment a3, increment a3, d2 = pulled value, ...
	inc.b a3
	inc.b a3
	pla
	sta.b d2
	dec.b d2
	lda.b d2
	pha
	bmi .t1xx
	jmp.w .14

.t1xx:								; d2 = pulled value, call SprSort, a3 = pulled value, ...
	pla
	sta.b d2
	jsl.l SprSort					; SprSort
	pla
	sta.b a3
	pla
	sta.b a3+2
	lda.w penshot
	beq .6x
	ldx.w #$0008
.loopxx:							; loop: if padside,x != BA_Team go to .2xxxx, ...
	lda.w padside,x
	cmp.w BA_Team
	bne .2xxxx
	cpx.w pspad
	beq .2xxxx
.1xxxx:								; ora #$8000, padside,x = A, cont1team,x = 0
	ora.w #$8000
	sta.w padside,x
	stz.w cont1team,x
.2xxxx:								; X - 1, X - 1, if X still >= 0 go to .loopxx, ...
	dex
	dex
	bpl .loopxx
	lda.w BA_Team
	eor.w #$0002
	sta.b d0
	tax
	lda.w teampads,x
	beq .6x
	ldy.w puckpadnext,x
.loop2x:							; loop: Y + 1, Y + 1, if not zero go to .3xxx, ...
	iny
	iny
	cpy.w #$000A
	bne .3xxx
	ldy.w #$0000
.3xxx:								; if padside,y != d0 go to .loop2x, ...
	lda.w padside,y
	cmp.b d0
	bne .loop2x
	sty.b d1
	tya
	sta.w puckpadnext,x
	ldx.w #$0008
.loop3:								; loop: if padside,x != d0 go to .5x, ...
	lda.w padside,x
	cmp.b d0
	bne .5x
	cpx.b d1
	beq .5x
.4xx:								; ora #$8000, padside,x = A, cont1team,x = 0
	ora.w #$8000
	sta.w padside,x
	stz.w cont1team,x
.5x:								; X - 1, X - 1, if X still >= 0 go to .loop3
	dex
	dex
	bpl .loop3
.6x:								; call FaceoffPads, a1 = puckfaceoff2Pos, call print, ...
	ldx.b a3
	jsl.l FaceoffPads				; at a faceoff: CalcPuckDistances, restore the pad sides kept in padside
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #puckfaceoff2Pos>>16
	sta.b a1+2
	lda.w #puckfaceoff2Pos
	sta.b a1
	jsl.l print						; print puckfaceoff2Pos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0036
	sta.b d0
	lda.l fox
	bpl .7x
	lda.w #$00BE					; (18*8)+46
	sta.b d0
.7x:								; fodropx = d0, printx = d0 - $002E / 2 / 2 / 2, fodropy = $005C, ...
	lda.b d0
	sta.l fodropx
	sec
	sbc.w #$002E
	lsr a
	lsr a
	lsr a
	sta.w printx
	lda.w #$005C					; (3*8)+68
	sta.l fodropy
	lda.w #$0003
	sta.w printy
	lda.w printy					; box row offset
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	jsl.l marktextlo				; mark the box rows dirty
	lda.w printy
	clc
	adc.l FaceOffMap+2
	dec a
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	adc.l FaceOffMap
	dec a
	jsl.l marktexthi				; raise the high end of the changed text map area to A
	jsl.l SeatPenaltyBox			; puts the box players at their box spots
	lda.w #FaceOffMap+6
	sta.l fobox
	sta.b tmp0
	lda.w #$009A
	sta.b tmp1
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	tax
	ldy.w #$0000					; start of the map
	lda.l FaceOffMap+2
	sta.b tmp1+1
	clc
	lda.w penshot
	bne .t2xx
.loop4:								; loop: tmp2+1 = FaceOffMap
	lda.l FaceOffMap
	sta.b tmp2+1
.loop5:								; copy the faceoff map columns with the tile set added
	lda.b [tmp0],y
	clc
	adc.l faceoffvrcset
	adc.l charofs
	sta.l textmap,x
	iny
	iny
	inx
	inx
	dec.b tmp2+1
	bne .loop5
	txa								; next text row
	clc
	adc.w #$0040
	sec
	sbc.l FaceOffMap
	sbc.l FaceOffMap
	tax
	dec.b tmp1+1
	bne .loop4
	jmp.w .17

.t2xx:								; penshot != 0: printy = $0001, printx = $0006, d0 = $0014, ...
	lda.w #$0001
	sta.w printy
	lda.w #$0006
	sta.w printx
	lda.w #$0014
	sta.b d0
	lda.w #$0008
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	lda.w BA_Team
	sta.b a2
	lda.w #$0005
	sta.w printy
	lda.w BA_Skater_Offset
	sta.b d0
	jsl.l PlayerInitialName			; mesarea = the first initial
	lda.w #$0014
	sec
	sbc.b [a1]
	lsr a
	clc
	adc.w #$0007
	sta.w printx
	jsl.l print
	inc.w printy
	lda.w #$000F
	sta.w printx
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #VersusText>>16
	sta.b a1+2
	lda.w #VersusText
	sta.b a1
	jsl.l print						; print VersusText
	pla
	sta.b a1
	pla
	sta.b a1+2
	inc.w printy
	lda.w BA_Team
	eor.w #$0002
	sta.b a2
	tay
	lda.w tmgoalie,y
	sta.b d0
	jsl.l PlayerInitialName			; mesarea = the first initial
	lda.w #$0014
	sec
	sbc.b [a1]
	lsr a
	clc
	adc.w #$0007
	sta.w printx
	jsl.l print
	lda.w #$0007
	sta.w printx
	lda.w #$0002
	sta.w printy
	lda.w shootoutmode
	beq .t1xxx
	lda.w #ShootoutPenShot>>16
	sta.b a1+2
	lda.w #ShootoutPenShot
	sta.b a1
	jsl.l printbig					; printbig ShootoutPenShot
	bra .17

.t1xxx:								; shootoutmode = 0: a1 = ShootoutPenShot+10, call printbig
	lda.w #ShootoutPenShot>>16
	sta.b a1+2
	lda.w #ShootoutPenShot+10
	sta.b a1
	jsl.l printbig
.17:								; if OptLine = 0 go to .3xxxx
	ldx.b a3
	lda.l OptLine
	beq .3xxxx
.1xxxxx:							; ora penshotlive, if not zero go to .3xxxx, ...
	lda.w penshot
	ora.w penshotlive
	bne .3xxxx
	lda.w printy
	clc
	adc.w #$000A
	sta.w printy
	lda.w #$000C
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer					; d0/d1 size
	lda.w tmline					; line numbers of the two teams
	sta.b d0
	lda.w tmline+2
	sta.b d1
	lda.w gmode						; gmdir
	bit.w #gmdir
	bne .2xxxxx
	lda.w tmline					; swap the teams if the home team is below
	sta.b d1
	lda.w tmline+2
	sta.b d0
.2xxxxx:							; increment printx, decrement printy, decrement printy, ...
	inc.w printx
	dec.w printy
	dec.w printy
	lda.w #linelist>>16
	sta.b a1+2
	lda.w #linelist
	sta.b a1
	jsl.l PrintStringFromList		; prints a string from a list
	inc.w printx
	inc.w printx
	inc.w printx
	inc.w printx
	lda.b d1						; then the visitor line name
	sta.b d0
	lda.w #linelist>>16
	sta.b a1+2
	lda.w #linelist
	sta.b a1
	jsl.l PrintStringFromList		; prints a string from a list
.3xxxx:								; call RandomWord, and #$007F, adc #$00B4, ...
	jsl.l RandomWord
	and.w #$007F
	adc.w #$00B4
	sta.b d0
	ldx.b a3						; temp1 = frames to the drop
	sta.w temp1,x
	lda.w penshot
	beq .4xxx
	lda.w #$00B4
	sta.w temp1,x
.4xxx:								; fofdata2 = $0001, fofdata2+foattr = $8000, fofdata+foattr = $8000, ...
	lda.w #$0001
	sta.l fofdata2
	lda.w #$8000
	sta.l fofdata2+foattr
	sta.l fofdata+foattr
	lda.w #$0004
	sta.l fofdata2+fosize
	lda.w #$A800
	sta.l fofdata2+fosize+foattr
	lda.w #$0007
	sta.l fofdata
	lda.w gmode
	bit.w #gmdir					; gmdir: flip the attributes
	bne .5xx
	lda.w #$8800
	sta.l fofdata2+foattr
	lda.w #$A000
	sta.l fofdata2+fosize+foattr
.5xx:								; fodir1 = $FFFF, fodir2 = $FFFF, xsave = X, ...
	lda.w #$FFFF
	sta.l fodir1
	sta.l fodir2
	stx.b xsave						; keep X
	ldx.w #$001A
.loopxxx:							; pull a0 and the words after it back
	pla
	sta.b a0,x
	dex
	dex
	bpl .loopxxx
	ldx.b xsave						; restore X
	stx.b xsave						; keep X
	ldx.w #$001E
.loop2xx:							; pull d0 and the words after it back
	pla
	sta.b d0,x
	dex
	dex
	bpl .loop2xx
	ldx.b xsave						; restore X
	ldx.b a3
	rtl
.18:								; tmp0 = d7, if minus go to .1xxxxxx, ...
	lda.b d7						; temp1 -= min(d7, temp1)
	sta.b tmp0
	cmp.w temp1,x
	bmi .1xxxxxx
	lda.w #$0001
	sta.b tmp0
.1xxxxxx:							; temp1,x = temp1,x - tmp0, if plus go to updatefaceoff, ...
	lda.w temp1,x
	sec
	sbc.b tmp0
	sta.w temp1,x
	bpl updatefaceoff
	lda.w penshot
	beq .t1xxxx
	jsl.l Endfaceoff				; drop the puck: pick the face off winner and send the puck off
	jmp.w SetupPenaltyShot			; penalty shot set up: the puck at centre ice, every player reassigned

.t1xxxx:							; penshot = 0: PenShotActive = 0, BA_Sktr_SCnum = $FFFF, go to Endfaceoff
	stz.w PenShotActive
	lda.w #$FFFF
	sta.w BA_Sktr_SCnum
	jmp.w Endfaceoff				; drop the puck: pick the face off winner and send the puck off
.19:								; db $00,$01,$02,$03,$04,$05,$06,$00, db $00,$01,$05,$03,$04,$02,$00,$0...
	db $00,$01,$02,$03,$04,$05,$06,$00
	db $00,$01,$05,$03,$04,$02,$00,$00
	db $00,$03,$05,$01,$04,$00,$00,$00
.20:								; db $00,$04,$04,$04,$04,$04,$04,$00
	db $00,$04,$04,$04,$04,$04,$04,$00
.21:								; db $00,$00,$06,$FF,$DD,$FF,$CE,$FF,$23,$00,$CE,$FF,$CE,$FF,$F6,$FF, ...
	db $00,$00,$06,$FF,$DD,$FF,$CE,$FF,$23,$00,$CE,$FF,$CE,$FF,$F6,$FF
	db $00,$00,$F1,$FF,$32,$00,$F6,$FF,$00,$00,$C4,$FF
