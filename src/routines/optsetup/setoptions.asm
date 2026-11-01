; The game setup screen: up and down pick a line, left and right change it, Start goes on
setoptions:							; called from Opening2
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	lda.w #$0001					;matchup photos on
	sta.l matchupphotos
	lda.w #$0000					;stats off
	sta.l playerstatson
	lda.w #$FFFF					;no team photos yet
	sta.l phototeams
	sta.l phototeams+2
	lda.w #$0001					;redraw the team blocks,
	sta.l redrawblocks
	sta.l cardtimer					;the cards,
	sta.l teamschanged				;and the teams
	lda.w #$0005
	sta.l setupmatchup				;matchup panel 5
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jsl.l ClearTextMap				; fill the text map with the blank tile
	jsl.l InitSetupChars			; set the tile numbers and load the font of the setup screen
	lda.l Opt1team					;team options
	sta.w HomeTeam
	lda.l Opt2team
	sta.w VisTeam
	jsl.l setteams					; set up both team structures from the home and visiting teams
	lda.w VisTeam
	clc
	adc.w #$0021					;logo-team flag $21
	sta.l setupvis					;setup screen visitors
	lda.w HomeTeam					;home team
	sta.l setuphome					;setup screen home
	jsl.l SetupScreen				; common setup of the stats screens
	sep #$20
	lda.b #$01						;mode 1
	sta.w BGMODE
	rep #$20
	ldx.w #$004F					;x 79
	ldy.w #$0018					;y 24
	lda.w #GameSetupTitle>>16
	sta.b a1+2
	lda.w #GameSetupTitle
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites GameSetupTitle
	lda.w #$1D47					;blue
	sta.l colourbuf+$A				;text colour
	lda.w #$FFFF
	sta.l colourbuf+$E				;white
	lda.w #$14A5					;dark grey
	sta.l colourbuf+$182
	lda.w #$6F7B					;light grey
	sta.l colourbuf+$C2
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	jsl.l SpriteFrameEnd
	jsl.l SendTextMap
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l ReadAnyPad				; d1 = the buttons that changed on any pad
	lda.w #$0000					;sprite priority 0
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
	jsl.l defaultsprites_0
	lda.w #$0028					;roster x offset 40
	sta.w rosxoff					;home and visitors
	sta.w rosxoff+(6*2)
	lda.w #$FFFF					;not the demo
	sta.l notdemo
	lda.b a2						;keep a2
	pha
	lda.w #$0000
	sta.b a2
	jsl.l LoadTeamLines				; copy team a2's lines from the team data into RAM
	lda.w #$0002
	sta.b a2
	jsl.l LoadTeamLines				; copy team a2's lines from the team data into RAM
	pla
	sta.b a2						;restore a2
	stz.b d7						;cursor on line 0
	stz.b d0						;no change
	jsr.w .12						;apply it
	jsr.w .10						;redraw the options
	jsr.w .11						;draw the sprites
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l MenuScreenHDMA			; start the window and COLDATA HDMA
	jsl.l ScreenOn
	lda.w #$0008					;band top
	ldx.w #$0040					;band height
	jsl.l SetupBandIRQ				; set up the band IRQ pair
	jsl.l SendTextMap
	ldx.w #$0000
	jsl.l LoadMatchupPhotos			; unpack the matchup player photos of team x
	ldx.w #$0002
	jsl.l LoadMatchupPhotos			; unpack the matchup player photos of team x
.3:									; d6 = $12C0
	lda.w #$12C0					;demo countdown $12C0
	sta.b d6
.2:									; loop: call WaitFrame, if OAMReady != 0 go to .2, ...
	jsl.l WaitFrame
	lda.w OAMReady					;sprites sent yet?
	bne .2							;no: wait
	inc.w seed						;randomize the seed
	bne .1
	inc.w seed+2					;carry
.1:									; call WaitFrame, eor d2+2, if not zero go to .t5, ...
	jsl.l WaitFrame
	ldx.w mp5warning				;multitap warning
	txa
	eor.b d2+2						;changed?
	bne .t5							;yes: show it
	jmp.w .t6						;no

