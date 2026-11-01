; Team roster for the team in a2. Y switches team, start leaves.
; Takes a2 = team offset. Draws the roster screen (title, frames, team blocks, line and column) and then loops
; on the pads: start leaves, Y switches team, left/right change the attribute column, up/down change the
; line (0-7).
;
; Called from PauseTeamRoster.
TeamRoster:							; roster screen of a team
	jsl.l GetPauseTeam				; team of the pause controller
	ldy.b a2
	lda.w tmline,y
	inc a
	sta.b d0
	sta.w SelectedPlayerIdx
	stz.w DispAttribCtr
	ldx.b a2
	lda.w HomeTeam,x
	sta.l setupvis
	lda.w #$001D
	sta.l setuphome
	jsl.l SetupScreen				; common setup of the stats screens
	ldx.w #$004C
	ldy.w #$0018
	lda.w #TeamRosterTitle>>16
	sta.b a1+2
	lda.w #TeamRosterTitle
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites TeamRosterTitle
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	jsl.l MenuScreenHDMA			; start the window and COLDATA HDMA
	jsl.l ScreenOn
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.l blankchar
	clc
	adc.l charofs
	ldx.w #$0800
	jsl.l MemFill					; fill X bytes at [p1] with the word A
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayerRatingTxt>>16
	sta.b a1+2
	lda.w #PlayerRatingTxt
	sta.b a1
	jsl.l print						; print PlayerRatingTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0800
	sta.w printa
	lda.w #$000F
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l FramerOutline
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #TeamRosterPos>>16
	sta.b a1+2
	lda.w #TeamRosterPos
	sta.b a1
	jsl.l print						; print TeamRosterPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0800
	sta.w printa
	lda.w #$000F
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l FramerOutline
TeamRosterRedraw:					; redraw the screen for the team in a2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #TeamRosterPos2>>16
	sta.b a1+2
	lda.w #TeamRosterPos2
	sta.b a1
	jsl.l print						; print TeamRosterPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w HomeTeam
	sta.b d1
	lda.b a2
	beq .1
	lda.w VisTeam
	sta.b d1
	lda.w #$0030
.1:									; home team blocks; for the visitors d0 = $30
	sta.b d0
	jsl.l DrawTeamBlocks			; entry: the block of team d1
	jsl.l SpriteFrameEnd
	lda.w #$7F97
	sta.l colourbuf+2
	lda.w #$FFFF
	sta.l colourbuf+$42
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	jsl.l ShowRosterLine			; print the roster line with the chosen attribute
TeamRosterLoop:						; main loop: read the pads
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l getpzjoy					; ReadjoyA for the controller that owns the pause menu
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
	lda.b d1
	bit.w #$1000					; start button
	beq .t1
	jmp.w RosterRtl					; shared return of the roster routines

.t1:								; not start
	bit.w #$4000					; Y button: switch team
	bne SwapRosterTeam
	stz.b d0
	inc.b d0
	bit.w #$0100					; right: next column
	bne MoveRosterColumn
	dec.b d0
	dec.b d0
	bit.w #$0200					; left: previous column
	bne MoveRosterColumn
	bit.w #$0800					; up: previous line
	bne .1
	inc.b d0
	inc.b d0
	bit.w #$0400					; down: next line
	beq TeamRosterShowLine
.1:									; up / down: new line = line + step
	lda.b d0
	clc
	adc.w SelectedPlayerIdx
	sta.b d0
	bmi TeamRosterShowLine
	cmp.w #$0008					; only lines 0-7
	bcs TeamRosterShowLine
	sta.w SelectedPlayerIdx
	jsl.l ShowRosterLine			; print the roster line with the chosen attribute
TeamRosterShowLine:					; back to the main loop
	jmp.w TeamRosterLoop			; main loop: read the pads
