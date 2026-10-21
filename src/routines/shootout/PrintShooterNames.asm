; Shootout shooters: the shooters' names
PrintShooterNames:					;print the goalie and shooter rows, the row at the cursor (curitem) in
									;another palette
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintShooterNamesPos>>16
	sta.b a1+2
	lda.w #PrintShooterNamesPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$0013
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintShooterNamesPos2>>16
	sta.b a1+2
	lda.w #PrintShooterNamesPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l GoalieCount
	lda.b d0
	dec a
	sta.b d1
	lda.w #$0080
	sta.b a5+2
	lda.w #.7
	sta.b a5
	lda.w #$0080
	sta.b a3+2
	lda.w #.6
	sta.b a3
	lda.w SelectedPlayerIdx
	dec a
	sta.b d0
	bmi .2
	asl a
	asl a
	asl a
	sta.b d0
	lda.w #homeshooters>>16
	sta.b a3+2
	lda.w #homeshooters
	sta.b a3
	lda.b a2
	beq .1
	lda.w #awayshooters>>16
	sta.b a3+2
	lda.w #awayshooters
	sta.b a3
.1:									; a5+2 = $0080, a5 = .8, d1 = $0005
	lda.w #$0080
	sta.b a5+2
	lda.w #.8
	sta.b a5
	lda.w #$0005
	sta.b d1
.2:									; loop: printa = $3800, if not zero go to .5, ...
	lda.w #$3800
	sta.w printa
	lda.w #$0005
	sec
	sbc.b d1
	cmp.w curitem
	bne .5
	lda.w #$2000
	sta.w printa
	lda.b [a3]
	and.w #$00FF
	dec a
	sta.l matchuphome
	phx
	ldx.b a2
	lda.w HomeTeam,x
	cmp.w #$0018
	bcc .4
.3:									; p0+2 = p1+2, p0 = p1, call FreeFrameTiles
	ldx.w #$0000
	lda.l matchuphome
	lda.b p1+2
	sta.b p0+2
	lda.b p1
	sta.b p0
	jsl.l FreeFrameTiles
.4:									; falls through
	plx
.5:									; printx = $0005, a1+2 = a5+2, a1 = a5, ...
	lda.w #$0005
	sta.w printx
	lda.b a5+2
	sta.b a1+2
	lda.b a5
	sta.b a1
	jsl.l print
	lda.b a1+2
	sta.b a5+2
	lda.b a1
	sta.b a5
	lda.w #$0008
	sta.w printx
	lda.b [a3]
	and.w #$00FF
	dec a
	sta.b d0
	jsl.l PlayerNumName
	jsl.l print
	inc.b a3
	inc.w printy
	inc.w printy
	dec.b d1
	bmi .t1
	jmp.w .2

.t1:								; d1 counted below 0: call ShootersBackground, return
	jsl.l ShootersBackground
	rtl
.6:									; db $01,$02,$03,$04
	db $01,$02,$03,$04
.7:									; db $03,$00,$47,$03,$00,$47,$03,$00,$47,$03,$00,$47
	db $03,$00,$47,$03,$00,$47,$03,$00,$47,$03,$00,$47
.8:									; db $03,$00,$47,$03,$00,$31,$03,$00,$32,$03,$00,$33,$03,$00,$34,$03,$0...
	db $03,$00,$47,$03,$00,$31,$03,$00,$32,$03,$00,$33,$03,$00,$34,$03,$00,$35
