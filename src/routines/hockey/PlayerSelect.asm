; The player select screen after the game setup: each pad moves its icon under the visitors or home team
; (cont1team-cont5team), start goes on
PlayerSelect:						; called from setoptions
	stz.w cont1team
	stz.w cont2team
	stz.w cont3team
	stz.w cont4team
	stz.w cont5team
	lda.l notdemo
	bne .t1
	rtl

.t1:								; notdemo != 0: mp5readall = $FFFF, call FadeOut, call WaitFadeOut, ...
	lda.w #$FFFF
	sta.w mp5readall
	jsl.l FadeOut
	jsl.l WaitFadeOut
	jsl.l forceblack
	sep #$20
	lda.b #$09
	sta.w BGMODE
	lda.b #$08
	sta.w BG3SC
	lda.b #$04
	sta.w BG34NBA
	lda.b #$17
	sta.w TM
	rep #$20
	lda.w #$FFFC
	sta.w BG3VScroll
	lda.w #screenmap>>16
	sta.b p1+2
	lda.w #screenmap+6
	sta.b p1
	lda.w #$0000
	ldx.w #$0800
	jsl.l MemFill
	lda.w #screenmap>>16
	sta.b p0+2
	lda.w #$A676
	sta.b p0
	lda.w #$0000
	ldx.w #$0800
	ldy.w #$0800
	jsl.l DMAToVRAM
	jsl.l MenuScreenHDMA
	jsl.l ScreenOn
	jsl.l FadeIn
	lda.w #$000A
	sta.w fadestep
	stz.b d1
	stz.b d1+2
	lda.l OptPlayMode
	cmp.w #$0001
	bcc .2
	cmp.w #$0004
	bcs .2
	lda.w #$0001
	sta.w cont1team
	jsl.l FigureJoy
	lda.w cont1team
	dec a
	beq .1
	lda.w VisTeam
	sta.w HomeTeam
.1:									; decrement d1, increment d1+2
	dec.b d1
	inc.b d1+2
.2:									; cont1team = $0001
	lda.w #$0001
	sta.w cont1team
.3:									; call ClearTextMapBottom, call ClearBigText
	lda.b d1
	pha
	jsl.l ClearTextMapBottom
	jsr.w ClearBigText
	ldx.w #$0000
	lda.w #$0000
.loop:								; loop: bigtextbuf,x = A, X + 1, X + 1, ...
	sta.l bigtextbuf,x
	inx
	inx
	cpx.w #$0290
	bcc .loop
	lda.w #$FFFF
	sta.l redrawblocks
	lda.w #$0001
	sta.w printx
	lda.w #$000A
	sta.w printy
	lda.w VisTeam
	sta.b d1
	lda.b d1+2
	pha
	bne .1x
	jsr.w DrawSelectTeam
.1x:								; d1+2 = pulled value, printx = $0016, d1 = HomeTeam, ...
	pla
	sta.b d1+2
	lda.w #$0016
	sta.w printx
	lda.w HomeTeam
	sta.b d1
	jsr.w DrawSelectTeam
	jsr.w SendBigText
	jsl.l SendTextMap
	pla
	sta.b d1
	lda.w #PlayerMarkerPalette>>16
	sta.b p0+2
	lda.w #PlayerMarkerPalette
	sta.b p0
	ldy.w #$0090
	ldx.w #$0010
	jsl.l SetColours
	lda.b d1+2
	beq .t1x
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #NotTxt>>16
	sta.b a1+2
	lda.w #NotTxt
	sta.b a1
	jsl.l print
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
	jsl.l print
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
	jsl.l print
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
	jsl.l print
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
	jsl.l print
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
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l QueueTextDMA
.4:									; call WaitFrame, eor d2, if not zero go to .t5, ...
	jsl.l WaitFrame
	ldx.w mp5warning
	txa
	eor.b d2
	bne .t5
	jmp.w .t6

.t5:								; d2 = X, if zero go to .t4, ...
	stx.b d2
	txa
	beq .t4
	bit.w #$0001
	bne .t1xx
	bit.w #$0002
	bne .t2x
	bit.w #$0004
	bne .t3
	bra .t6

.t1xx:								; call RedrawPlayerSelect, call Multi5SocketMsg, go to .t6
	jsl.l RedrawPlayerSelect
	jsl.l Multi5SocketMsg
	bra .t6

