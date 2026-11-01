; Save the registers and go on to StartHL2
SaveRegsStartHL2:					; called from DoHiLights
	stx.b xsave						; keep X
	ldx.w #$0000
.loop:								; loop: X + 1, X + 1, if not zero go to .loop, ...
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .loop
	ldx.b xsave						; restore X
	stx.b xsave						; keep X again
	ldx.w #$0000
.loop2:								; loop: X + 1, X + 1, if not zero go to .loop2, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .loop2
	ldx.b xsave						; restore X
StartHL2:							; entry point, no direct callers found
	lda.w sflags3
	bit.w #sf3sbut					;highlight running already?
	beq .t1
	jmp.w .15						;yes: skip the intro

.t1:								; sflags3 bits $0008 clear: call .18, d3 = d1, call NewTicker3, ...
	jsl.l .18						; save the game state
	lda.b d1						;button that ended the ticker
	sta.b d3
	jsl.l NewTicker3				;show the highlight ticker
	lda.w sflags3
	bit.w #sf3sbut					;set while it ran?
	beq .t3
	jmp.w .14						;yes: leave

.t3:								; sflags3 bits $0008 clear: printx = $0004, printy = $0014, d0 = $0018...
	lda.w #$0004					; Framer 24 x 3
	sta.w printx					;column 4
	lda.w #$0014
	sta.w printy					;row 20
	lda.w #$0018
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	inc.w printx
	dec.w printy
	dec.w printy
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #HighlightFrom>>16
	sta.b a1+2
	lda.w #HighlightFrom
	sta.b a1
	jsl.l print						; print HighlightFrom
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$00B4					;3 seconds
	sta.b d0
	jsl.l waitxsr					; wait d0 frames or until a button in d1 is pressed
	lda.b d3						;button pressed
	bit.w #$1000					;start?
	beq .t1x
	jmp.w .14						;yes: skip the highlight

.t1x:								; d3 bits $1000 clear: padchangeany = 0, call FadeOut, call WaitFadeOut...
	stz.w padchangeany
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jsl.l FadeOutSound				; start the sound fade out
	lda.w sndbank					;the sample set loaded in the SPC
	cmp.w #SoundBankGame
	beq .1							;already loaded
	jsl.l SPCGameUpload				; upload the Game sample set
.1:									; HomeTeam = gst1,x, VisTeam = gst2,x, call clearTeamStats, ...
	ldx.b a0						;saved game index
	lda.l gst1,x					;its home team
	sta.w HomeTeam
	lda.l gst2,x					;its visitors
	sta.w VisTeam
	lda.b a0						;keep a0
	pha
	lda.b a0+2
	pha
	jsl.l clearTeamStats			; clear the team stats and set up the teams
	jsl.l restoreteams				; all players of both teams on the bench
	lda.w #$0000
	sta.b a2
	jsl.l LoadTeamLines				; copy team a2's lines from the team data into RAM
	lda.w #$0002
	sta.b a2
	jsl.l LoadTeamLines				; copy team a2's lines from the team data into RAM
	stz.b a2
	jsl.l reenergizeteam			; give every player of team a2 full energy
	lda.w #$0002
	sta.b a2
	jsl.l reenergizeteam			; give every player of team a2 full energy
	jsl.l LoadCenterIce				;home team's centre ice logo
	ldx.w #$0008					;5 pads
	lda.w #$FFFF					;none
.loop:								; loop: c1playernum,x = A, padside,x = A, X - 1, ...
	sta.w c1playernum,x				;no player
	sta.w padside,x					;no side
	dex
	dex
	bpl .loop
	stz.w cont1team					;no controller teams
	stz.w cont2team
	stz.w cont3team
	stz.w cont4team
	stz.w cont5team
	lda.w #$0078					;random
	jsl.l randoma8					;0-119
	adc.w #$0078					;plus 120
	sta.w gameclock					;clock seconds left
	pla								;restore a0
	sta.b a0+2
	pla
	sta.b a0
	lda.b a0						;and keep it again
	pha
	lda.b a0+2
	pha
	ldx.b a0						;saved game
	lda.l gsper,x					;its period
	dec a							;from 0
	sta.w gsp
	lda.l gss1,x					;home score
	sta.w tmscore
	lda.l gss2,x					;visitors' score
	sta.w tmscore+2
	lda.w #$0010					;highlight mode
	sta.w gmode						;clock running
	stz.w gmclock
	lda.w gsp						; odd period: gmdir
	lsr a							;odd period?
	bcc .2							;no
	lda.w #$0002
	tsb.w gmode						;flip the ends
