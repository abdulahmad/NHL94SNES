; Save the registers and go on to StartHL2
SaveRegsStartHL2:					; called from DoHiLights
	stx.b xsave
	ldx.w #$0000
.loop:								; loop: X + 1, X + 1, if not zero go to .loop, ...
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .loop
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.loop2:								; loop: X + 1, X + 1, if not zero go to .loop2, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .loop2
	ldx.b xsave
StartHL2:							; entry point, no direct callers found
	lda.w sflags3
	bit.w #$0008
	beq .t1
	jmp.w .15

.t1:								; sflags3 bits $0008 clear: call .18, d3 = d1, call NewTicker3, ...
	jsl.l .18
	lda.b d1
	sta.b d3
	jsl.l NewTicker3
	lda.w sflags3
	bit.w #$0008
	beq .t3
	jmp.w .14

.t3:								; sflags3 bits $0008 clear: printx = $0004, printy = $0014, d0 = $0018...
	lda.w #$0004
	sta.w printx
	lda.w #$0014
	sta.w printy
	lda.w #$0018
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer
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
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$00B4
	sta.b d0
	jsl.l waitxsr
	lda.b d3
	bit.w #$1000
	beq .t1x
	jmp.w .14

.t1x:								; d3 bits $1000 clear: padchangeany = 0, call FadeOut, call WaitFadeOut...
	stz.w padchangeany
	jsl.l FadeOut
	jsl.l WaitFadeOut
	jsl.l forceblack
	jsl.l FadeOutSound
	lda.w sndbank					;the sample set loaded in the SPC
	cmp.w #SoundBankGame
	beq .1							;already loaded
	jsl.l SPCGameUpload
.1:									; HomeTeam = gst1,x, VisTeam = gst2,x, call clearTeamStats, ...
	ldx.b a0
	lda.l gst1,x
	sta.w HomeTeam
	lda.l gst2,x
	sta.w VisTeam
	lda.b a0
	pha
	lda.b a0+2
	pha
	jsl.l clearTeamStats
	jsl.l restoreteams
	lda.w #$0000
	sta.b a2
	jsl.l LoadTeamLines
	lda.w #$0002
	sta.b a2
	jsl.l LoadTeamLines
	stz.b a2
	jsl.l reenergizeteam
	lda.w #$0002
	sta.b a2
	jsl.l reenergizeteam
	jsl.l LoadCenterIce
	ldx.w #$0008
	lda.w #$FFFF
.loop:								; loop: c1playernum,x = A, padside,x = A, X - 1, ...
	sta.w c1playernum,x
	sta.w padside,x
	dex
	dex
	bpl .loop
	stz.w cont1team
	stz.w cont2team
	stz.w cont3team
	stz.w cont4team
	stz.w cont5team
	lda.w #$0078
	jsl.l randoma8
	adc.w #$0078
	sta.w gameclock
	pla
	sta.b a0+2
	pla
	sta.b a0
	lda.b a0
	pha
	lda.b a0+2
	pha
	ldx.b a0
	lda.l gsper,x
	dec a
	sta.w gsp
	lda.l gss1,x
	sta.w tmscore
	lda.l gss2,x
	sta.w tmscore+2
	lda.w #$0010
	sta.w gmode
	stz.w gmclock
	lda.w gsp
	lsr a
	bcc .2
	lda.w #$0002
	tsb.w gmode
.2:									; sflags3 = 0, sflags = $0400, sfhormode = 0, ...
	stz.w sflags3
	lda.w #$0400
	sta.w sflags
	stz.w sfhormode
	stz.w iflags
	lda.w #$FFFF
	sta.w RefCnt
	sta.w puckcross+pcframes
	sta.w puckcross+pcsize+pcframes
	jsl.l setupice_reset
	jsl.l ClrHor
	stz.w Vpos
	stz.w Hpos
	jsl.l ResetBench
	stz.b a2
	jsl.l .16
	lda.w #$0002
	sta.b a2
	jsl.l .16
	jsl.l resetplstuff
	lda.w #$0000
	sta.l hattrick
	lda.w #$000B
	sta.b d0
	lda.w #.20>>16
	sta.b a0+2
	lda.w #.20
	sta.b a0
	stz.b a1
.loop2:								; loop: d1 = position,x, if pfgoal,x != 0 go to .3, ...
	ldx.b a1
	lda.w position,x
	sta.b d1
	lda.w pfgoal,x
	bne .3
	lda.b d1
	clc
	adc.w #$0006
	sta.b d1
