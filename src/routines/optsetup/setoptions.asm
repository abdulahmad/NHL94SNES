; The game setup screen: up and down pick a line, left and right change it, Start goes on
setoptions:							; called from Restart
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	lda.w #$0001
	sta.l matchupphotos
	lda.w #$0000
	sta.l playerstatson
	lda.w #$FFFF
	sta.l phototeams
	sta.l phototeams+2
	lda.w #$0001
	sta.l redrawblocks
	sta.l cardtimer
	sta.l teamschanged
	lda.w #$0005
	sta.l setupmatchup
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jsl.l ClearTextMap				; fill the text map with the blank tile
	jsl.l InitSetupChars			; set the tile numbers and load the font of the setup screen
	lda.l OptTeam1
	sta.w HomeTeam
	lda.l OptTeam2
	sta.w VisTeam
	jsl.l setteams					; set up both team structures from the home and visiting teams
	lda.w VisTeam
	clc
	adc.w #$0021
	sta.l setupvis
	lda.w HomeTeam
	sta.l setuphome
	jsl.l SetupScreen				; common setup of the stats screens
	sep #$20
	lda.b #$01
	sta.w BGMODE
	rep #$20
	ldx.w #$004F
	ldy.w #$0018
	lda.w #GameSetupTitle>>16
	sta.b a1+2
	lda.w #GameSetupTitle
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites GameSetupTitle
	lda.w #$1D47
	sta.l colourbuf+$A
	lda.w #$FFFF
	sta.l colourbuf+$E
	lda.w #$14A5
	sta.l colourbuf+$182
	lda.w #$6F7B
	sta.l colourbuf+$C2
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	jsl.l SpriteFrameEnd
	jsl.l SendTextMap
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l ReadAnyPad				; d1 = the buttons that changed on any pad
	lda.w #$0000
	sta.w sprpriority
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #setoptionsPos>>16
	sta.b a1+2
	lda.w #setoptionsPos
	sta.b a1
	jsl.l print						; print setoptionsPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l InitSortObjects
	lda.w #$0028
	sta.w rosxoff
	sta.w rosxoff+(6*2)
	lda.w #$FFFF
	sta.l notdemo
	lda.b a2
	pha
	lda.w #$0000
	sta.b a2
	jsl.l LoadTeamLines				; copy team a2's lines from the team data into RAM
	lda.w #$0002
	sta.b a2
	jsl.l LoadTeamLines				; copy team a2's lines from the team data into RAM
	pla
	sta.b a2
	stz.b d7
	stz.b d0
	jsr.w .12
	jsr.w .10
	jsr.w .11
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l MenuScreenHDMA			; start the window and COLDATA HDMA
	jsl.l ScreenOn
	lda.w #$0008
	ldx.w #$0040
	jsl.l SetupBandIRQ				; set up the band IRQ pair
	jsl.l SendTextMap
	ldx.w #$0000
	jsl.l LoadMatchupPhotos			; unpack the matchup player photos of team x
	ldx.w #$0002
	jsl.l LoadMatchupPhotos			; unpack the matchup player photos of team x
.3:									; d6 = $12C0
	lda.w #$12C0
	sta.b d6
.2:									; loop: call WaitFrame, if OAMReady != 0 go to .2, ...
	jsl.l WaitFrame
	lda.w OAMReady
	bne .2
	inc.w seed
	bne .1
	inc.w seed+2
.1:									; call WaitFrame, eor d2+2, if not zero go to .t5, ...
	jsl.l WaitFrame
	ldx.w mp5warning
	txa
	eor.b d2+2
	bne .t5
	jmp.w .t6

.t5:								; d2+2 = X, if zero go to .t4, ...
	stx.b d2+2
	txa
	beq .t4
	bit.w #$0001
	bne .t1
	bit.w #$0002
	bne .t2
	bit.w #$0004
	bne .t3
	bra .t6