.t5:								; d2+2 = X, if zero go to .t4, ...
	stx.b d2+2						;keep it
	txa
	beq .t4							;cleared: redraw
	bit.w #$0001					;multitap in socket 1?
	bne .t1
	bit.w #$0002					;Super Scope?
	bne .t2
	bit.w #$0004					;mouse?
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
	jsl.l ClearTextMapBottom		;re-check the multitap
	jsr.w .10						;clear the message rows
	stz.b d1						;redraw the options
	jmp.w .6						;no buttons

.t6:								; if mp5warning = 0 go to .t1x, ...
	lda.w mp5warning				;warning up?
	beq .t1x						;no: read the pads
	jmp.w .2						;yes: wait

.t1x:								; mp5warning = 0: call ReadPads, lastframevc = Vcount, OldVcount = vcou...
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	lda.b Vcount					;frame count
	sta.w lastframevc
	sta.w OldVcount
	jsl.l ReadJoy1					; read pad 1: d0 = direction, d1 = new presses, d2 = changed buttons
	dec.w repeatdelayframes			;repeat timer
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
	lda.b d1						;new presses
	and.w #$FFF0					;buttons only
	sta.b d1
	beq .t2x						;none: idle
	jmp.w .6						;handle them

.t2x:								; call .11, call QueueTextDMA, decrement d6, ...
	jsr.w .11						;sprites
	jsl.l QueueTextDMA				; queue the changed part of the text map for transfer to video memory
	dec.b d6						;demo countdown
	dec.b d6
	bmi .t1xx						;time up: run the demo
	jmp.w .2						;keep waiting

.t1xx:								; d6 counted below 0: call randoma8, Opt1team = A, HomeTeam = A
	lda.w #$001C					;28 teams
	jsl.l randoma8					; random number below A
	sta.l Opt1team					;random home team
	sta.w HomeTeam
.loop:								; loop: call randoma8, if zero go to .loop, ...
	lda.w #$001C					;28 teams
	jsl.l randoma8					; random number below A
	cmp.l Opt1team					;same team?
	beq .loop						;yes: pick again
	sta.l Opt2team					;random visitors
	sta.w VisTeam
	lda.w #$0000
	sta.l notdemo					;demo
	lda.w #$0000
	sta.l OptPlayMode				;exhibition
	sta.l OptNOP					;no players
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
	stx.b r0						;size
	jsl.l LinearToPlanar			;to planar
	lda.w #$0000
	sta.l matchupphotos				;matchup photos off
	lda.l OptPlayMode				;play mode
	cmp.w #$0002					;new playoffs?
	beq .1x							;yes
	cmp.w #$0003					;best-of-7 playoffs?
	bne .2x							;no
.1x:								; call NewPO
	jsl.l NewPO						; start new playoffs with team 1 and build the tree
.2x:								; OptNOP = $0001, if OptPlayMode < $0001 go to .3x, ...
	lda.w #$0001
	sta.l OptNOP					;one player
	lda.l OptPlayMode				;play mode
	cmp.w #$0001					;exhibition?
	bcc .3x							;yes
	cmp.w #$0004					;shootout?
	bcs .3x							;yes
	lda.w #$0005					;playoffs: five pads
	sta.l OptNOP
.3x:								; pojoy = OptNOP - $0005, if OptPlayMode != $0001 go to .4, ...
	lda.l OptNOP
	sec
	sbc.w #$0005					;pad offset for the playoffs
	sta.l pojoy
	lda.l OptPlayMode
	cmp.w #$0001					;continue playoffs?
	bne .4							;no
	jsl.l PasswordScreen			;enter the password
.4:									; ora PassWord, PassWord = A, call MakeTree, ...
	lda.w #$0080					;password valid flag
	ora.l PassWord
	sta.l PassWord
	jsl.l MakeTree					;build the playoff tree
	jmp.w PlayerSelect				; the player select screen after the game setup
.6:									; if d1 bits $1000 clear go to .t2xx, ...
	lda.b d1						;new presses
	bit.w #$1000					;start?
	beq .t2xx						;yes: start the game
	jmp.w .5

.t2xx:								; d1 bits $1000 clear: if zero go to .t1xxx, ...
	bit.w #$0400					;up?
	beq .t1xxx						;no
	lda.w #$0002					;next line down
	sta.b d0
	jsr.w .12						;move the cursor
	jsr.w .10						;redraw
	jmp.w .3

.t1xxx:								; if zero go to .2xx, ...
	bit.w #$0800					;down?
	beq .2xx						;no
	lda.w #$FFFE					;line up
	sta.b d0
	jsr.w .12						;move the cursor
	jsr.w .10						;redraw
