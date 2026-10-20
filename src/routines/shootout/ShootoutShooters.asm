; Shootout shooters menu item: pick the 3 shooters of each team
ShootoutShooters:					; called from PauseShootoutSetup
	jsl.l GetPauseTeam
	lda.w #$0001
	sta.b d0
	lda.b a2
	beq .team
	lda.w #$0002
	sta.b d0
.team:								; if cont1team = d0 go to .t1, ...
	lda.w cont1team
	cmp.b d0
	beq .t1
	lda.w cont2team
	cmp.b d0
	beq .t1
	jmp.w ShootersExit

.t1:								; setupvis = HomeTeam,x, setuphome = $FFFF, call SetupScreen, ...
	ldx.b a2
	lda.w HomeTeam,x
	sta.l setupvis
	lda.w #$FFFF
	sta.l setuphome
	jsl.l SetupScreen
	jsl.l ShootersSetup
	jsl.l SendColours
	jsl.l ShootersBackground
	stz.w curitem
	lda.w #$0001
	sta.w SelectedPlayerIdx
	stz.w DispAttribCtr
	jsl.l PrintShooterNames
	lda.w #$0005
	ldx.w #$0050
	jsl.l SetupBandIRQ
	jsl.l MenuScreenHDMA
	jsl.l ScreenOn
ShootersLoop:						; called from ShootersNext
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads
	jsl.l ReadPausePad
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$0800
	bne ShootersUp
	bit.w #$0400
	bne ShootersDown
	bit.w #$8080
	bne ShootersPick
	bit.w #$1000
	bne ShootersExit
ShootersNext:						; called from ShootersDown, ShootersPick, ShootersUp
	bra ShootersLoop
ShootersExit:						; called from ShootersLoop, ShootoutShooters
	ldy.b a2
	bne .t1
	sep #$20
	lda.w homeshooters
	rep #$20
	bra ShootersSetGoalie

.t1:								; a2 != 0: falls through
	sep #$20
	lda.w awayshooters
	rep #$20
ShootersSetGoalie:					; called from ShootersExit
	and.w #$00FF
	dec a
	sta.w tmgoalie,y
	rtl
ShootersUp:							; called from ShootersLoop
	lda.w curitem
	beq ShootersNext
	dec.w curitem
	jsl.l PrintShooterNames
	bra ShootersNext
ShootersDown:						; called from ShootersLoop
	lda.w curitem
	cmp.w #$0005
	bpl ShootersNext
	inc.w curitem
	jsl.l PrintShooterNames
	bra ShootersNext
ShootersPick:						; called from ShootersLoop
	jsl.l PickShooterRow
	jsl.l PrintShooterNames
	bra ShootersNext
ShootersSetup:						; called from ShootoutShooters
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShootoutShootersPos>>16
	sta.b a1+2
	lda.w #ShootoutShootersPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$000D
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShootoutShootersPos2>>16
	sta.b a1+2
	lda.w #ShootoutShootersPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0800
	sta.w printa
	lda.w #$000E
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l FramerOutline
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #LineupTxt>>16
	sta.b a1+2
	lda.w #LineupTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l ShootersBackground
	rtl