.t1:								; call ClearMessageArea, call Multi5SocketMsg, go to .t6
	jsl.l ClearMessageArea			; clear the message rows
	jsl.l Multi5SocketMsg			; print the MultiPlayer 5 socket warning
	bra .t6

.t2:								; call ClearMessageArea, call Multi5ScopeMsg, go to .t6
	jsl.l ClearMessageArea			; clear the message rows
	jsl.l Multi5ScopeMsg			; print the MultiPlayer 5 Super Scope warning
	bra .t6

.t3:								; call ClearMessageArea, call Multi5MouseMsg, go to .t6
	jsl.l ClearMessageArea			; clear the message rows
	jsl.l Multi5MouseMsg			; print the MultiPlayer 5 mouse warning
	bra .t6

.t4:								; call Multi5Init, call ClearTextMapBottom, call .10, ...
	jsl.l Multi5Init				; check for the multitap, then clear the multitap pads and state
	jsl.l ClearTextMapBottom		; fill the text map from row 12 down with the blank tile
	jsr.w .10
	stz.b d1
	jmp.w .6

.t6:								; if mp5warning = 0 go to .t1x, ...
	lda.w mp5warning
	beq .t1x
	jmp.w .2

.t1x:								; mp5warning = 0: call ReadPads, lastframevc = vcount, oldvcount = vcou...
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	lda.b vcount
	sta.w lastframevc
	sta.w oldvcount
	jsl.l ReadJoy1					; read pad 1: d0 = direction, d1 = new presses, d2 = changed buttons
	dec.w repeatdelay
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
	lda.b d1
	and.w #$FFF0
	sta.b d1
	beq .t2x
	jmp.w .6

.t2x:								; call .11, call QueueTextDMA, decrement d6, ...
	jsr.w .11
	jsl.l QueueTextDMA				; queue the changed part of the text map for transfer to video memory
	dec.b d6
	dec.b d6
	bmi .t1xx
	jmp.w .2

.t1xx:								; d6 counted below 0: call randoma8, OptTeam1 = A, HomeTeam = A
	lda.w #$001C
	jsl.l randoma8					; random number below A
	sta.l OptTeam1
	sta.w HomeTeam
.loop:								; loop: call randoma8, if zero go to .loop, ...
	lda.w #$001C
	jsl.l randoma8					; random number below A
	cmp.l OptTeam1
	beq .loop
	sta.l OptTeam2
	sta.w VisTeam
	lda.w #$0000
	sta.l notdemo
	lda.w #$0000
	sta.l OptPlayMode
	sta.l OptPlayers
.5:									; p0 = BigLetterTiles, p1 = bigtextbuf, call Decompress, ...
	lda.w #BigLetterTiles>>16
	sta.b p0+2
	lda.w #BigLetterTiles
	sta.b p0
	lda.w #bigtextbuf>>16
	sta.b p1+2
	lda.w #bigtextbuf
	sta.b p1
	jsl.l Decompress				; unpack BigLetterTiles
	lda.w #bigtextbuf>>16
	sta.b p0+2
	lda.w #bigtextbuf
	sta.b p0
	lda.w #hlsavebuf>>16
	sta.b p1+2
	lda.w #hlsavebuf
	sta.b p1
	stx.b r0
	jsl.l LinearToPlanar
	lda.w #$0000
	sta.l matchupphotos
	lda.l OptPlayMode
	cmp.w #$0002
	beq .1x
	cmp.w #$0003
	bne .2x
.1x:								; call NewPO
	jsl.l NewPO						; start new playoffs with team 1 and build the tree
.2x:								; OptPlayers = $0001, if OptPlayMode < $0001 go to .3x, ...
	lda.w #$0001
	sta.l OptPlayers
	lda.l OptPlayMode
	cmp.w #$0001
	bcc .3x
	cmp.w #$0004
	bcs .3x
	lda.w #$0005
	sta.l OptPlayers
