; Assignment: the face off and the setup for play
puckfaceoff2:						; called from asstab
	lda.w pflags,x					; new assignment?
	bit.w #pfna
	bne .t2							;yes: set up the face off
	jmp.w .18						;no: run it

.t2:								; pflags,x bit pfna set: and #$FFFD, pflags,x = A, xsave = X, ...
	and.w #$FFFD					;clear the new flag
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
	sta.b SfxVelocity				;sound volume
	lda.w #$0012
	jsl.l QueueSound				;whistle
	lda.w #$0013
	jsl.l QueueSound				;and the second whistle voice
	lda.w #$FFFF					;no recorded sounds
	sta.w recsfx
	sta.w recsfx2
	lda.w #$0000
	sta.l hattrick					;hat trick message off
	lda.l Crowdlevel
	cmp.w #$0258					;crowd above $258?
	bcc .1
	lda.w #$0258					;cap the crowd at $258
	sta.l Crowdlevel
.1:									; if brightness = 0 go to .2, ...
	lda.w brightness				;screen faded?
	beq .2							;no
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
	stz.w brightness				;full dark
.2:									; call FadeIn, fadestep = $000A, if MusicOn != 0 go to .4, ...
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	lda.w #$000A
	sta.w fadestep					;fade speed 10
	lda.w MusicOn
	bne .4							;music already on: skip the song
	lda.w PBnum						;score digits
	beq .t3							;no score: random song
	lsr a
	lsr a
	lsr a
	lsr a							;high nibble: one team's goals
	sta.b r3						;keep it
	lda.w PBnum
	and.w #$000F					;low nibble: the other's
	cmp.b r3						;tied?
	beq .t3
	bcs .t1							;behind: song 1
.3:									; call PlayTeamSong, go to .4
	lda.w #$0004					;ahead: song 4
	jsl.l PlayTeamSong				; play song slot A of the home team
	bra .4

.t1:								; call PlayTeamSong, go to .4
	lda.w #$0001
	jsl.l PlayTeamSong				; play song slot A of the home team
	bra .4

.t3:								;period start cue?
	ldy.w percue
	bne .1x							;yes: play song 2
	lda.l OptPlayMode
	cmp.w #$0004					;shootout?
	beq .4							;yes: no song
	jsl.l RandomWord
	and.w #$0003					;one in 4
	bne .4							;others: no song
.1x:								; if percue != 0 go to .3x
	lda.w #$0000					;song 0 for a period start
	ldy.w percue
	bne .3x							;period start
.2x:								; falls through
	lda.w #$0002					;song 2
.3x:								; call PlayTeamSong, percue = 0
	jsl.l PlayTeamSong				; play song slot A of the home team
	stz.w percue					;cue used
.4:									; trb sflags, trb sflags3, iflags = 0, ...
	lda.w #sfpz|sfspdir|sfssdir
	trb.w sflags					;clear the stop flags
	lda.w #sf3llcs
	trb.w sflags3					;clear the play-stopped bit
	stz.w iflags					; no icing, no lower lc box, glove spots cleared
	stz.w replaydelay				;no replay delay
	lda.w #$FFFF					; -1 marks the ref count, crossings, puck carrier and receiver as none
	sta.w RefCnt
	sta.w puckcross+pcframes
	sta.w puckcross+pcsize+pcframes
	sta.w puckz
	sta.w passReceiverPlayerNum
	asl a							;$FFFE
	sta.w puckc						;no puck carrier
	lda.w #sf2refref|sf2offsig
	trb.w sflags					;clear the goal and offside flags
	lda.w #$0000
	sta.l refwindow					;no ref window
	sta.l penmsgbox					;no penalty message
	lda.w #sf2faceoff|sf2drec
	tsb.w sflags					;set the faceoff and stopped flags
	jsl.l ClrHor					; back to the vertical rink
	stz.w Vpos						; Vpos = Hpos = 0
	stz.w Hpos
	lda.l fox
	sta.w puckx						;puck at the faceoff spot
	lda.l foy
	sta.w pucky
	stz.w puckvx					;puck still
	stz.w puckvy
	stz.w puckvz
	stz.w Xvel+netobj1				; goal nets (objects 12/13) at y +-268
	stz.w Yvel+netobj1
	stz.w Xpos+netobj1
	lda.w #$010C
	sta.w Ypos+netobj1				;net 1 y +268
	stz.w Xvel+netobj2				; goal net 2 at y -268
	stz.w Yvel+netobj2
	stz.w Xpos+netobj2
	lda.w #$FEF4
	sta.w Ypos+netobj2				;net 2 y -268
	lda.w #SPFpuck					; object 15 (puck shadow) = SPFpuck
	sta.w frame+puckscnum+2
	stz.w SPA+puckscnum+2			;shadow animation 0
	stz.w attribute+puckscnum+2
	stz.w attribute+puckscnum		;puck attributes clear
	lda.w #sfslock
	trb.w sflags					;clear the scroll lock flag
	lda.w #$0064					; 100 scroll steps
	sta.b d4