.t2x:								; call RedrawPlayerSelect, call Multi5ScopeMsg, go to .t6
	jsl.l RedrawPlayerSelect
	jsl.l Multi5ScopeMsg
	bra .t6

.t3:								; call RedrawPlayerSelect, call Multi5MouseMsg, go to .t6
	jsl.l RedrawPlayerSelect
	jsl.l Multi5MouseMsg
	bra .t6

.t4:								; call Multi5Init, go to .3
	jsl.l Multi5Init
	jmp.w .3

.t6:								; if mp5warning = 0 go to .t1xxx, ...
	lda.w mp5warning
	beq .t1xxx
	jmp.w .4

.t1xxx:								; mp5warning = 0: call ReadPads
	jsl.l ReadPads
	ldx.w #$0000
.5:									; if mp5warning != 0 go to .1xx, ...
	lda.w mp5warning
	bne .1xx
	lda.w JoyPad,x
	and.w #$000F
	beq .t1xxxx
.1xx:								; cont1team,x = $0000, go to .10
	lda.w #$0000
	sta.w cont1team,x
	jmp.w .10

.t1xxxx:							; JoyPad,x & $000F = 0: if padnew,x bit $1000 set go to .t3x, ...
	lda.w padnew,x
	bit.w #$1000
	bne .t3x
	jmp.w .6

.t3x:								; padnew,x bit $1000 set: if d1+2 = 0 go to .1xxx, ...
	lda.b d1+2
	beq .1xxx
	ldx.w #$0000
	lda.w #$0000
.loopx:								; loop: ora cont1team,x, X + 1, X + 1, ...
	ora.w cont1team,x
	inx
	inx
	cpx.w #$000A
	bcc .loopx
	bit.w #$0001
	beq .t1xxxxx
	jsl.l FigureJoy
.1xxx:								; if OptPlayMode != $0004 go to .3x, ...
	lda.l OptPlayMode
	cmp.w #$0004
	bne .3x
	ldx.w #$0005
.loop2:								; loop: if cont1team,y = 0 go to .2x, ...
	txa
	asl a
	tay
	lda.w cont1team,y
	beq .2x
	sta.b r3
	txa
	dec a
	sta.b r3+2
.loop3:								; loop: if cont1team,y = r3 go to .t2xx, ...
	lda.b r3+2
	asl a
	tay
	lda.w cont1team,y
	cmp.b r3
	beq .t2xx
	dec.b r3+2
	bpl .loop3
.2x:								; X - 1, if X not yet 0 go to .loop2
	dex
	bne .loop2
.3x:								; mp5readall = 0, return
	stz.w mp5readall
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
	jsl.l print
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
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l QueueTextDMA
	jsl.l WaitPadsRelease
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
	jsl.l print
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
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l QueueTextDMA
	jsl.l WaitPadsRelease
.4x:								; loop: call ReadPads
	jsl.l ReadPads
	ldx.w #$0008
.loopxx:							; loop: if mp5warning != 0 go to .1xxxx, ...
	lda.w mp5warning
	bne .1xxxx
	lda.w JoyPad,x
	bit.w #$000F
	bne .1xxxx
	and.w #$FFF0
	bne .t1xxxxxx
.1xxxx:								; X - 1, X - 1, if X still >= 0 go to .loopxx, ...
	dex
	dex
	bpl .loopxx
	bra .4x

.t1xxxxxx:							; a1 = UseToSelectTeamTxt2, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #UseToSelectTeamTxt2>>16
	sta.b a1+2
	lda.w #UseToSelectTeamTxt2
	sta.b a1
	jsl.l print
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
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l QueueTextDMA
.loopxxx:							; loop: falls through
	ldx.w #$0008
.loop2x:							; loop: if JoyPad,x bit $000F set go to .1xxxxx, ...
	lda.w JoyPad,x
	bit.w #$000F
	bne .1xxxxx
	bit.w #$1000
	bne .loopxxx
.1xxxxx:							; X - 1, X - 1, if X still >= 0 go to .loop2x, ...
	dex
	dex
	bpl .loop2x
	jmp.w .4
.6:									; if zero go to .9, ...
	bit.w #$0200
	beq .9
	lda.w cont1team,x
	beq .8
	cmp.w #$0001
	bne .10
.7:									; cont1team,x = $0000, go to .10
	lda.w #$0000
	sta.w cont1team,x
	bra .10