.3x:								; pojoy = OptPlayers - $0005, if OptPlayMode != $0001 go to .4, ...
	lda.l OptPlayers
	sec
	sbc.w #$0005
	sta.l pojoy
	lda.l OptPlayMode
	cmp.w #$0001
	bne .4
	jsl.l PasswordScreen			; password entry screen
.4:									; ora PassWord, PassWord = A, call maketree, ...
	lda.w #$0080
	ora.l PassWord
	sta.l PassWord
	jsl.l maketree					; build the playoff tree from the seeds and the series wins
	jmp.w PlayerSelect				; the player select screen after the game setup
.6:									; if d1 bits $1000 clear go to .t2xx, ...
	lda.b d1
	bit.w #$1000
	beq .t2xx
	jmp.w .5

.t2xx:								; d1 bits $1000 clear: if zero go to .t1xxx, ...
	bit.w #$0400
	beq .t1xxx
	lda.w #$0002
	sta.b d0
	jsr.w .12
	jsr.w .10
	jmp.w .3

.t1xxx:								; if zero go to .2xx, ...
	bit.w #$0800
	beq .2xx
	lda.w #$FFFE
	sta.b d0
	jsr.w .12
	jsr.w .10
.1xx:								; go to .3
	jmp.w .3
.2xx:								; d2 = $0001, if d1 bit $0100 set go to .1xxx, ...
	lda.w #$0001
	sta.b d2
	lda.b d1
	bit.w #$0100
	bne .1xxx
	bit.w #$0200
	beq .1xx
	lda.w #$FFFF
	sta.b d2
.1xxx:								; call .7, call .10, go to .3
	jsr.w .7
	jsr.w .10
	jmp.w .3
.7:									; subroutine: if d7 = $0000 go to .1xxxx, ...
	lda.b d7
	cmp.w #$0000
	beq .1xxxx
	cmp.w #$0002
	beq .1xxxx
	cmp.w #$0004
	bne .2xxx
.1xxxx:								; if d2 = 0 go to .2xxx, ...
	lda.b d2
	beq .2xxx
	lda.w #$0005
	sta.l setupmatchup
	lda.w #$0001
	sta.l teamschanged
	sta.l cardtimer
.2xxx:								; a2 = OptPlayMode, a3 = long .14, ...
	lda.w #OptPlayMode>>16
	sta.b a2+2
	lda.w #OptPlayMode
	sta.b a2
	lda.w #.14>>16
	sta.b a3+2
	lda.w #.14
	sta.b a3
	stz.b d5
	ldy.b d7
	lda.b [a3],y
	sta.b d4
	lda.b [a2],y
	sta.b d3
	lda.l OptPlayMode
	cmp.w #$0002
	bcc .3xx
	cmp.w #$0004
	beq .3xx
	cpy.w #$0002
	bne .3xx
	lda.w #$001A
	sta.b d4
.3xx:								; call .9, [a2],y = d3
	jsr.w .9
	lda.b d3
	sta.b [a2],y
	lda.b d2
.8:									; return
	rts
.9:									; subroutine: d3 = d3 + d2, if minus go to .t1xxxx, ...
	lda.b d3
	clc
	adc.b d2
	sta.b d3
	sec
	sbc.b d5
	bmi .t1xxxx
	bvs .1xxxxx
	bra .2xxxx

.t1xxxx:							; if overflow set go to .2xxxx
	bvs .2xxxx
.1xxxxx:							; d3 = d4 - 1
	lda.b d4
	dec a
	sta.b d3
.2xxxx:								; if minus go to .t1xxxxx, ...
	lda.b d3
	sec
	sbc.b d4
	bmi .t1xxxxx
	bvc .3xxx
	bra .8

.t1xxxxx:							; if overflow clear go to .8
	bvc .8
.3xxx:								; d3 = d5, return
	lda.b d5
	sta.b d3
	rts