.loopx:								;scroll to the faceoff spot
	jsl.l checkwindow				; move the view so the screen follows the puck
	dec.b d4						;one step
	bpl .loopx						;until the view is there
	lda.w #$003C					; yleader = 60
	sta.w yleader
	jsl.l ResetBench				; ResetBench
	stz.b a2						;home team
	jsl.l setpersonel				; update the players on the ice
	jsl.l forcepldata				; face offs: move team a2's players straight to their new positions
	inc.b a2						;visitors
	inc.b a2
	jsl.l setpersonel				; update the players on the ice
	jsl.l forcepldata				; face offs: move team a2's players straight to their new positions
	jsl.l resetplstuff				; resetplstuff
	lda.w #$FFFF					;no touches
	sta.w tmtouch2
	sta.w tmtouch3
	sta.w tmtouch2+2
	sta.w tmtouch3+2
	lda.b a3+2						;push a3
	pha
	lda.b a3
	pha
	stz.b a3						;from object 0
	lda.w #$000B					; 12 objects
	sta.b d2						;d2 = 11
	lda.b d2
	pha
.14:								; if a3 >= $0018 go to .1xx, ...
	ldx.b a3
	cpx.w #$0018					;a player?
	bcs .1xx						;no: skip the goal side
	lda.w pfteam,x					;his team
	lsr a
	eor.w gmode						;switches with the period
	and.w #$0002
	lsr a							;which goal he attacks
	eor.w #$0001
	sta.w pfgoal,x					;0 or 1
.1xx:								; if carry clear go to .2xx, ...
	lda.w pnum,x					;his roster number
	asl a							;word index
	cpx.w #$000C					;visitors?
	bcc .2xx
	clc
	adc.w #$0034					;skip $34 bytes
.2xx:								; if tmpdst,x negative go to .t2x, ...
	tax
	lda.w tmpdst,x					;roster flags
	bmi .t2x						;not dressed: off the ice
	bit.w #TMPDINJ					;injured / penalised?
	bne .t2x						;yes: off the ice
	jmp.w .16						;no: next object

.t2x:								;each player: assignment and faceoff position
	ldx.b a3						;this object
	lda.w #$FF10					; Xpos = -240, off the screen
	sta.w Xpos,x					;put him off the screen
	stz.w Ypos,x
	lda.w #$0001					;frame 1
	sta.w frame,x
	lda.w position,x				;his position
	sta.b d1						; d1 = position
	bpl .t1x						;on the ice
	jmp.w .16						;none: next object

.t1x:								; if zero go to .5, ...
	beq .5							;goalie: no faceoff assignment
	lda.w penshot					;penalty shot?
	beq .2xxx						;no
	phx
	ldx.w #$0008					;home shooter slot
	lda.w BA_Team					;shooter's team
	beq .1xxx
	ldx.w #$0014					;visitors' shooter slot
.1xxx:								; pnum,x = BA_Skater_Offset, d3 = BA_Skater_Offset
	lda.w BA_Skater_Offset			;the shooter
	sta.w pnum,x
	sta.b d3						;d3 = shooter
	plx
.2xxx:								; d0 = $0016, if d1 != $0004 go to .4x, ...
	lda.w #$0016					;assignment $16: wait for the drop
	sta.b d0
	lda.b d1						; centers take the faceoff
	cmp.w #$0004
	bne .4x							;not the center
	stz.b a2						; center: team touches = him only
	lda.w pfteam,x
	beq .3xx						;home?
	inc.b a2
	inc.b a2						;visitors