.3:									; asl d1, asl d1, Xpos,x = [a0],y, ...
	asl.b d1
	asl.b d1
	ldy.b d1
	lda.b [a0],y
	sta.w Xpos,x
	iny
	iny
	lda.b [a0],y
	sta.w Ypos,x
	stz.w Xvel,x
	stz.w Yvel,x
	inc.b a1
	inc.b a1
	dec.b d0
	bpl .loop2
	lda.w puckc
	bpl .4
	lda.w #$000C
	jsl.l randoma
	asl a
	sta.w puckc
.4:									; if position,x != 0 go to .5, ...
	tax
	lda.w position,x
	bne .5
	dex
	dex
	txa
	sta.w puckc
.5:									; call SprSort, oldvcount = vcount
	jsl.l SprSort
org $9F9001
	lda.w #$00B4
	pha
	lda.b vcount
	sta.w oldvcount
.loop3:								; loop: if vcount = oldvcount go to .loop3, ...
	lda.b vcount
	cmp.w oldvcount
	beq .loop3
	tax
	sec
	sbc.w oldvcount
	sta.b d7
	sta.w timestep
	asl a
	sta.w impactstep
	asl a
	asl a
	asl a
	sta.w velstep
	asl a
	sta.w gravstep
	asl a
	adc.w gravstep
	sta.w gravstep
	stx.w lastframevc
	stx.w oldvcount
	jsl.l ReadPads
	lda.w sflags
	bit.w #$0001
	bne .7
	lda.w gmclock
	bne .7
	ldx.b d7
.loop4:								; loop: if gameclock = 0 go to .6, ...
	lda.w gameclock
	beq .6
	lda.w gameclock+2
	sec
	sbc.w #$0AAA
	sta.w gameclock+2
	bcs .6
	dec.w gameclock
.6:									; X - 1, if X not yet 0 go to .loop4
	dex
	bne .loop4
.7:									; call DoGameFrame, d7 = pulled value, timestep = pulled value, ...
	lda.b d7
	pha
	jsl.l DoGameFrame
	pla
	sta.b d7
	sta.w timestep
	lda.w gmclock
	beq .8
	pla
	sec
	sbc.b d7
	pha
	bmi .9
.8:									; call ReadAnyPad, if d1 bits $9080 clear go to .loop3, ...
	jsl.l ReadAnyPad
	lda.b d1
	bit.w #$9080
	beq .loop3
	lda.w tmscore
	cmp.w tmscore+2
	bne .9
	jsl.l RandomWord
	and.w #$0002
	tax
	inc.w tmscore,x
.9:									; a0+2 = pulled value, a0 = pulled value, call FadeOutSound, ...
	pla
	pla
	sta.b a0+2
	pla
	sta.b a0
	jsl.l FadeOutSound
	ldx.b a0
	lda.w tmscore
	sta.l gss1,x
	lda.w tmscore+2
	sta.l gss2,x
	jsl.l SetupTeamForIntermission
	ldx.w #$0000
.loop5:								; loop: Xpos,x = $FF10, Ypos,x = 0, frame,x = $0001, ...
	lda.w #$FF10
	sta.w Xpos,x
	stz.w Ypos,x
	lda.w #$0001
	sta.w frame,x
	inx
	inx
	cpx.w #$0018
	bcc .loop5
	jsl.l FadeOut
	jsl.l WaitFadeOut
	jsl.l forceblack
	jsl.l .19
	jsl.l setplayercolors
	jsl.l SetHor
	jsl.l SpriteFrameStart
	jsl.l setvideo
	jsl.l SpriteFrameEnd
.loop6:								; loop: if SoundFadeSpeed != 0 go to .loop6, ...
	lda.w SoundFadeSpeed
	bne .loop6
	lda.w MusicOn
	bne .loop6
	jsl.l SPCMenuUpload
	lda.l OptPlayMode
	beq .t2
	cmp.w #$0004
	beq .t2
	lda.l playoffRoundIdx
	cmp.w #$0002
	bcc .t2
	lda.w #PlayoffSong>>16
	sta.b p0+2
	lda.w #PlayoffSong
	sta.b p0
	jsl.l MusicStart
	bra .10

.t2:								; p0 = MenuSong, call MusicStart
	lda.w #MenuSong>>16
	sta.b p0+2
	lda.w #MenuSong
	sta.b p0
	jsl.l MusicStart
.10:								; a1 = SaveRegsStartHL2Pos, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #SaveRegsStartHL2Pos>>16
	sta.b a1+2
	lda.w #SaveRegsStartHL2Pos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0016
	sta.b d0
	lda.w #$0007
	sta.b d1
	jsl.l Framer
	jsl.l printscores1
	jsl.l Pmenu
	jsl.l FadeIn
	jsl.l ScreenOn
	stx.b xsave
	ldx.w #$001A