.t1xxxxxx:							; if zero go to .5x, ...
	lda.b d3
	clc
	adc.b d2
	cmp.w #$0000
	beq .5x
	cmp.w #$0003
	beq .5x
	cmp.w #$0005
	beq .5x
.4x:								; d3 = A, [a2],y = d3, go to .8
	sta.b d3
	lda.b d3
	sta.b [a2],y
	bra .8
.5x:								; increment a, if carry clear go to .4x, ...
	inc a
	cmp.w #$0005
	bcc .4x
	lda.w #$0001
	sta.b d3
	bra .4x
.10:								; subroutine: if teamschanged = 0 go to .1xxxxxx, ...
	lda.l teamschanged
	beq .1xxxxxx
	lda.l OptTeam1
	sta.w HomeTeam
	lda.l OptTeam2
	sta.w VisTeam
	jsl.l setteams					; set up both team structures from the home and visiting teams
	lda.w #$0000
	sta.l teamschanged
.1xxxxxx:							; d2 = blankchar, d0 = $0020, d1 = $000E, ...
	lda.l blankchar
	sta.b d2
	lda.w #$0020
	sta.b d0
	lda.w #$000E
	sta.b d1
	lda.w #$000E
	sta.w printy
	stz.w printx
	jsl.l eraser
	lda.b d7
	sta.b d6
	lda.w #$000E
	sta.w printy
	stz.b d2
	ldx.w #$0000
.4xx:								; loop: printa = $3800, a1 = GameSetupNames, d0 = X, ...
	lda.w #$3800
	sta.w printa
	lda.w #GameSetupNames>>16
	sta.b a1+2
	lda.w #GameSetupNames
	sta.b a1
	stx.b d0
	lda.l OptPlayMode
	asl a
	asl a
	asl a
	asl a
	adc.b d0
	tax
	lda.l .13,x
	ldx.b d0
	cmp.w #$0000
	beq .6x
	bpl .2xxxxx
	lda.w #PlayoffSetupNames>>16
	sta.b a1+2
	lda.w #PlayoffSetupNames
	sta.b a1
.2xxxxx:							; printx = $0003, d0 = X / 2, call PrintStringFromList, ...
	lda.w #$0003
	sta.w printx
	txa
	lsr a
	sta.b d0
	jsl.l PrintStringFromList		; prints a string from a list
	lda.w #$0011
	sta.w printx
	stx.b d7
	jsr.w .7
	txy
	lda.w #OptPlayMode>>16
	sta.b a0+2
	lda.w #OptPlayMode
	sta.b a0
	lda.b [a0],y
	sta.b d3
	lda.w #.15>>16
	sta.b a0+2
	lda.w #.15
	sta.b a0
	clc
	adc.b [a0],y
	sta.b a0
.loopx:								; loop: a1+2 = a0+2, a1 = a0, a0 = a0 + [a0], ...
	lda.b a0+2
	sta.b a1+2
	lda.b a0
	sta.b a1
	clc
	adc.b [a0]
	sta.b a0
	dec.b d3
	bpl .loopx
	cpx.b d6
	bne .3xxxx
	lda.w #$2000
	sta.w printa
.3xxxx:								; d7 = X, if zero go to .7x, ...
	stx.b d7
	cpx.w #$0002
	beq .7x
	cpx.w #$0004
	beq .7x
	jsl.l print
.5xx:								; increment printy, increment printy
	inc.w printy
	inc.w printy
.6x:								; X + 1, X + 1, if carry set go to .t1xxxxxxx, ...
	inx
	inx
	cpx.w #$000E
	bcs .t1xxxxxxx
	jmp.w .4xx

.t1xxxxxxx:							; d7 = d6, return
	lda.b d6
	sta.b d7
	rts