.3xx:								; tmtouch1,y = pnum,x & $00FF, tmflags,y = $0004, d0 = $0017
	ldy.b a2
	lda.w pnum,x
	and.w #$00FF					;roster number
	sta.w tmtouch1,y				;only he has touched
	lda.w #$0004
	sta.w tmflags,y					;faceoff flag
	lda.w #$0017					;assignment $17: take the faceoff
	sta.b d0
.4x:								; call assinsert
	jsl.l assinsert					;insert it
.5:									; d4 = tmap, if pfteam,x = 0 go to .6, ...
	lda.w tmap						;home formation
	sta.b d4
	ldx.b a3
	lda.w pfteam,x					;team
	beq .6							;home
	lda.w tmap+2					;visitors' formation
	sta.b d4
.6:									; d4 = -(d4) + $0006 * 2 * 2 * 2, a1 = long .19 + d4, ...
	lda.b d4
	eor.w #$FFFF					; negate
	inc a							;negate
	clc
	adc.w #$0006					;6 - formation
	asl a
	asl a
	asl a
	sta.b d4						;8 bytes per row
	lda.w #.19>>16
	sta.b a1+2
	lda.w #.19
	clc
	adc.b d4
	sta.b a1						;formation row
	lda.w penshot					;penalty shot?
	beq .7							;no
	lda.w #.20>>16					;penalty shot table
	sta.b a1+2
	lda.w #.20
	sta.b a1
.7:									; d4 = [a1],y & $00FF * 2 * 2, a1 = long .21, ...
	ldy.b d1						;position
	lda.b [a1],y					; table entry for the position
	and.w #$00FF					;byte
	asl a							; entry to a .ptab offset
	asl a
	sta.b d4						;4 bytes per offset entry
	lda.w #.21>>16					;offset table
	sta.b a1+2
	lda.w #.21
	sta.b a1
	ldy.b d4
	lda.b [a1],y					;x offset
	sta.b d0
	iny
	iny
	lda.b [a1],y					;y offset
	sta.b d1						;d1 = y
	lda.w pfgoal,x					; mirror for the top goal
	bne .8							;attacking the top: as is
	lda.w #$0000
	sec
	sbc.b d0						;negate x
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1						;negate y
	sta.b d1
.8:									; if position,x = 0 go to .13, ...
	lda.w position,x				;goalie?
	beq .13							;yes: no shift
	lda.b d4						; defense (entry <= 2*4): shift by fox/foy
	cmp.w #$0009					;defense entry?
	bpl .12							;no: no shift
	lda.l fox						;faceoff x
	eor.b d0						;same side as the offset?
	bpl .10							;yes: no y shift
	lda.l foy						;faceoff y
	lsr a
	lsr a
	lsr a							;/8
	bit.w #$1000					;sign bit?
	beq .9
	ora.w #$E000					;sign extend
.9:									; eor #$FFFF, increment a, adc d1, ...
	eor.w #$FFFF					; negate
	inc a
	clc
	adc.b d1						;plus the y offset
	sta.b d1						;shifted y
.10:								; if zero go to .11, ...
	lda.l fox
	lsr a							;x / 4
	lsr a
	bit.w #$2000					;sign bit?
	beq .11
	ora.w #$C000					;sign extend
.11:								; d3 = A, d0 = d0 - d3
	sta.b d3						;shift
	lda.b d0
	sec
	sbc.b d3						;minus shift
	sta.b d0						;shifted x
.12:								; d0 = d0 + fox, d1 = d1 + foy
	lda.b d0						; add the faceoff spot
	clc
	adc.l fox
	sta.b d0
	lda.b d1
	clc
	adc.l foy						;plus the faceoff y
	sta.b d1						;final y
.13:								; Xpos,x = d0, d0 = -(d0 - puckx), Ypos,x = d1, ...
	lda.b d0						; store X
	sta.w Xpos,x
	sec
	sbc.w puckx						;minus the puck x
	eor.w #$FFFF					; negate
	inc a
	sta.b d0						;d0 = dx to the puck
	lda.b d1						; store Y
	sta.w Ypos,x
	sec
	sbc.w pucky						;minus the puck y
	eor.w #$FFFF					; negate
	inc a
	sta.b d1						;d1 = dy to the puck
	stz.w Xvel,x					; stand still
	stz.w Yvel,x
	jsl.l vtoa						; face the puck
	lda.b d0
	sta.w facedir,x					;facing
	lda.w pflags,x
	and.w #(~pf2unav&$FFFF)			;clear the unavailable flag
	sta.w pflags,x
	stz.w pfalock,x					;animation unlocked
	stz.w SPA,x
	lda.w position,x				;goalie?
	bne .t3x						;no: skater
	lda.w #SPAgready				;goalie ready stance
	bra .15