.loopx:								; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b a0,x
	dex
	dex
	bpl .loopx
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.loop2x:							; loop: d0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b d0,x
	dex
	dex
	bpl .loop2x
	ldx.b xsave
	ldx.b a3
	stx.b xsave
	ldx.w #$0000
.loop3x:							; loop: X + 1, X + 1, if not zero go to .loop3x, ...
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .loop3x
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.loop4x:							; loop: X + 1, X + 1, if not zero go to .loop4x, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .loop4x
	ldx.b xsave
	ldx.b a0
	lda.w #$0004
	sta.l gsper,x
	lda.l gss1,x
	cmp.l gss2,x
	bne .t1xx
	jmp.w StartHL2

.t1xx:								; gss1,x != gss2,x: gsper,x = $0005, d3 = d1, call NewTicker3, ...
	lda.w #$0005
	sta.l gsper,x
	lda.b d1
	sta.b d3
	jsl.l NewTicker3
	lda.w #$00B4
	sta.b d0
	jsl.l waitxsr
	lda.b d1
	bit.w #$1000
	beq .12
.11:								; tsb sflags3, go to .13
	lda.w #$0008
	tsb.w sflags3
	bra .13
.12:								; trb sflags3
	lda.w #$0008
	trb.w sflags3
.13:								; call LoadCenterIce, p0 = FaceOffTiles, p1+2 = $007F, ...
	jsl.l LoadCenterIce
	lda.w #FaceOffTiles>>16
	sta.b p0+2
	lda.w #FaceOffTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.l faceoffvrcset
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	tay
	jsl.l DMAToVRAM
	stx.b xsave
	ldx.w #$001A
.loopxx:							; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b a0,x
	dex
	dex
	bpl .loopxx
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.loop2xx:							; loop: d0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b d0,x
	dex
	dex
	bpl .loop2xx
	ldx.b xsave
	ldx.b a3
	rtl
.14:								; printx = $0004, printy = $0014, d0 = $0018, ...
	lda.w #$0004
	sta.w printx
	lda.w #$0014
	sta.w printy
	lda.w #$0018
	sta.b d0
	lda.w #$0003
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l .19
	jsl.l .17
	jmp.w .11
.15:								; call .17, go to .12
	jsl.l .17
	jmp.w .12
.16:								; subroutine: call reenergizeteam, call setpersonel, call forcepldata, ...
	jsl.l reenergizeteam
	jsl.l setpersonel
	jsl.l forcepldata
	ldy.b a2
	lda.w #$FFFF
	sta.w tmtouch1,y
	sta.w tmtouch2,y
	sta.w tmtouch3,y
	rtl
.17:								; subroutine: if gss1,x != gss2,x go to .1x, ...
	ldx.b a0
	lda.l gss1,x
	cmp.l gss2,x
	bne .1x
	jsl.l RandomWord
	and.w #$0001
	ldx.b a0
	pha
	clc
	adc.l gss1,x
	sta.l gss1,x
	pla
	eor.w #$0001
	adc.l gss2,x
	sta.l gss2,x
.1x:								; gsper,x = $0005, return
	lda.w #$0005
	sta.l gsper,x
	rtl
.18:								; subroutine: falls through
	ldx.w #$0000
.loopxxx:							; loop: hlsavebuf,x = OOlist+$10,x, X + 1, X + 1, ...
	lda.w OOlist+$10,x
	sta.l hlsavebuf,x
	inx
	inx
	cpx.w #$0781
	bcc .loopxxx
	lda.l ScoreSumbytes
	sta.l hlsavebuf,x
	inx
	inx
	stz.w tmgoalie
	stz.w tmgoalie+2
	stz.w teampads
	stz.w teampads+2
	lda.w #$FFFF
	ldx.w #$0000
.loop2xxx:							; loop: playerpad,x = A, X + 1, X + 1, ...
	sta.w playerpad,x
	inx
	inx
	cpx.w #$0018
	bcc .loop2xxx
	jsl.l ClearPenaltyBuffer
	rtl
.19:								; subroutine: falls through
	ldx.w #$0000
.loopxxxx:							; loop: OOlist+$10,x = hlsavebuf,x, X + 1, X + 1, ...
	lda.l hlsavebuf,x
	sta.w OOlist+$10,x
	inx
	inx
	cpx.w #$0781
	bcc .loopxxxx
	lda.l hlsavebuf,x
	inx
	inx
	sta.l ScoreSumbytes
	rtl
.20:								; dw 0,-240,-70,-140,20,-110,-100,-60,25,-40,70,-80, dw 0,240,34,90,-55...
	dw 0,-240,-70,-140,20,-110,-100,-60,25,-40,70,-80
	dw 0,240,34,90,-55,80,100,40,-10,10,-50,0