.2:									; sflags3 = 0, sflags = $0400, sfhormode = 0, ...
	stz.w sflags3
	lda.w #$0400					;faceoff stop flag only
	sta.w sflags
	stz.w sfhormode
	stz.w iflags					;no icing
	lda.w #$FFFF					; RefCnt, puckcross times -1
	sta.w RefCnt
	sta.w puckcross+pcframes
	sta.w puckcross+pcsize+pcframes
	jsl.l setupice_reset
	jsl.l ClrHor					; switch back from the horizontal rink to the vertical ice rink
	stz.w Vpos
	stz.w Hpos
	jsl.l ResetBench				; empty the penalty boxes and put every player on his own bench
	stz.b a2						;home team
	jsl.l .16						;on the ice
	lda.w #$0002
	sta.b a2						;visitors
	jsl.l .16						;on the ice
	jsl.l resetplstuff				; reset the players of both teams
	lda.w #$0000
	sta.l hattrick					;no hat trick
	lda.w #$000B					;12 objects
	sta.b d0
	lda.w #.20>>16					;start positions
	sta.b a0+2
	lda.w #.20
	sta.b a0
	stz.b a1
.loop2:								; loop: d1 = position,x, if pfgoal,x != 0 go to .3, ...
	ldx.b a1						;object
	lda.w position,x
	sta.b d1						;his position
	lda.w pfgoal,x					;attacking the top?
	bne .3							;yes: first half of the table
	lda.b d1
	clc
	adc.w #$0006					;bottom half: 6 later
	sta.b d1
.3:									; asl d1, asl d1, Xpos,x = [a0],y, ...
	asl.b d1						;4 bytes per entry
	asl.b d1
	ldy.b d1
	lda.b [a0],y					;x
	sta.w Xpos,x					;start x
	iny
	iny
	lda.b [a0],y					;y
	sta.w Ypos,x					;start y
	stz.w Xvel,x
	stz.w Yvel,x
	inc.b a1						;next object
	inc.b a1
	dec.b d0						;count
	bpl .loop2						;all objects
	lda.w puckc						;carrier given?
	bpl .4							;yes
	lda.w #$000C					;random skater
	jsl.l randomd0A					; A = a random number from 0 to A-1
	asl a							;word index
	sta.w puckc						;carrier
.4:									; if position,x != 0 go to .5, ...
	tax
	lda.w position,x				;carrier a goalie?
	bne .5							;no
	dex
	dex
	txa
	sta.w puckc						;carrier
.5:									; call SprSort, OldVcount = Vcount
	jsl.l SprSort					; sort the objects by screen position
org $9F9001
	lda.w #$00B4					;180 frames
	pha								;on the stack
	lda.b Vcount					;frame count
	sta.w OldVcount					;start time
.loop3:								; loop: if Vcount = OldVcount go to .loop3, ...
	lda.b Vcount					; the frame time steps as the game loop
	cmp.w OldVcount
	beq .loop3						;wait for the next frame
	tax
	sec
	sbc.w OldVcount					;minus the last
	sta.b d7						;frames gone
	sta.w timestep					;frame time
	asl a
	sta.w impactstep				;impact fade x2
	asl a
	asl a
	asl a
	sta.w velstep					;speed scale x16
	asl a
	sta.w gravstep					;gravity x32
	asl a
	adc.w gravstep					;plus: x96
	sta.w gravstep
	stx.w lastframevc				;last frame count
	stx.w OldVcount					;start of the next
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	lda.w sflags
	bit.w #$0001					;clock stopped?
	bne .7							;yes: no clock
	lda.w gmclock
	bne .7							;stopped?
	ldx.b d7						;frames
.loop4:								; loop: if gameclock = 0 go to .6, ...
	lda.w gameclock					; run the clock
	beq .6							;clock at 0
	lda.w gameclock+2
	sec
	sbc.w #$0AAA					;minus a frame's share
	sta.w gameclock+2
	bcs .6							;no borrow
	dec.w gameclock					;one second gone
.6:									; X - 1, if X not yet 0 go to .loop4
	dex
	bne .loop4
.7:									; call DoGameFrame, d7 = pulled value, timestep = pulled value, ...
	lda.b d7
	pha								;keep the frame time
	jsl.l DoGameFrame				;one game frame
	pla
	sta.b d7
	sta.w timestep					;restore the frame time
	lda.w gmclock					;stopped?
	beq .8							;no: keep running
	pla								;time left
	sec
	sbc.b d7						;minus the frame
	pha
	bmi .9							;out of time
.8:									; call ReadAnyPad, if d1 bits $9080 clear go to .loop3, ...
	jsl.l ReadAnyPad				; d1 = the buttons that changed on any pad
	lda.b d1
	bit.w #$9080					;start, A or B?
	beq .loop3						;no: next frame
	lda.w tmscore					; tied: random goal
	cmp.w tmscore+2					;tied?
	bne .9							;no
	jsl.l RandomWord				;random side
	and.w #$0002
	tax								;team index
	inc.w tmscore,x					;gets a goal