.t3x:								; position,x != 0: falls through
	lda.w #SPAglide					;skater glide
.15:								; call SetSPAFromA, call updateanim
	jsl.l SetSPAFromA				; start sprite animation A on object X
	jsl.l updateanim				; step object X's sprite animation, looping or ending it
.16:								; increment a3, increment a3, d2 = pulled value, ...
	inc.b a3
	inc.b a3
	pla
	sta.b d2
	dec.b d2						;one object done
	lda.b d2
	pha
	bmi .t1xx						;all done
	jmp.w .14						;next object

.t1xx:								; d2 = pulled value, call SprSort, a3 = pulled value, ...
	pla
	sta.b d2
	jsl.l SprSort					;sort the sprites
	pla
	sta.b a3						;restore a3
	pla
	sta.b a3+2
	lda.w penshot					;penalty shot?
	beq .6x							;no
	ldx.w #$0008					;last pad
.loopxx:							; loop: if padside,x != BA_Team go to .2xxxx, ...
	lda.w padside,x					;pad on the shooter's team?
	cmp.w BA_Team
	bne .2xxxx						;no
	cpx.w pspad						;the shooter's pad?
	beq .2xxxx						;keep it
.1xxxx:								; ora #$8000, padside,x = A, cont1team,x = 0
	ora.w #$8000					;turn it off
	sta.w padside,x
	stz.w cont1team,x				;no control
.2xxxx:								; X - 1, X - 1, if X still >= 0 go to .loopxx, ...
	dex
	dex
	bpl .loopxx
	lda.w BA_Team					;the goalie's team
	eor.w #$0002					;other team
	sta.b d0
	tax
	lda.w teampads,x
	beq .6x							;no pads: done
	ldy.w puckpadnext,x				;pad after the last puck pad
.loop2x:							; loop: Y + 1, Y + 1, if not zero go to .3xxx, ...
	iny
	iny
	cpy.w #$000A					;past the last pad?
	bne .3xxx
	ldy.w #$0000					;wrap
.3xxx:								; if padside,y != d0 go to .loop2x, ...
	lda.w padside,y					;pad of the goalie's team?
	cmp.b d0
	bne .loop2x						;no: try the next
	sty.b d1						;the goalie's pad
	tya
	sta.w puckpadnext,x				;used next time
	ldx.w #$0008					;last pad
.loop3:								; loop: if padside,x != d0 go to .5x, ...
	lda.w padside,x					;other pads of that team
	cmp.b d0
	bne .5x
	cpx.b d1						;the goalie's pad?
	beq .5x							;keep it
.4xx:								; ora #$8000, padside,x = A, cont1team,x = 0
	ora.w #$8000
	sta.w padside,x					;turn it off
	stz.w cont1team,x				;no control
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
	lda.w #$0036					;right of centre: drop box x $36
	sta.b d0
	lda.l fox						;faceoff left?
	bpl .7x
	lda.w #$00BE					;right: x $BE
	sta.b d0
.7x:								; fodropx = d0, printx = d0 - $002E / 2 / 2 / 2, fodropy = $005C, ...
	lda.b d0
	sta.l fodropx					;drop x
	sec
	sbc.w #$002E					;minus 46
	lsr a
	lsr a
	lsr a							;/8
	sta.w printx					;box column
	lda.w #$005C					; (3*8)+68
	sta.l fodropy					;drop y
	lda.w #$0003
	sta.w printy					;box row 3
	lda.w printy					; box row offset
	asl a							;row x 32
	asl a
	asl a
	asl a
	asl a
	adc.w printx					;plus the column
	jsl.l marktextlo				;start of the dirty rows
	lda.w printy
	clc
	adc.l FaceOffMap+2				;minus 1
	dec a
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx					;plus the column
	adc.l FaceOffMap				;plus the box width
	dec a							;minus 1
	jsl.l marktexthi				;end of the dirty rows
	jsl.l SeatPenaltyBox			; puts the box players at their box spots
	lda.w #FaceOffMap+6
	sta.l fobox						;faceoff box map
	sta.b tmp0
	lda.w #$009A					;bank $9A
	sta.b tmp1
	lda.w printy
	asl a							;row x 32
	asl a
	asl a
	asl a
	asl a
	adc.w printx					;plus the column
	asl a							;word index
	tax								;into the text map
	ldy.w #$0000					; start of the map
	lda.l FaceOffMap+2
	sta.b tmp1+1					;rows
	clc
	lda.w penshot
	bne .t2xx						;penalty shot box instead