.7x:								; a1 = OptPlayMode, d3 = [a1],y, call GetTeamLongName, ...
	ldy.b d7
	lda.w #OptPlayMode>>16
	sta.b a1+2
	lda.w #OptPlayMode
	sta.b a1
	lda.b [a1],y
	sta.b d3
	jsl.l GetTeamLongName
	jsl.l print
	bra .5xx
.11:								; subroutine: if .13,x != 0 go to .t1xxxxxxxx, ...
	lda.l OptPlayMode
	asl a
	asl a
	asl a
	asl a
	adc.w #$0004
	tax
	lda.l .13,x
	bne .t1xxxxxxxx
	lda.w #$001C
	sta.l setupvis
	lda.w #$0001
	sta.w printx
	lda.w #$000A
	sta.w printy
	lda.w #$000A
	sta.b d0
	lda.w #$0002
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.w #$0001
	sta.l redrawblocks
	bra .1xxxxxxx

.t1xxxxxxxx:						; .13,x != 0: setupvis = VisTeam
	lda.w VisTeam
	sta.l setupvis
.1xxxxxxx:							; X - 1, X - 1, if .13,x != 0 go to .t1xxxxxxxxx, ...
	dex
	dex
	lda.l .13,x
	bne .t1xxxxxxxxx
	lda.w #$001D
	sta.l setuphome
	lda.w #$0016
	sta.w printx
	lda.w #$000A
	sta.w printy
	lda.w #$000A
	sta.b d0
	lda.w #$0002
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.w #$0001
	sta.l redrawblocks
	bra .5xxx

.t1xxxxxxxxx:						; .13,x != 0: setuphome = HomeTeam
	lda.w HomeTeam
	sta.l setuphome
.5xxx:								; cardtimer = cardtimer - 1 - 1, if minus go to .t1xxxxxxxxxx, ...
	lda.l cardtimer
	dec a
	dec a
	sta.l cardtimer
	bmi .t1xxxxxxxxxx
	rts

.t1xxxxxxxxxx:						; call SpriteFrameStart, call .t2xxx, a1 = GameSetupAlt, ...
	jsl.l SpriteFrameStart
	jsr.w .t2xxx
	ldx.w #$004F
	ldy.w #$0018
	lda.w #GameSetupAlt>>16
	sta.b a1+2
	lda.w #GameSetupAlt
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites GameSetupAlt
	lda.l setupvis
	cmp.w #$001C
	bpl .1xxxxxxxx
	lda.w #$0001
	sta.w printx
	lda.w #$000A
	sta.w printy
	lda.w VisTeam
	sta.b d1
	jsl.l DrawTeamBlocks			; entry: the block of team d1
.1xxxxxxxx:							; if setuphome - $001C >= 0 go to .2xxxxxx, ...
	lda.l setuphome
	cmp.w #$001C
	bpl .2xxxxxx
	lda.w #$0016
	sta.w printx
	lda.w #$000A
	sta.w printy
	lda.w HomeTeam
	sta.b d1
	jsl.l DrawTeamBlocks			; entry: the block of team d1
.2xxxxxx:							; if setuphome >= 0 go to .3xxxxx, ...
	lda.l setuphome
	bpl .3xxxxx
	lda.w #$0000
	sta.b a1+2
	lda.w #$0A5C
	sta.b a1
	stz.b a2
	lda.w #$FFFF
	sta.b d1
	ldx.w #$0008
	ldy.w #$0043
	jsl.l PrintTeamSprites			; draw the place name of team d1, or string [a1] when d1 is negative
.3xxxxx:							; if setupvis >= 0 go to .4xxx, ...
	lda.l setupvis
	bpl .4xxx
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$0002
	sta.b a2
	lda.w #$FFFF
	sta.b d1
	ldx.w #$0008
	ldy.w #$0043
	jsl.l PrintTeamSprites			; draw the place name of team d1, or string [a1] when d1 is negative
.4xxx:								; call DrawMatchupPictures, call SpriteFrameEnd, call SendColours, ...
	jsl.l DrawMatchupPictures
	jsl.l SpriteFrameEnd
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	rts

