; The player select screen after the game setup: each pad moves its icon under the visitors or home team
; (cont1team-cont5team), start goes on
PlayerSelect:						; called from setoptions
	stz.w cont1team					;every pad in the middle
	stz.w cont2team
	stz.w cont3team
	stz.w cont4team
	stz.w cont5team
	lda.l notdemo					;real game?
	bne .t1							;yes
	rtl

.t1:								; notdemo != 0: mp5readall = $FFFF, call FadeOut, call WaitFadeOut, ...
	lda.w #$FFFF					;read every multitap pad
	sta.w mp5readall
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	sep #$20
	lda.b #$09						;mode 1, BG3 priority
	sta.w BGMODE
	lda.b #$08						;BG3 map at $0800
	sta.w BG3SC
	lda.b #$04						;BG3 chars at $4000
	sta.w BG34NBA
	lda.b #$17						;main: BG1-3, sprites
	sta.w TM
	rep #$20
	lda.w #$FFFC					;BG3 down 4
	sta.w BG3VScroll
	lda.w #screenmap>>16
	sta.b p1+2
	lda.w #screenmap+6
	sta.b p1
	lda.w #$0000
	ldx.w #$0800					;$800 bytes
	jsl.l MemFill					;clear the screen map
	lda.w #screenmap>>16
	sta.b p0+2
	lda.w #$A676
	sta.b p0
	lda.w #$0000
	ldx.w #$0800					;$800 bytes
	ldy.w #$0800					;to the BG3 map
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	jsl.l MenuScreenHDMA			; start the window and COLDATA HDMA
	jsl.l ScreenOn
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	lda.w #$000A
	sta.w fadestep					;fade speed
	stz.b d1						;the visitors can be picked
	stz.b d1+2						;not playoffs
	lda.l OptPlayMode				;play mode
	cmp.w #$0001					;exhibition?
	bcc .2							;yes
	cmp.w #$0004					;shootout?
	bcs .2							;yes
	lda.w #$0001					;playoffs: pad 1 on home
	sta.w cont1team
	jsl.l FigureJoy					;the user's team
	lda.w cont1team					;which side?
	dec a
	beq .1							;home: as is
	lda.w VisTeam
	sta.w HomeTeam					;the user's team plays home
.1:									; decrement d1, increment d1+2
	dec.b d1						;visitors locked
	inc.b d1+2						;playoff flag
.2:									; cont1team = $0001
	lda.w #$0001
	sta.w cont1team					;pad 1 on home
.3:									; call ClearTextMapBottom, call ClearBigText
	lda.b d1
	pha
	jsl.l ClearTextMapBottom		; fill the text map from row 12 down with the blank tile
	jsr.w ClearBigText
	ldx.w #$0000
	lda.w #$0000					;zero
.loop:								; loop: bigtextbuf,x = A, X + 1, X + 1, ...
	sta.l bigtextbuf,x				;clear the big text
	inx
	inx
	cpx.w #$0290					;$290 bytes
	bcc .loop
	lda.w #$FFFF
	sta.l redrawblocks				;redraw the team blocks
	lda.w #$0001
	sta.w printx					;column 1
	lda.w #$000A
	sta.w printy					;row 10
	lda.w VisTeam
	sta.b d1						;visitors' block
	lda.b d1+2
	pha								;keep the flag
	bne .1x							;playoffs: no visitors' block
	jsr.w DrawSelectTeam			; draw team d1 on the player select screen at printx: its palette