.loop4:								; loop: tmp2+1 = FaceOffMap
	lda.l FaceOffMap
	sta.b tmp2+1					;columns
.loop5:								; copy the faceoff map columns with the tile set added
	lda.b [tmp0],y
	clc
	adc.l faceoffvrcset				;plus the faceoff tile base
	adc.l charofs					;plus the text set
	sta.l textmap,x					;into the text map
	iny
	iny
	inx
	inx
	dec.b tmp2+1					;one column
	bne .loop5						;next column
	txa								; next text row
	clc
	adc.w #$0040					;next row
	sec
	sbc.l FaceOffMap
	sbc.l FaceOffMap				;minus the box width twice
	tax								;back to the left edge
	dec.b tmp1+1					;one row
	bne .loop4						;next row
	jmp.w .17						;done

.t2xx:								; penshot != 0: printy = $0001, printx = $0006, d0 = $0014, ...
	lda.w #$0001
	sta.w printy					;row 1
	lda.w #$0006
	sta.w printx					;column 6
	lda.w #$0014
	sta.b d0						;20 wide
	lda.w #$0008
	sta.b d1						;8 high
	jsl.l Framer					;draw the frame
	lda.w BA_Team
	sta.b a2						;shooter's team
	lda.w #$0005
	sta.w printy					;row 5
	lda.w BA_Skater_Offset
	sta.b d0						;the shooter
	jsl.l PlayerInitialName			; mesarea = the first initial
	lda.w #$0014
	sec
	sbc.b [a1]						;minus the name length
	lsr a							;centred
	clc
	adc.w #$0007					;plus the left edge
	sta.w printx
	jsl.l print						;print the shooter
	inc.w printy					;next row
	lda.w #$000F					;column 15
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
	inc.w printy					;next row
	lda.w BA_Team
	eor.w #$0002					;other team
	sta.b a2
	tay								;team index
	lda.w tmgoalie,y				;their goalie
	sta.b d0
	jsl.l PlayerInitialName			;his initial and name
	lda.w #$0014
	sec
	sbc.b [a1]						;minus the name length
	lsr a							;centred
	clc
	adc.w #$0007					;plus the left edge
	sta.w printx
	jsl.l print						;print the goalie
	lda.w #$0007
	sta.w printx					;column 7
	lda.w #$0002
	sta.w printy					;row 2
	lda.w shootoutmode				;shootout?
	beq .t1xxx						;no: penalty shot title
	lda.w #ShootoutPenShot>>16
	sta.b a1+2
	lda.w #ShootoutPenShot
	sta.b a1
	jsl.l printbig					;SHOOTOUT
	bra .17

.t1xxx:								; shootoutmode = 0: a1 = ShootoutPenShot+10, call printbig
	lda.w #ShootoutPenShot>>16		;PENALTY SHOT
	sta.b a1+2
	lda.w #ShootoutPenShot+10		;second text
	sta.b a1
	jsl.l printbig
.17:								; if OptLine = 0 go to .3xxxx
	ldx.b a3
	lda.l OptLine
	beq .3xxxx						;line names off
.1xxxxx:							; ora penshotlive, if not zero go to .3xxxx, ...
	lda.w penshot
	ora.w penshotlive
	bne .3xxxx						;penalty shot: no lines
	lda.w printy
	clc
	adc.w #$000A					;10 rows lower
	sta.w printy
	lda.w #$000C
	sta.b d0						;12 wide
	lda.w #$0003
	sta.b d1						;3 high
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
	jsl.l Fprint					;first line name
	inc.w printx
	inc.w printx					;next column
	inc.w printx
	inc.w printx
	lda.b d1						;then the second team's line
	sta.b d0
	lda.w #linelist>>16
	sta.b a1+2
	lda.w #linelist
	sta.b a1
	jsl.l Fprint					; prints a string from a list
