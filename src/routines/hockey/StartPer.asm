; Start a period: reset the teams, the rink and the clock, then the game loop
StartPer:							; called from PeriodOver, PlayShootout, StartGame_go
	lda.w shootoutmode
	bne .1
	lda.w #$1FFF
	tcs
.1:									; a2 = 0, call reenergizeteam, a2 = $0002, ...
	stz.b a2
	jsl.l reenergizeteam			; give every player of team a2 full energy
	lda.w #$0002
	sta.b a2
	jsl.l reenergizeteam			; give every player of team a2 full energy
	stz.w reloadtime
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jsl.l setupice_reset
	jsl.l ResetClock
	jsl.l InitCrowdExcite			; set the crowd excitement for a new period
	lda.w pregamepause
	beq .4
	lda.w #$FFFF
	sta.w pausepad
	ldy.w #$FFFE
.loop:								; loop: Y + 1, Y + 1, if carry set go to .2, ...
	iny
	iny
	cpy.w #$000A
	bcs .2
	lda.w cont1team,y
	beq .loop
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.w pausepad
.2:									; ora cont2team, ora cont3team, ora cont4team, ...
	lda.w cont1team
	ora.w cont2team
	ora.w cont3team
	ora.w cont4team
	ora.w cont5team
	bne .3
	stz.w pausepad
.3:									; call startpause
	jsl.l startpause				; set the pause mode flag and return
.4:									; a3 = $001C, fox = $0000, foy = $0000, ...
	ldx.w #$001C
	stx.b a3
	lda.w #$0000
	sta.l fox
	sta.l foy
	lda.w #$001B
	sta.b d0
	jsl.l assreplace
	jsl.l ClearTextMap				; fill the text map with the blank tile
	lda.w #$0400
	tsb.w sflags
	lda.w #$FFFF
	sta.w recsfx
	sta.w recsfx2
	sta.w percue
	lda.l OptPlayMode
	cmp.w #$0004
	beq .t1
	lda.w #$0010
	trb.w sflags
	lda.w #replaystart>>16
	sta.w recbpr+2
	lda.w #replaystart
	sta.w recbpr
	bra .5

.t1:								; OptPlayMode = $0004: if pregamepause != 0 go to .5, ...
	lda.w pregamepause
	bne .5
	stz.w percue
.5:									; textdirtylo = $FFFF, textdirtyhi = 0, Vcount = 0, ...
	lda.w #$FFFF
	sta.w textdirtylo
	stz.w textdirtyhi
	stz.b Vcount
	stz.b Vcount+2
	stz.w lastframevc
	stz.w OldVcount
	ldx.w #$0000
	ldy.w #$01C0
	lda.w #$6000
	jsl.l InitSprites
	lda.w shootoutmode
	beq Gameloop
	rtl
