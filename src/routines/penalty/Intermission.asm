; Between periods: the scores of the other games, then the highlights
;
; The pause screen between periods: the scores of the other games of the round on the ticker, then the
; highlights. Starts the score ticker (Intermission_ticker), sets the pause controller, then redraws the screen
; until Pausemode_menu returns zero. Called from PeriodOver.
Intermission:						; the intermission screen
	jsl.l SetupTeamForIntermission	; set up the two teams
	lda.w #$0000
	ldy.w #$001E					; clear Xpos of the 16 objects
.loop:								; clear the X positions of the 16 objects
	sta.w Xpos,y
	dey
	dey
	bpl .loop
	lda.b Vcount					; vcountmark = the frame counter (32 bits)
	ldy.b Vcount+2
	sta.w vcountmark				; remember the frame counter
	sty.w vcountmark+2
	lda.w #$0001					; clear flag bit 0 (pause mode) of sflags
	trb.w sflags					; clear the first flag bit of sflags
	lda.w gsp						; the gsp value
	cmp.w #$0004
	beq .t1							; both branches go to .t1
	bra .t1

.t1:								; set up the screen
	lda.w #$0708					; pause timer: $708 frames
	sta.w pausetimer
	lda.w #$0001					; demo mode while the screen is up
	sta.w demoflag					; demo mode while the screen is up
	lda.b Vcount					; ticker clock = frame counter - $150
	sec
	sbc.w #$0150					; ticker clock = frame counter - $150
	sta.w tickervc
	jsl.l Intermission_ticker				; start the score ticker
	lda.w TickerNum					; remember the first ticker game
	sta.l tickerstart
	stz.w psfirst					; no pause menu item yet
	stz.w psitem
	lda.w #$FFFF					; pausepad = $FFFF: no controller
	sta.w pausepad
	ldy.w #$FFFE					; y = -2: the loop starts at pad 0
.loopx:								; look for the first pad with a team
	iny
	iny
	cpy.w #$000A					; only pads 0 to 4
	bcs .1
	lda.w cont1team,y				; team on that pad
	beq .loopx						; none: next pad
	eor.w #$FFFF					; pausepad = minus the team word
	inc a
	sta.w pausepad
.1:									; end of the pad search
	lda.w cont1team					; teams of the five pads
	ora.w cont2team
	ora.w cont3team
	ora.w cont4team
	ora.w cont5team
	bne .2							; some pad is used: keep pausepad
	stz.w pausepad					; else pausepad = 0
.2:									; InIntermission = $0001
	lda.w #$0001					; InIntermission = 1
	sta.w InIntermission			; ticker starts from the current game
.loop2:								; redraw the screen
	lda.w #$0000					; clear the X positions of the 16 objects
	ldy.w #$001E					; clear Xpos of the 16 objects again
.loop3:								; clear loop
	sta.w Xpos,y
	dey
	dey
	bpl .loop3
	lda.b a1+2						; print the title string at IntermissionPos
	pha
	lda.b a1
	pha
	lda.w #IntermissionPos>>16
	sta.b a1+2
	lda.w #IntermissionPos+5
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0016					; frame $16 wide
	sta.b d0
	lda.w #$0007					; frame 7 high
	sta.b d1
	jsl.l Framer					; draw the frame
	jsl.l printscores1				; print the scores of the other games
	jsl.l Pausemode_menu					; run the pause menu
	bne .loop2						; nonzero: redraw
	lda.w #$0000					; pause menu off
	sta.l pausemenuon
	stz.w InIntermission			; intermission over
	stz.w demoflag					; demo mode off
Intermission_rtl:					; return
	rtl