.1xx:								; go to .3
	jmp.w .3
.2xx:								; d2 = $0001, if d1 bit $0100 set go to .1xxx, ...
	lda.w #$0001					;+1
	sta.b d2
	lda.b d1						;new presses
	bit.w #$0100					;right?
	bne .1xxx
	bit.w #$0200					;left?
	beq .1xx						;no
	lda.w #$FFFF					;-1
	sta.b d2
.1xxx:								; call .7, call .10, go to .3
	jsr.w .7						;change the option
	jsr.w .10						;redraw
	jmp.w .3
.7:									; subroutine: if d7 = $0000 go to .1xxxx, ...
	lda.b d7						;cursor line
	cmp.w #$0000					;play mode?
	beq .1xxxx						;yes: the teams change
	cmp.w #$0002					;home team?
	beq .1xxxx
	cmp.w #$0004					;visitors?
	bne .2xxx						;no
.1xxxx:								; if d2 = 0 go to .2xxx, ...
	lda.b d2						;change
	beq .2xxx						;none
	lda.w #$0005					;matchup panel 5
	sta.l setupmatchup
	lda.w #$0001					;teams changed
	sta.l teamschanged
	sta.l cardtimer					;redraw the cards
.2xxx:								;options base
	lda.w #OptPlayMode>>16
	sta.b a2+2
	lda.w #OptPlayMode
	sta.b a2
	lda.w #.14>>16					;option counts
	sta.b a3+2
	lda.w #.14
	sta.b a3
	stz.b d5						;no wrap yet
	ldy.b d7						;line
	lda.b [a3],y					;option count
	sta.b d4						;d4
	lda.b [a2],y					;current value
	sta.b d3						;d3
	lda.l OptPlayMode				;play mode
	cmp.w #$0002					;exhibition or continue?
	bcc .3xx						;yes
	cmp.w #$0004					;shootout?
	beq .3xx						;yes
	cpy.w #$0002					;home team line?
	bne .3xx						;no
	lda.w #$001A					;playoffs: 26 teams
	sta.b d4
.3xx:								; call .9, [a2],y = d3
	jsr.w .9						;step and wrap
	lda.b d3
	sta.b [a2],y					;store the new value
	lda.b d2						;return the step
.8:									; return
	rts
.9:									;d3 += d2, wrapped to d5 .. d4-1
	lda.b d3						; add the step
	clc
	adc.b d2						;plus the step
	sta.b d3
	sec
	sbc.b d5						;minus the lowest
	bmi .t1xxxx						;below it?
	bvs .1xxxxx						;overflow: below
	bra .2xxxx						;in range

.t1xxxx:							; if overflow set go to .2xxxx
	bvs .2xxxx						;overflow: above
.1xxxxx:							;wrap to the top
	lda.b d4
	dec a							;count - 1
	sta.b d3
.2xxxx:								; if minus go to .t1xxxxx, ...
	lda.b d3						;value
	sec
	sbc.b d4						;minus the count
	bmi .t1xxxxx					;under the count?
	bvc .3xxx						;no: wrap to the bottom
	bra .8							;in range

.t1xxxxx:							; if overflow clear go to .8
	bvc .8							;in range
.3xxx:								;wrap to the bottom
	lda.b d5
	sta.b d3
	rts

.t1xxxxxx:							;step skipping values 0, 3, 5 (unused)
	lda.b d3
	clc
	adc.b d2
	cmp.w #$0000					;value 0?
	beq .5x
	cmp.w #$0003					;value 3?
	beq .5x
	cmp.w #$0005					;value 5?
	beq .5x
.4x:								; d3 = A, [a2],y = d3, go to .8
	sta.b d3						;new value
	lda.b d3
	sta.b [a2],y					;store it
	bra .8
.5x:								; increment a, if carry clear go to .4x, ...
	inc a							;skip it
	cmp.w #$0005					;past the end?
	bcc .4x							;no
	lda.w #$0001					;wrap to 1
	sta.b d3
	bra .4x
.10:								;redraw the option lines
	lda.l teamschanged				;teams changed?
	beq .1xxxxxx					;no
	lda.l Opt1team					;team options
	sta.w HomeTeam
	lda.l Opt2team
	sta.w VisTeam
	jsl.l setteams					;rebuild the team structures
	lda.w #$0000
	sta.l teamschanged				;done