.1x:								; d1+2 = pulled value, printx = $0016, d1 = HomeTeam, ...
	pla
	sta.b d1+2						;restore it
	lda.w #$0016
	sta.w printx					;column 22
	lda.w HomeTeam
	sta.b d1						;home block
	jsr.w DrawSelectTeam			; draw team d1 on the player select screen at printx: its palette
	jsr.w SendBigText				; send the RenderBigText map and the letter tiles (bigtextbuf,
	jsl.l SendTextMap
	pla								;restore d1
	sta.b d1
	lda.w #PlayerMarkerPalette>>16
	sta.b p0+2
	lda.w #PlayerMarkerPalette
	sta.b p0
	ldy.w #$0090					;sprite palette 1
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.b d1+2						;playoffs?
	beq .t1x						;no
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #NotTxt>>16
	sta.b a1+2
	lda.w #NotTxt
	sta.b a1
	jsl.l print						; print NotTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayingTxt>>16
	sta.b a1+2
	lda.w #PlayingTxt
	sta.b a1
	jsl.l print						; print PlayingTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .t2

.t1x:								; d1+2 = 0: a1 = NotTxt2, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #NotTxt2>>16
	sta.b a1+2
	lda.w #NotTxt2
	sta.b a1
	jsl.l print						; print NotTxt2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayingTxt2>>16
	sta.b a1+2
	lda.w #PlayingTxt2
	sta.b a1
	jsl.l print						; print PlayingTxt2
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .t2

.t2:								; a1 = UseToSelectTeamTxt, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #UseToSelectTeamTxt>>16
	sta.b a1+2
	lda.w #UseToSelectTeamTxt
	sta.b a1
	jsl.l print						; print UseToSelectTeamTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PressStartWhenDoneTxt>>16
	sta.b a1+2
	lda.w #PressStartWhenDoneTxt
	sta.b a1
	jsl.l print						; print PressStartWhenDoneTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l QueueTextDMA				; queue the changed part of the text map for transfer to video memory
.4:									;multitap warning
	jsl.l WaitFrame
	ldx.w mp5warning				;changed?
	txa
	eor.b d2
	bne .t5							;no
	jmp.w .t6

.t5:								; d2 = X, if zero go to .t4, ...
	stx.b d2						;keep it
	txa
	beq .t4							;cleared: redraw
	bit.w #$0001					;multitap in socket 1?
	bne .t1xx
	bit.w #$0002					;Super Scope?
	bne .t2x
	bit.w #$0004					;mouse?
	bne .t3
	bra .t6

.t1xx:								; call RedrawPlayerSelect, call Multi5SocketMsg, go to .t6
	jsl.l RedrawPlayerSelect
	jsl.l Multi5SocketMsg			; print the MultiPlayer 5 socket warning
	bra .t6

.t2x:								; call RedrawPlayerSelect, call Multi5ScopeMsg, go to .t6
	jsl.l RedrawPlayerSelect
	jsl.l Multi5ScopeMsg			; print the MultiPlayer 5 Super Scope warning
	bra .t6

.t3:								; call RedrawPlayerSelect, call Multi5MouseMsg, go to .t6
	jsl.l RedrawPlayerSelect
	jsl.l Multi5MouseMsg			; print the MultiPlayer 5 mouse warning
	bra .t6

.t4:								; call Multi5Init, go to .3
	jsl.l Multi5Init				;re-check the multitap
	jmp.w .3						;redraw

.t6:								; if mp5warning = 0 go to .t1xxx, ...
	lda.w mp5warning				;warning up?
	beq .t1xxx						;no: read the pads
	jmp.w .4						;yes: wait

.t1xxx:								; mp5warning = 0: call ReadPads
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	ldx.w #$0000					;first pad
.5:									; if mp5warning != 0 go to .1xx, ...
	lda.w mp5warning				;warning up?
	bne .1xx						;yes: centre this pad
	lda.w PadRaw1,x					;held
	and.w #$000F					;not a standard pad?
	beq .t1xxxx						;standard: read it
.1xx:								; cont1team,x = $0000, go to .10
	lda.w #$0000					;centre
	sta.w cont1team,x				;not playing
	jmp.w .10

.t1xxxx:							; PadRaw1,x & $000F = 0: if padnew1,x bit $1000 set go to .t3x, ...
	lda.w padnew1,x					;new presses
	bit.w #$1000					;start?
	bne .t3x
	jmp.w .6						;no: left / right

.t3x:								; padnew1,x bit $1000 set: if d1+2 = 0 go to .1xxx, ...
	lda.b d1+2						;playoffs?
	beq .1xxx						;no: check the picks
	ldx.w #$0000					;every pad
	lda.w #$0000
.loopx:								; loop: ora cont1team,x, X + 1, X + 1, ...
	ora.w cont1team,x				;collect the teams
	inx
	inx
	cpx.w #$000A					;5 pads
	bcc .loopx
	bit.w #$0001					;someone on home?
	beq .t1xxxxx					;no: need a player
	jsl.l FigureJoy					;set the pads
.1xxx:								; if OptPlayMode != $0004 go to .3x, ...
	lda.l OptPlayMode				;play mode
	cmp.w #$0004					;shootout?
	bne .3x							;no: done
	ldx.w #$0005					;pad 5
.loop2:								; loop: if cont1team,y = 0 go to .2x, ...
	txa
	asl a							;word index
	tay
	lda.w cont1team,y				;its team
	beq .2x							;not playing
	sta.b r3						;r3 = team
	txa
	dec a							;pads before it
	sta.b r3+2
.loop3:								;each earlier pad
	lda.b r3+2
	asl a
	tay								;its team
	lda.w cont1team,y				;same team?
	cmp.b r3						;yes: one per team
	beq .t2xx
	dec.b r3+2						;earlier pad
	bpl .loop3						;all
.2x:								; X - 1, if X not yet 0 go to .loop2
	dex
	bne .loop2						;all
.3x:								; mp5readall = 0, return
	stz.w mp5readall				;stop reading every pad
	rtl

.t1xxxxx:							; a1 = AtLeastOnePersonMustTxt, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #AtLeastOnePersonMustTxt>>16
	sta.b a1+2
	lda.w #AtLeastOnePersonMustTxt
	sta.b a1
	jsl.l print						; print AtLeastOnePersonMustTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayInPlayoffModeTxt>>16
	sta.b a1+2
	lda.w #PlayInPlayoffModeTxt
	sta.b a1
	jsl.l print						; print PlayInPlayoffModeTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l QueueTextDMA				; queue the changed part of the text map for transfer to video memory
	jsl.l WaitPadsRelease			;wait for release
	bra .4x

.t2xx:								; cont1team,y = r3: a1 = OnlyOnePlayerPerTeamTxt, call print, a1 = pull...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #OnlyOnePlayerPerTeamTxt>>16
	sta.b a1+2
	lda.w #OnlyOnePlayerPerTeamTxt
	sta.b a1
	jsl.l print						; print OnlyOnePlayerPerTeamTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #IsAllowedInShootoutTxt>>16
	sta.b a1+2
	lda.w #IsAllowedInShootoutTxt
	sta.b a1
	jsl.l print						; print IsAllowedInShootoutTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l QueueTextDMA				; queue the changed part of the text map for transfer to video memory
	jsl.l WaitPadsRelease			;wait for release
.4x:								; loop: call ReadPads
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	ldx.w #$0008					;pad 5
.loopxx:							; loop: if mp5warning != 0 go to .1xxxx, ...
	lda.w mp5warning				;warning up?
	bne .1xxxx						;yes: skip
	lda.w PadRaw1,x					;held
	bit.w #$000F					;direction held?
	bne .1xxxx						;yes: skip
	and.w #$FFF0					;buttons held?
	bne .t1xxxxxx					;yes: redraw the help
.1xxxx:								; X - 1, X - 1, if X still >= 0 go to .loopxx, ...
	dex
	dex
	bpl .loopxx						;all
	bra .4x							;wait

.t1xxxxxx:							; a1 = UseToSelectTeamTxt2, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #UseToSelectTeamTxt2>>16
	sta.b a1+2
	lda.w #UseToSelectTeamTxt2
	sta.b a1
	jsl.l print						; print UseToSelectTeamTxt2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PressStartWhenDoneTxt2>>16
	sta.b a1+2
	lda.w #PressStartWhenDoneTxt2
	sta.b a1
	jsl.l print						; print PressStartWhenDoneTxt2
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l QueueTextDMA				; queue the changed part of the text map for transfer to video memory
.loopxxx:							; loop: falls through
	ldx.w #$0008					;pad 5
.loop2x:							; loop: if PadRaw1,x bit $000F set go to .1xxxxx, ...
	lda.w PadRaw1,x					;held
	bit.w #$000F					;direction?
	bne .1xxxxx						;yes: skip
	bit.w #$1000					;start?
	bne .loopxxx					;still held: wait
.1xxxxx:							; X - 1, X - 1, if X still >= 0 go to .loop2x, ...
	dex
	dex
	bpl .loop2x						;all
	jmp.w .4						;back to the loop
.6:									; if zero go to .9, ...
	bit.w #$0200					;left?
	beq .9							;no: right?
	lda.w cont1team,x				;team
	beq .8							;middle: to the visitors
	cmp.w #$0001					;home?
	bne .10							;no: stay
.7:									; cont1team,x = $0000, go to .10
	lda.w #$0000					;back to the middle
	sta.w cont1team,x
	bra .10
.8:									; cont1team,x = 0: if d1+2 != 0 go to .10, ...
	lda.b d1+2						;playoffs?
	bne .10							;yes: visitors locked
	lda.w #$0002					;visitors
	sta.w cont1team,x
	bra .10
.9:									; if zero go to .10, ...
	bit.w #$0100					;right?
	beq .10							;no
	lda.w cont1team,x				;team
	cmp.w #$0001					;already home?
	beq .10							;yes
	cmp.w #$0002					;visitors?
	beq .7							;yes: to the middle
	lda.w #$0001					;home
	sta.w cont1team,x
.10:								; X + 1, X + 1, if OptPlayMode != $0004 go to .1xxxxxx, ...
	inx
	inx
	lda.l OptPlayMode				;play mode
	cmp.w #$0004					;shootout?
	bne .1xxxxxx					;no: 5 pads
	cpx.w #$0004					;2 pads in a shootout
	bcs .t1xxxxxxx					;done
.1xxxxxx:							; if carry set go to .t1xxxxxxx, ...
	cpx.w #$000A					;5 pads?
	bcs .t1xxxxxxx					;done
	jmp.w .5						;next pad

.t1xxxxxxx:							; call SpriteFrameStart, setupvis = VisTeam, setuphome = HomeTeam, ...
	jsl.l SpriteFrameStart
	lda.w VisTeam					;visitors' picture
	sta.l setupvis
	lda.w HomeTeam					;home picture
	sta.l setuphome
	lda.b d1+2						;playoffs?
	beq .1xxxxxxx					;no
	lda.w #$001C					;visitors: none
	sta.l setupvis
.1xxxxxxx:							; a1 = PlayerSelectTitle, call PrintLetterSprites, call DrawMatchupPict...
	ldx.w #$0047					;x 71
	ldy.w #$0018					;y 24
	lda.w #PlayerSelectTitle>>16
	sta.b a1+2
	lda.w #PlayerSelectTitle
	sta.b a1
	jsl.l PrintLetterSprites		;title letters
	jsl.l DrawMatchupPictures		;pictures or logos
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.b p1
	pha								;keep p1
	lda.b p1+2
	pha
	lda.w #SpriteFrames>>16
	sta.b p1+2
	lda.w #SpriteFrames
	sta.b p1
	ldy.w #$0000					;first pad
.loopxxxx:							; loop: if mp5warning != 0 go to .2xx, ...
	phy
	lda.w mp5warning				;warning up?
	bne .2xx						;yes: no icon
	lda.w PadRaw1,y					;held
	and.w #$000F					;direction?
	bne .2xx						;yes: no icon
	tya								;pad number
	lsr a
	clc
	adc.w #SPFpad+1-1				; DrawSprite index (frame - 1) of the controller's star
	sta.b r0						;sprite
	lda.b d1+2						;playoff flag
	asl a
	asl a							;x4
	clc
	adc.w cont1team,y				;plus the team
	asl a							;word index
	tax
	lda.l .11,x						;x of the icon
	pha
	tyx								;pad
	lda.l .12,x						;y of the icon
	tay
	plx
	lda.w #$2600					;palette 3
	jsl.l DrawSprite				;draw the star
	ply								;pad
	phy
	tya								;pad number
	lsr a
	clc
	adc.w #SPFsmallfont+1-1			; DrawSprite index (frame - 1) of the controller number
	sta.b r0						;sprite
	lda.b d1+2						;playoff flag
	asl a
	asl a							;x4
	clc
	adc.w cont1team,y				;plus the team
	asl a							;word index
	tax
	lda.l .11,x						;x
	pha
	tyx								;pad
	lda.l .12,x						;y
	tay
	plx
	dey
	dey
	dex
	dex
	dex
	lda.w #$2000					;palette 0
	jsl.l DrawSprite				;draw the number
.2xx:								; Y + 1, Y + 1, if OptPlayMode != $0004 go to .3xx, ...
	ply
	iny
	iny
	lda.l OptPlayMode				;play mode
	cmp.w #$0004					;shootout?
	bne .3xx						;no: 5 pads
	cpy.w #$0004					;2 pads
	bcs .4xx
.3xx:								; if carry clear go to .loopxxxx
	cpy.w #$000A					;5 pads?
	bcc .loopxxxx					;no: next
.4xx:								; p1+2 = pulled value, p1 = pulled value, call WaitFrame, ...
	pla
	sta.b p1+2						;restore p1
	pla
	sta.b p1
	jsl.l WaitFrame
	jsl.l SpriteFrameEnd
	jmp.w .4						;next frame
.11:								;icon x by team (middle, home, visitors), normal then playoffs
	dw $0080,$00D0,$0030,$0000,$0030,$00D0,$009C,$0000
.12:								;icon y of each pad, the rest off the screen
	dw $0068,$007C,$0090,$00A4,$00B8,$0100,$0100,$0100
	dw $0100,$0100,$0100,$0100,$0100,$0100,$0100,$0100
	dw $0100,$0100,$0100,$0100,$0100,$0100,$0100,$0100
	dw $0100,$0100,$0100,$0100,$0100,$0100,$0100,$0100
	dw $0100,$0100,$0100,$0100,$0100