.8:									; cont1team,x = 0: if d1+2 != 0 go to .10, ...
	lda.b d1+2
	bne .10
	lda.w #$0002
	sta.w cont1team,x
	bra .10
.9:									; if zero go to .10, ...
	bit.w #$0100
	beq .10
	lda.w cont1team,x
	cmp.w #$0001
	beq .10
	cmp.w #$0002
	beq .7
	lda.w #$0001
	sta.w cont1team,x
.10:								; X + 1, X + 1, if OptPlayMode != $0004 go to .1xxxxxx, ...
	inx
	inx
	lda.l OptPlayMode
	cmp.w #$0004
	bne .1xxxxxx
	cpx.w #$0004
	bcs .t1xxxxxxx
.1xxxxxx:							; if carry set go to .t1xxxxxxx, ...
	cpx.w #$000A
	bcs .t1xxxxxxx
	jmp.w .5

.t1xxxxxxx:							; call SpriteFrameStart, setupvis = VisTeam, setuphome = HomeTeam, ...
	jsl.l SpriteFrameStart
	lda.w VisTeam
	sta.l setupvis
	lda.w HomeTeam
	sta.l setuphome
	lda.b d1+2
	beq .1xxxxxxx
	lda.w #$001C
	sta.l setupvis
.1xxxxxxx:							; a1 = PlayerSelectTitle, call PrintLetterSprites, call DrawMatchupPict...
	ldx.w #$0047
	ldy.w #$0018
	lda.w #PlayerSelectTitle>>16
	sta.b a1+2
	lda.w #PlayerSelectTitle
	sta.b a1
	jsl.l PrintLetterSprites
	jsl.l DrawMatchupPictures
	jsl.l SendColours
	lda.b p1
	pha
	lda.b p1+2
	pha
	lda.w #SpriteFrames>>16
	sta.b p1+2
	lda.w #SpriteFrames
	sta.b p1
	ldy.w #$0000
.loopxxxx:							; loop: if mp5warning != 0 go to .2xx, ...
	phy
	lda.w mp5warning
	bne .2xx
	lda.w JoyPad,y
	and.w #$000F
	bne .2xx
	tya
	lsr a
	clc
	adc.w #SPFpad+1-1				; DrawSprite index (frame - 1) of the controller's star
	sta.b r0
	lda.b d1+2
	asl a
	asl a
	clc
	adc.w cont1team,y
	asl a
	tax
	lda.l .11,x
	pha
	tyx
	lda.l .12,x
	tay
	plx
	lda.w #$2600
	jsl.l DrawSprite
	ply
	phy
	tya
	lsr a
	clc
	adc.w #SPFsmallfont+1-1			; DrawSprite index (frame - 1) of the controller number
	sta.b r0
	lda.b d1+2
	asl a
	asl a
	clc
	adc.w cont1team,y
	asl a
	tax
	lda.l .11,x
	pha
	tyx
	lda.l .12,x
	tay
	plx
	dey
	dey
	dex
	dex
	dex
	lda.w #$2000
	jsl.l DrawSprite
.2xx:								; Y + 1, Y + 1, if OptPlayMode != $0004 go to .3xx, ...
	ply
	iny
	iny
	lda.l OptPlayMode
	cmp.w #$0004
	bne .3xx
	cpy.w #$0004
	bcs .4xx
.3xx:								; if carry clear go to .loopxxxx
	cpy.w #$000A
	bcc .loopxxxx
.4xx:								; p1+2 = pulled value, p1 = pulled value, call WaitFrame, ...
	pla
	sta.b p1+2
	pla
	sta.b p1
	jsl.l WaitFrame
	jsl.l SpriteFrameEnd
	jmp.w .4
.11:								; dw $0080,$00D0,$0030,$0000,$0030,$00D0,$009C,$0000
	dw $0080,$00D0,$0030,$0000,$0030,$00D0,$009C,$0000
.12:								; dw $0068,$007C,$0090,$00A4,$00B8,$0100,$0100,$0100, dw $0100,$0100,$0...
	dw $0068,$007C,$0090,$00A4,$00B8,$0100,$0100,$0100
	dw $0100,$0100,$0100,$0100,$0100,$0100,$0100,$0100
	dw $0100,$0100,$0100,$0100,$0100,$0100,$0100,$0100
	dw $0100,$0100,$0100,$0100,$0100,$0100,$0100,$0100
	dw $0100,$0100,$0100,$0100,$0100