.1xxxxxx:							; d2 = blankchar, d0 = $0020, d1 = $000E, ...
	lda.l blankchar
	sta.b d2						;blanks
	lda.w #$0020
	sta.b d0						;32 wide
	lda.w #$000E
	sta.b d1						;14 high
	lda.w #$000E
	sta.w printy					;row 14
	stz.w printx					;column 0
	jsl.l eraser					;clear the option area
	lda.b d7						;cursor line
	sta.b d6						;keep it
	lda.w #$000E
	sta.w printy					;row 14
	stz.b d2						;no wrap
	ldx.w #$0000					;first line
.4xx:								; loop: printa = $3800, a1 = GameSetupNames, d0 = X, ...
	lda.w #$3800					;palette 6
	sta.w printa
	lda.w #GameSetupNames>>16
	sta.b a1+2
	lda.w #GameSetupNames
	sta.b a1
	stx.b d0						;line
	lda.l OptPlayMode				;play mode
	asl a
	asl a
	asl a
	asl a							;16 bytes per mode
	adc.b d0						;plus the line
	tax
	lda.l .13,x						;how this line shows in the mode
	ldx.b d0
	cmp.w #$0000					;hidden?
	beq .6x							;yes: skip
	bpl .2xxxxx						;normal: game setup names
	lda.w #PlayoffSetupNames>>16	;negative: playoff names
	sta.b a1+2
	lda.w #PlayoffSetupNames
	sta.b a1
.2xxxxx:							; printx = $0003, d0 = X / 2, call Fprint, ...
	lda.w #$0003					;column 3
	sta.w printx
	txa
	lsr a							;/2
	sta.b d0						;line number
	jsl.l Fprint					;print the line name
	lda.w #$0011
	sta.w printx					;column 17
	stx.b d7						;this line
	jsr.w .7						;no change, just bounds
	txy
	lda.w #OptPlayMode>>16			;options base
	sta.b a0+2
	lda.w #OptPlayMode
	sta.b a0
	lda.b [a0],y					;current value
	sta.b d3						;d3
	lda.w #.15>>16					;value text lists
	sta.b a0+2
	lda.w #.15
	sta.b a0
	clc								; offset to the first string
	adc.b [a0],y					;plus the line's list offset
	sta.b a0						;list
.loopx:								; loop: a1+2 = a0+2, a1 = a0, a0 = a0 + [a0], ...
	lda.b a0+2						; a1 = this string
	sta.b a1+2						;this string
	lda.b a0
	sta.b a1
	clc
	adc.b [a0]						;plus its length
	sta.b a0						;next string
	dec.b d3						;count down to the value
	bpl .loopx						;until it
	cpx.b d6						;the cursor line?
	bne .3xxxx						;no
	lda.w #$2000					;highlight palette
	sta.w printa
.3xxxx:								; d7 = X, if zero go to .7x, ...
	stx.b d7						;this line
	cpx.w #$0002					;home team?
	beq .7x							;yes: team name
	cpx.w #$0004					;visitors?
	beq .7x							;yes: team name
	jsl.l print						;print the value
.5xx:								; increment printy, increment printy
	inc.w printy
	inc.w printy					;next row (double spaced)
.6x:								; X + 1, X + 1, if carry set go to .t1xxxxxxx, ...
	inx
	inx
	cpx.w #$000E					;all 7 lines?
	bcs .t1xxxxxxx					;yes
	jmp.w .4xx						;no: next

.t1xxxxxxx:							; d7 = d6, return
	lda.b d6						;restore the cursor line
	sta.b d7
	rts
.7x:								; a1 = OptPlayMode, d3 = [a1],y, call GetTeamLongName, ...
	ldy.b d7						;line
	lda.w #OptPlayMode>>16
	sta.b a1+2
	lda.w #OptPlayMode
	sta.b a1
	lda.b [a1],y					;team number
	sta.b d3
	jsl.l GetTeamLongName			;team name
	jsl.l print						;print it
	bra .5xx