.9:									; a0+2 = pulled value, a0 = pulled value, call FadeOutSound, ...
	pla
	pla								;drop the frame counter
	sta.b a0+2						;restore a0
	pla
	sta.b a0
	jsl.l FadeOutSound				; start the sound fade out
	ldx.b a0						;saved game
	lda.w tmscore					;final score
	sta.l gss1,x					;home
	lda.w tmscore+2
	sta.l gss2,x					;visitors
	jsl.l SetupTeamForIntermission	; sets both teams up for a period
	ldx.w #$0000
.loop5:								; loop: Xpos,x = $FF10, Ypos,x = 0, frame,x = $0001, ...
	lda.w #$FF10					;off the screen
	sta.w Xpos,x
	stz.w Ypos,x
	lda.w #$0001
	sta.w frame,x					;frame 1
	inx
	inx
	cpx.w #$0018					;every player
	bcc .loop5
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jsl.l .19						;back to the saved game
	jsl.l setplayercolors			; set the team colours and send the whole palette to CGRAM
	jsl.l SetHor					; switches to the horizontal rink
	jsl.l SpriteFrameStart			;draw one frame
	jsl.l setvideo					; once per game frame: build the sprite table for the next vblank
	jsl.l SpriteFrameEnd
.loop6:								; loop: if SoundFadeSpeed != 0 go to .loop6, ...
	lda.w SoundFadeSpeed			;sound still fading?
	bne .loop6						;wait
	lda.w MusicOn					;music still on?
	bne .loop6						;wait
	jsl.l SPCMenuUpload				; upload the Menu sample set
	lda.l OptPlayMode				;play mode
	beq .t2							;exhibition: menu song
	cmp.w #$0004					;shootout?
	beq .t2							;yes: menu song
	lda.l playoffRoundIdx			;playoff round
	cmp.w #$0002					;before the finals?
	bcc .t2							;yes: menu song
	lda.w #PlayoffSong>>16			;playoff song
	sta.b p0+2
	lda.w #PlayoffSong
	sta.b p0
	jsl.l MusicStart				; start the song at [p0]: tempo from its second byte
	bra .10

.t2:								; p0 = MenuSong, call MusicStart
	lda.w #MenuSong>>16				;menu song
	sta.b p0+2
	lda.w #MenuSong
	sta.b p0
	jsl.l MusicStart				; start the song at [p0]: tempo from its second byte
.10:								; a1 = SaveRegsStartHL2Pos, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #SaveRegsStartHL2Pos>>16
	sta.b a1+2
	lda.w #SaveRegsStartHL2Pos
	sta.b a1
	jsl.l print						; print SaveRegsStartHL2Pos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0016
	sta.b d0						;22 wide
	lda.w #$0007
	sta.b d1						;7 high
	jsl.l Framer					; draw a frame and fill it
	jsl.l printscores1				; draw the scoreboard: the period and score boxes on the vertical rink
	jsl.l SetupPauseScreen			; draw the pause menu: five items of the current list from item psfirst
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	jsl.l ScreenOn					; DisplayStats
	stx.b xsave						; keep X
	ldx.w #$001A
.loopx:								;restore a0
	pla
	sta.b a0,x
	dex
	dex
	bpl .loopx
	ldx.b xsave						; restore X
	stx.b xsave						; keep X
	ldx.w #$001E
.loop2x:							; loop: d0,x = pulled value, X - 1, X - 1, ...
	pla								;restore d0
	sta.b d0,x
	dex
	dex
	bpl .loop2x
	ldx.b xsave						; restore X
	ldx.b a3						;current object
	stx.b xsave						; keep X
	ldx.w #$0000
.loop3x:							; loop: X + 1, X + 1, if not zero go to .loop3x, ...
	lda.b d0,x						;save d0 again
	pha
	inx
	inx
	cpx.w #$0020
	bne .loop3x
	ldx.b xsave						; restore X
	stx.b xsave						; keep X
	ldx.w #$0000
.loop4x:							; loop: X + 1, X + 1, if not zero go to .loop4x, ...
	lda.b a0,x						;save a0 again
	pha
	inx
	inx
	cpx.w #$001C
	bne .loop4x
	ldx.b xsave						; restore X
	ldx.b a0						;saved game
	lda.w #$0004					;period 4: overtime
	sta.l gsper,x
	lda.l gss1,x
	cmp.l gss2,x					;still tied?
	bne .t1xx						;no: final
	jmp.w StartHL2					;yes: play the overtime

.t1xx:								; gss1,x != gss2,x: gsper,x = $0005, d3 = d1, call NewTicker3, ...
	lda.w #$0005					;period 5: final
	sta.l gsper,x
	lda.b d1						;button that ended the ticker
	sta.b d3
	jsl.l NewTicker3				;final ticker
	lda.w #$00B4					;3 seconds
	sta.b d0
	jsl.l waitxsr					; wait d0 frames or until a button in d1 is pressed
	lda.b d1						;button
	bit.w #$1000					;start?
	beq .12							;no
