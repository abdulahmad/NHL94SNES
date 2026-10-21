; Shootout shooters menu item: pick the 3 shooters of each team
ShootoutShooters:					; called from PauseShootoutSetup
	jsl.l GetPauseTeam				;team that paused
	lda.w #$0001					;team 1
	sta.b d0						;d0 = the team
	lda.b a2						;which team?
	beq .team						;home: team 1
	lda.w #$0002					;team 2
	sta.b d0						;visitors: team 2
.team:								; if cont1team = d0 go to .t1, ...
	lda.w cont1team					;pad 1
	cmp.b d0						;pad 1
	beq .t1							;pad 1's team?
	lda.w cont2team
	cmp.b d0						;pad 2
	beq .t1							;pad 2's team?
	jmp.w ShootersExit				;not a pad's team: leave

.t1:								; setupvis = HomeTeam,x, setuphome = $FFFF, call SetupScreen, ...
	ldx.b a2						;team offset
	lda.w HomeTeam,x				;the team
	sta.l setupvis					;team in the block
	lda.w #$FFFF					;none
	sta.l setuphome					;no home block
	jsl.l SetupScreen				;set up the screen
	jsl.l ShootersSetup				;draw the frame and headers
	jsl.l SendColours				;send the colours
	jsl.l ShootersBackground		;the background
	stz.w curitem					;cursor on row 0
	lda.w #$0001
	sta.w SelectedPlayerIdx			;picked row 1
	stz.w DispAttribCtr				;first page of ratings
	jsl.l PrintShooterNames			;print the rows
	lda.w #$0005					;5 rows
	ldx.w #$0050					;line $50
	jsl.l SetupBandIRQ				;band IRQ
	jsl.l MenuScreenHDMA			;menu HDMA
	jsl.l ScreenOn					;screen on
ShootersLoop:						; called from ShootersNext
	jsl.l SendTextMap				;send the text map
	jsl.l WaitFrame					;wait for the frame
	jsl.l ReadPads					;read the pads
	jsl.l ReadPausePad				;the pause pad
	jsl.l ProcessInputWithRepeat	;presses with repeat
	lda.b d1						;new presses
	bit.w #$0800					;up?
	bne ShootersUp					;up: move up
	bit.w #$0400					;down?
	bne ShootersDown				;down: move down
	bit.w #$8080					;A or B?
	bne ShootersPick				;A or B: pick
	bit.w #$1000					;start?
	bne ShootersExit				;start: leave
ShootersNext:						; called from ShootersDown, ShootersPick, ShootersUp
	bra ShootersLoop				;next frame
ShootersExit:						; called from ShootersLoop, ShootoutShooters
	ldy.b a2						;team offset
	bne .t1							;away team?
	sep #$20						;8-bit read
	lda.w homeshooters				;home goalie slot
	rep #$20
	bra ShootersSetGoalie			;set the goalie

.t1:								;away team
	sep #$20
	lda.w awayshooters				;away goalie slot
	rep #$20
ShootersSetGoalie:					; called from ShootersExit
	and.w #$00FF					;roster number
	dec a							;0-based
	sta.w tmgoalie,y				;tmgoalie of the team
	rtl								;set the team's goalie
ShootersUp:							; called from ShootersLoop
	lda.w curitem					;cursor row
	beq ShootersNext				;at the top: stay
	dec.w curitem					;move up
	jsl.l PrintShooterNames			;redraw the rows
	bra ShootersNext				;back to the loop
ShootersDown:						; called from ShootersLoop
	lda.w curitem					;cursor row
	cmp.w #$0005					;last row?
	bpl ShootersNext				;at the last row: stay
	inc.w curitem					;move down
	jsl.l PrintShooterNames			;redraw the rows
	bra ShootersNext				;back to the loop
ShootersPick:						; called from ShootersLoop
	jsl.l PickShooterRow			;pick the shooter of this row
	jsl.l PrintShooterNames			;redraw the rows
	bra ShootersNext				;back to the loop
ShootersSetup:						; called from ShootoutShooters
	lda.b a1+2						;save a1
	pha
	lda.b a1
	pha
	lda.w #ShootoutShootersPos>>16	;header position
	sta.b a1+2
	lda.w #ShootoutShootersPos
	sta.b a1
	jsl.l print						;print the header position
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020					;$20 columns
	sta.b d0
	lda.w #$000D					;$D rows
	sta.b d1
	lda.l blankchar					;blank tile
	sta.b d2
	jsl.l eraser					;clear the list area
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShootoutShootersPos2>>16	;second header position
	sta.b a1+2
	lda.w #ShootoutShootersPos2
	sta.b a1
	jsl.l print						;print the second header
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0800
	sta.w printa					;palette $0800
	lda.w #$000E
	sta.b d0						;$E columns
	lda.w #$0003
	sta.b d1						;3 rows
	jsl.l FramerOutline				;draw the outline
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #LineupTxt>>16			;"Lineup"
	sta.b a1+2
	lda.w #LineupTxt
	sta.b a1
	jsl.l print						;print "Lineup"
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l ShootersBackground		;the background, title and team block
	rtl
