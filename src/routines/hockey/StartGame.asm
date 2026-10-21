; Reset the game state for a new game, then start the first period
StartGame:							; called from GameOver, Restart
	jsl.l PlayoffScreen				; the playoff tree screen
StartGame_scout:					; called from GameOver
	jsl.l Create_HotCold_Table		; fill HotColdTable with random values -12 to 12
	jsl.l ScoutingReport			; the scouting report screen: both teams
StartGame_go:						; called from PlayShootout
	lda.w #$FFFF
	sta.w FrameByNumber
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	ldx.w #$0AD7
	lda.w #$0000
.loop:								; loop: r0,x = A, X + 1, if not zero go to .loop, ...
	sta.b r0,x
	inx
	cpx.w #$1A11
	bne .loop
	ldx.w #$30F4
.loop2:								; loop: Ram7E,x = A, X + 1, if not zero go to .loop2, ...
	sta.l Ram7E,x
	inx
	cpx.w #$3479
	bne .loop2
	lda.l gamesstarted
	inc a
	sta.l gamesstarted
	stz.w gmode
	lda.l OptPen
	cmp.w #$0001
	bne .1
	lda.w #$0020
	tsb.w gmode
.1:									; call clearTeamStats, call restoreteams, call InitScores, ...
	jsl.l clearTeamStats			; clear the team stats and set up the teams
	jsl.l restoreteams				; all players of both teams on the bench
	jsl.l InitScores				; random scores for the other games of the round
	lda.w #ReplayBufferStart>>16
	sta.w ReplayBufferPtr+2
	lda.w #ReplayBufferStart
	sta.w ReplayBufferPtr
	lda.w #$0010
	trb.w sflags
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
	lda.l OptGoalie
	sta.w goaliemode1
	sta.w goaliemode2
	lda.w #$0001
	sta.w tmtimeouts
	sta.w tmtimeouts+2
	stz.w penshot
	stz.w penshotlive
	stz.w lastperiod
	lda.w #$0001
	sta.l newperiod
	stz.w teampads
	stz.w teampads+2
	ldx.w #$0008
.2:									; if cont1team,x != $0001 go to .t1, ...
	lda.w cont1team,x
	cmp.w #$0001
	bne .t1
	inc.w teampads
	bra .3

.t1:								; cont1team,x != $0001: if not zero go to .3, ...
	cmp.w #$0002
	bne .3
	inc.w teampads+2
.3:									; X - 1, X - 1, if X still >= 0 go to .2, ...
	dex
	dex
	bpl .2
	jsl.l setupice					; set up the rink screen
	stz.w pregamepause
	ldx.w #$0000
.loopx:								; loop: padside,x = cont1team,x - 1 * 2, X + 1, X + 1, ...
	lda.w cont1team,x
	dec a
	asl a
	sta.w padside,x
	inx
	inx
	cpx.w #$000A
	bcc .loopx
	ldx.w #$0000
.loop2x:							; loop: if cont1team,x != 0 go to .t1x, ...
	lda.w cont1team,x
	bne .t1x
	inx
	inx
	cpx.w #$000A
	bcc .loop2x
	bra .4

.t1x:								; cont1team,x != 0: pregamepause = $0001
	lda.w #$0001
	sta.w pregamepause
.4:									; BA_Sktr_SCnum = $FFFF, if shootoutmode = 0 go to StartPer, ...
	lda.w #$FFFF
	sta.w BA_Sktr_SCnum
	lda.w shootoutmode
	beq StartPer
	rtl