.11:								; subroutine: if .13,x != 0 go to .t1xxxxxxxx, ...
	lda.l OptPlayMode				;play mode
	asl a
	asl a
	asl a
	asl a							;16 bytes per mode
	adc.w #$0004					;visitors' line
	tax
	lda.l .13,x						;shown?
	bne .t1xxxxxxxx					;yes: logo
	lda.w #$001C					;no team: blank block
	sta.l setupvis
	lda.w #$0001					;column 1
	sta.w printx
	lda.w #$000A					;row 10
	sta.w printy
	lda.w #$000A					;10 wide
	sta.b d0
	lda.w #$0002					;2 high
	sta.b d1
	lda.l blankchar					;blanks
	sta.b d2
	jsl.l eraser					;clear the block
	lda.w #$0001
	sta.l redrawblocks				;redraw later
	bra .1xxxxxxx

.t1xxxxxxxx:						;visitors' logo
	lda.w VisTeam
	sta.l setupvis
.1xxxxxxx:							; X - 1, X - 1, if .13,x != 0 go to .t1xxxxxxxxx, ...
	dex
	dex
	lda.l .13,x						;shown?
	bne .t1xxxxxxxxx				;yes: logo
	lda.w #$001D					;no team: blank block
	sta.l setuphome
	lda.w #$0016					;column 22
	sta.w printx
	lda.w #$000A					;row 10
	sta.w printy
	lda.w #$000A					;10 wide
	sta.b d0
	lda.w #$0002					;2 high
	sta.b d1
	lda.l blankchar					;blanks
	sta.b d2
	jsl.l eraser					;clear the block
	lda.w #$0001
	sta.l redrawblocks				;redraw later
	bra .5xxx

.t1xxxxxxxxx:						; .13,x != 0: setuphome = HomeTeam
	lda.w HomeTeam					;home logo
	sta.l setuphome
.5xxx:								; cardtimer = cardtimer - 1 - 1, if minus go to .t1xxxxxxxxxx, ...
	lda.l cardtimer					;card timer
	dec a							;minus 2
	dec a
	sta.l cardtimer					;every other frame
	bmi .t1xxxxxxxxxx				;time up: next card
	rts

.t1xxxxxxxxxx:						; call SpriteFrameStart, call .t2xxx, a1 = GameSetupAlt, ...
	jsl.l SpriteFrameStart
	jsr.w .t2xxx					;next matchup
	ldx.w #$004F					;x 79
	ldy.w #$0018					;y 24
	lda.w #GameSetupAlt>>16
	sta.b a1+2
	lda.w #GameSetupAlt
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites GameSetupAlt
	lda.l setupvis					;visitors a real team?
	cmp.w #$001C					;no
	bpl .1xxxxxxxx
	lda.w #$0001					;column 1
	sta.w printx
	lda.w #$000A					;row 10
	sta.w printy
	lda.w VisTeam					;visitors
	sta.b d1
	jsl.l DrawTeamBlocks			;team block
.1xxxxxxxx:							; if setuphome - $001C >= 0 go to .2xxxxxx, ...
	lda.l setuphome					;home a real team?
	cmp.w #$001C					;no
	bpl .2xxxxxx
	lda.w #$0016					;column 22
	sta.w printx
	lda.w #$000A					;row 10
	sta.w printy
	lda.w HomeTeam					;home
	sta.b d1
	jsl.l DrawTeamBlocks			;team block
.2xxxxxx:							; if setuphome >= 0 go to .3xxxxx, ...
	lda.l setuphome					;home a matchup player?
	bpl .3xxxxx						;no
	lda.w #$0000					;player name in RAM
	sta.b a1+2
	lda.w #$0A5C					;at $0A5C
	sta.b a1
	stz.b a2						;home
	lda.w #$FFFF					;no team: the string
	sta.b d1
	ldx.w #$0008					;x 8
	ldy.w #$0043					;y 67
	jsl.l PrintTeamSprites			;draw the name
.3xxxxx:							; if setupvis >= 0 go to .4xxx, ...
	lda.l setupvis					;visitors a matchup player?
	bpl .4xxx						;no
	lda.w #mesarea>>16				;player name
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$0002					;visitors
	sta.b a2
	lda.w #$FFFF					;no team: the string
	sta.b d1
	ldx.w #$0008					;x 8
	ldy.w #$0043					;y 67
	jsl.l PrintTeamSprites			;draw the name
.4xxx:								; call DrawMatchupPictures, call SpriteFrameEnd, call SendColours, ...
	jsl.l DrawMatchupPictures		;pictures or logos
	jsl.l SpriteFrameEnd			;end the sprite frame
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	rts