.t2xxx:								; subroutine: cardtimer = $0078, if carry clear go to .1xxxxxxxxx, ...
	lda.w #$0078
	sta.l cardtimer
	lda.l setupmatchup
	inc a
	cmp.w #$0007
	bcc .1xxxxxxxxx
	lda.w #$0000
.1xxxxxxxxx:						; setupmatchup = A, if zero go to .rts, ...
	sta.l setupmatchup
	cmp.w #$0006
	beq .rts
	lda.l setuphome
	cmp.w #$001C
	bpl .2xxxxxxx
	lda.w #$FFFF
	sta.l setuphome
	ldx.w #$0000
	jsr.w .t1xxxxxxxxxxx
.2xxxxxxx:							; if setupvis - $001C >= 0 go to .3xxxxxx, ...
	lda.l setupvis
	cmp.w #$001C
	bpl .3xxxxxx
	lda.w #$FFFF
	sta.l setupvis
	ldx.w #$0002
	jsr.w .t1xxxxxxxxxxx
.3xxxxxx:							; a2 = 0, matchuphome = setupmatchup, a2 = $0002, ...
	stz.b a2
	lda.l setupmatchup
	sta.l matchuphome
	lda.w #$0002
	sta.b a2
	lda.l setupmatchup
	sta.l matchupvis
.rts:								; return
	rts

.t1xxxxxxxxxxx:						; subroutine: a2 = X, call GetMatchupPlayer, call PlayerShortName, ...
	stx.b a2
	lda.l setupmatchup
	jsl.l GetMatchupPlayer			; d0 = the roster slot of team a2's player for matchup A
	jsl.l PlayerShortName			; mesarea = the number
	cpx.w #$0000
	bne .rtsx
	lda.b a1+2
	sta.b p0+2
	lda.b a1
	sta.b p0
	lda.w #$0000
	sta.b p1+2
	lda.w #$0A5C
	sta.b p1
	ldx.w #$0031
	jsl.l MemCopy					; copy X bytes from [p0] to [p1]
.rtsx:								; return
	rts
.12:								; subroutine: d3 = d7
	phx
	lda.b d7
	sta.b d3
.2xxxxxxxx:							; d7 = d7 + d0, if plus go to .1xxxxxxxxxx, ...
	lda.b d7
	clc
	adc.b d0
	sta.b d7
	bpl .1xxxxxxxxxx
	stz.b d7
.1xxxxxxxxxx:						; if d7 < $000E go to .t1xxxxxxxxxxxx, ...
	lda.b d7
	cmp.w #$000E
	bcc .t1xxxxxxxxxxxx
	lda.b d3
	sta.b d7
	bra .3xxxxxxx

.t1xxxxxxxxxxxx:					; d7 < $000E: if .13,x = 0 go to .2xxxxxxxx
	lda.l OptPlayMode
	asl a
	asl a
	asl a
	asl a
	adc.b d7
	tax
	lda.l .13,x
	beq .2xxxxxxxx
.3xxxxxxx:							; return
	plx
	rts
.13:								; dw $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0000, dw $0001,$0000,$0...
	dw $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0000
	dw $0001,$0000,$0000,$0001,$0001,$0001,$0001,$0000
	dw $0001,$FFFF,$0000,$0001,$0001,$0001,$0001,$0000
	dw $0001,$FFFF,$0000,$0001,$0001,$0001,$0001,$0000
	dw $0001,$0001,$0001,$0000,$0000,$0000,$0001,$0000
	dw $0000
.14:								; dw $0005,$001C,$001C,$0003,$0003,$0003,$0002
	dw $0005,$001C,$001C,$0003,$0003,$0003,$0002
.15:								; dw $000E,$005E,$005E,$005E,$009E,$00CE,$00FE
	dw $000E,$005E,$005E,$005E,$009E,$00CE,$00FE