.3xxxx:								; call RandomWord, and #$007F, adc #$00B4, ...
	jsl.l RandomWord				;random
	and.w #$007F					;0-127
	adc.w #$00B4					;plus 180
	sta.b d0
	ldx.b a3						; temp1 = frames to the drop
	sta.w temp1,x					;frames to the drop
	lda.w penshot					;penalty shot?
	beq .4xxx						;no
	lda.w #$00B4					;exactly 180
	sta.w temp1,x
.4xxx:								; fofdata2 = $0001, fofdata2+foattr = $8000, fofdata+foattr = $8000, ...
	lda.w #$0001
	sta.l fofdata2					;visitors' dot frame
	lda.w #$8000					;priority
	sta.l fofdata2+foattr
	sta.l fofdata+foattr
	lda.w #$0004
	sta.l fofdata2+fosize			;home dot frame
	lda.w #$A800					;priority, palette 4
	sta.l fofdata2+fosize+foattr
	lda.w #$0007
	sta.l fofdata					;puck frame 7
	lda.w gmode
	bit.w #gmdir					; gmdir: flip the attributes
	bne .5xx						;flipped: keep
	lda.w #$8800					;unflipped attributes
	sta.l fofdata2+foattr
	lda.w #$A000
	sta.l fofdata2+fosize+foattr
.5xx:								; fodir1 = $FFFF, fodir2 = $FFFF, xsave = X, ...
	lda.w #$FFFF					;no faceoff direction yet
	sta.l fodir1
	sta.l fodir2
	stx.b xsave						; keep X
	ldx.w #$001A					;14 words
.loopxxx:							; pull a0 and the words after it back
	pla
	sta.b a0,x
	dex
	dex
	bpl .loopxxx
	ldx.b xsave						; restore X
	stx.b xsave						; keep X
	ldx.w #$001E					;16 words
.loop2xx:							; pull d0 and the words after it back
	pla
	sta.b d0,x
	dex
	dex
	bpl .loop2xx
	ldx.b xsave						; restore X
	ldx.b a3						;this player
	rtl
.18:								; tmp0 = d7, if minus go to .1xxxxxx, ...
	lda.b d7						; temp1 -= min(d7, temp1)
	sta.b tmp0						;step
	cmp.w temp1,x					;more than the time left?
	bmi .1xxxxxx					;no
	lda.w #$0001					;else one
	sta.b tmp0
.1xxxxxx:							; temp1,x = temp1,x - tmp0, if plus go to updatefaceoff, ...
	lda.w temp1,x
	sec
	sbc.b tmp0						;minus the step
	sta.w temp1,x
	bpl updatefaceoff				;not yet: keep waiting
	lda.w penshot					;penalty shot?
	beq .t1xxxx						;no
	jsl.l Endfaceoff				; drop the puck: pick the face off winner and send the puck off
	jmp.w SetupPenaltyShot			; penalty shot set up: the puck at centre ice, every player reassigned

.t1xxxx:							; penshot = 0: PenShotActive = 0, BA_Sktr_SCnum = $FFFF, go to Endfaceoff
	stz.w PenShotActive				;no penalty shot running
	lda.w #$FFFF
	sta.w BA_Sktr_SCnum				;no shooter
	jmp.w Endfaceoff				; drop the puck: pick the face off winner and send the puck off
.19:								;position -> offset entry, by formation (tmap 6, 5, 4)
	db $00,$01,$02,$03,$04,$05,$06,$00
	db $00,$01,$05,$03,$04,$02,$00,$00
	db $00,$03,$05,$01,$04,$00,$00,$00
.20:								;penalty shot: everyone at entry 4
	db $00,$04,$04,$04,$04,$04,$04,$00
.21:								;x, y offset pairs of the faceoff spots
	db $00,$00,$06,$FF,$DD,$FF,$CE,$FF,$23,$00,$CE,$FF,$CE,$FF,$F6,$FF
	db $00,$00,$F1,$FF,$32,$00,$F6,$FF,$00,$00,$C4,$FF