.t2xxx:								; subroutine: cardtimer = $0078, if carry clear go to .1xxxxxxxxx, ...
	lda.w #$0078					;2 seconds
	sta.l cardtimer
	lda.l setupmatchup				;matchup
	inc a							;next
	cmp.w #$0007					;past 6?
	bcc .1xxxxxxxxx					;no
	lda.w #$0000					;wrap to 0
.1xxxxxxxxx:						; setupmatchup = A, if zero go to .rts, ...
	sta.l setupmatchup				;new matchup
	cmp.w #$0006					;6: logos only
	beq .rts						;yes
	lda.l setuphome					;home a real team?
	cmp.w #$001C					;no
	bpl .2xxxxxxx					;home: show a player
	lda.w #$FFFF
	sta.l setuphome
	ldx.w #$0000					;home team
	jsr.w .t1xxxxxxxxxxx			;get his name
.2xxxxxxx:							; if setupvis - $001C >= 0 go to .3xxxxxx, ...
	lda.l setupvis					;visitors a real team?
	cmp.w #$001C					;no
	bpl .3xxxxxx					;visitors: show a player
	lda.w #$FFFF
	sta.l setupvis
	ldx.w #$0002					;visitors
	jsr.w .t1xxxxxxxxxxx			;get his name
.3xxxxxx:							; a2 = 0, matchuphome = setupmatchup, a2 = $0002, ...
	stz.b a2						;home
	lda.l setupmatchup
	sta.l matchuphome				;home matchup player
	lda.w #$0002					;visitors
	sta.b a2
	lda.l setupmatchup
	sta.l matchupvis				;visitors' matchup player
.rts:								; return
	rts

.t1xxxxxxxxxxx:						; a2 = X, GetMatchupPlayer, FormatPlayerNumInitial, ...
	stx.b a2						;team
	lda.l setupmatchup				;matchup
	jsl.l GetMatchupPlayer			;which player
	jsl.l FormatPlayerNumInitial	;his short name
	cpx.w #$0000					;home?
	bne .rtsx						;no
	lda.b a1+2						;name string
	sta.b p0+2
	lda.b a1
	sta.b p0
	lda.w #$0000
	sta.b p1+2
	lda.w #$0A5C					;to $0A5C
	sta.b p1
	ldx.w #$0031					;$31 bytes
	jsl.l MemCopy					;keep the home name
.rtsx:								; return
	rts
.12:								;move the cursor d0, skipping hidden lines
	phx
	lda.b d7						; keep the old line
	sta.b d3						;old line
.2xxxxxxxx:							; d7 = d7 + d0, if plus go to .1xxxxxxxxxx, ...
	lda.b d7
	clc
	adc.b d0						;plus the step
	sta.b d7
	bpl .1xxxxxxxxxx				;still on the screen
	stz.b d7						;clamp to the top
.1xxxxxxxxxx:						; if d7 < $000E go to .t1xxxxxxxxxxxx, ...
	lda.b d7
	cmp.w #$000E					;past the last?
	bcc .t1xxxxxxxxxxxx
	lda.b d3						;yes: stay put
	sta.b d7
	bra .3xxxxxxx

.t1xxxxxxxxxxxx:					; d7 < $000E: if .13,x = 0 go to .2xxxxxxxx
	lda.l OptPlayMode
	asl a
	asl a
	asl a
	asl a
	adc.b d7						;plus the line
	tax
	lda.l .13,x						;shown in this mode?
	beq .2xxxxxxxx					;hidden: keep moving
.3xxxxxxx:							; return
	plx
	rts
.13:								;per mode: 1 shown, 0 hidden, -1 playoff wording
	dw $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0000
	dw $0001,$0000,$0000,$0001,$0001,$0001,$0001,$0000
	dw $0001,$FFFF,$0000,$0001,$0001,$0001,$0001,$0000
	dw $0001,$FFFF,$0000,$0001,$0001,$0001,$0001,$0000
	dw $0001,$0001,$0001,$0000,$0000,$0000,$0001,$0000
	dw $0000
.14:								;values per option line
	dw $0005,$001C,$001C,$0003,$0003,$0003,$0002
.15:								;offset of each line's value strings
	dw $000E,$005E,$005E,$005E,$009E,$00CE,$00FE