.11:								;start: skip the rest
	lda.w #$0008					;skip flag
	tsb.w sflags3
	bra .13
.12:								;no skip
	lda.w #$0008					;clear the skip flag
	trb.w sflags3
.13:								; call LoadCenterIce, p0 = FaceOffTiles, p1+2 = $007F, ...
	jsl.l LoadCenterIce				; unpack the home team's centre ice logo to VRAM
	lda.w #FaceOffTiles>>16
	sta.b p0+2
	lda.w #FaceOffTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack FaceOffTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.l faceoffvrcset				;faceoff tile set
	asl a
	asl a
	asl a
	asl a							;x16
	adc.w #$1000					;plus BG chars
	tay								;VRAM address
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	stx.b xsave						; keep X
	ldx.w #$001A					;restore a0
.loopxx:							; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b a0,x
	dex
	dex
	bpl .loopxx
	ldx.b xsave						; restore X
	stx.b xsave						; keep X
	ldx.w #$001E					;restore d0
.loop2xx:							; loop: d0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b d0,x
	dex
	dex
	bpl .loop2xx
	ldx.b xsave						; restore X
	ldx.b a3						;current object
	rtl
.14:								;skipped: clear the box and finish
	lda.w #$0004
	sta.w printx					;column 4
	lda.w #$0014
	sta.w printy					;row 20
	lda.w #$0018
	sta.b d0						;24 wide
	lda.w #$0003
	sta.b d1						;3 high
	lda.l blankchar
	sta.b d2
	jsl.l eraser					;clear it
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l .19						;restore the game state
	jsl.l .17						;settle the score
	jmp.w .11						;skip flag on
.15:								;already skipping: settle the score
	jsl.l .17						;finish the game
	jmp.w .12
.16:								;put team a2 on the ice at full energy
	jsl.l reenergizeteam			; give every player of team a2 full energy
	jsl.l setpersonel				; put the wanted players of team a2 on the ice
	jsl.l forcepldata				; face offs: move team a2's players straight to their new positions
	ldy.b a2
	lda.w #$FFFF					;no touches
	sta.w tmtouch1,y
	sta.w tmtouch2,y
	sta.w tmtouch3,y
	rtl
.17:								;settle a tied saved game with a random winner
	ldx.b a0						;saved game
	lda.l gss1,x
	cmp.l gss2,x					;tied?
	bne .1x							;no
	jsl.l RandomWord				;random
	and.w #$0001					;0 or 1
	ldx.b a0
	pha
	clc
	adc.l gss1,x					;home +0 or 1
	sta.l gss1,x
	pla
	eor.w #$0001					;the other one
	adc.l gss2,x					;visitors +1 or 0
	sta.l gss2,x
.1x:								;final
	lda.w #$0005					;period 5
	sta.l gsper,x
	rtl
.18:								;save the game state to hlsavebuf
	ldx.w #$0000
.loopxxx:							; loop: hlsavebuf,x = OOlist+$10,x, X + 1, X + 1, ...
	lda.w OOlist+$10,x				;object table
	sta.l hlsavebuf,x				;into the save buffer
	inx
	inx
	cpx.w #$0781
	bcc .loopxxx					;all of it
	lda.l ScoreSumbytes				;score summary bytes
	sta.l hlsavebuf,x
	inx
	inx
	stz.w tmgoalie					;no goalies
	stz.w tmgoalie+2
	stz.w teampads					;no team pads
	stz.w teampads+2
	lda.w #$FFFF					;none
	ldx.w #$0000
.loop2xxx:							; loop: playerpad,x = A, X + 1, X + 1, ...
	sta.w playerpad,x				;no pad
	inx
	inx
	cpx.w #$0018					;all players
	bcc .loop2xxx
	jsl.l ClearPenaltyBuffer		;no penalties
	rtl
.19:								;restore the game state from hlsavebuf
	ldx.w #$0000
.loopxxxx:							; loop: OOlist+$10,x = hlsavebuf,x, X + 1, X + 1, ...
	lda.l hlsavebuf,x				;save buffer
	sta.w OOlist+$10,x				;object table
	inx
	inx
	cpx.w #$0781
	bcc .loopxxxx
	lda.l hlsavebuf,x				;score summary bytes
	inx
	inx
	sta.l ScoreSumbytes
	rtl
.20:								;x, y start spots by position: bottom half, then top half
	dw 0,-240,-70,-140,20,-110,-100,-60,25,-40,70,-80
	dw 0,240,34,90,-55,80,100,40,-10,10,-50,0
