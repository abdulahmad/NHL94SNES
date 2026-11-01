; Print the rows of the list from picktop, the row at the cursor (curplayer) in another palette
PrintShooterRows:					; called from PrintShooterList
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintShooterRowsPos>>16
	sta.b a1+2
	lda.w #PrintShooterRowsPos
	sta.b a1
	jsl.l print						; print PrintShooterRowsPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w SelectedPlayerIdx
	dec a
	asl a
	asl a
	asl a
	sta.b d0
	ldy.b a2
	lda.w picktop
	inc a
	sta.b a3
	lda.w #PlayerPositionText>>16
	sta.b a5+2
	lda.w #PlayerPositionText
	sta.b a5
	lda.w #$0008
	sta.b d1
	lda.w SelectedPlayerIdx
	sec
	sbc.w #$0005
	beq .3
	bmi .t1
	bvc .1
	bra .3

.t1:								; if overflow clear go to .3
	bvc .3
.1:									; decrement d1
	dec.b d1
.3:									; loop: printa = $3800, if d1 != curplayer go to .1x, ...
	lda.w #$3800
	sta.w printa
	lda.b d1
	cmp.w curplayer
	bne .1x
	lda.w #$2000
	sta.w printa
.1x:								; a5+2 = a1+2, a5 = a1, printx = $0002, ...
	lda.b a1+2
	sta.b a5+2
	lda.b a1
	sta.b a5
	lda.w #$0002
	sta.w printx
	lda.b a3
	and.w #$00FF
	dec a
	sta.b d0
	sta.b r1
	stz.b r2
	jsl.l GetGoalieCount			; d0 = the number of goalies on team a2
	lda.b r1
	cmp.b d0
	bpl .2
	lda.w #$0010
	sta.b r2
.2:									; d0 = r1, call GetNameandAttrib, increment a3, ...
	lda.b r1
	sta.b d0
	jsl.l GetNameandAttrib			; print player name and one attribute
	inc.b a3
	inc.w printy
	dec.b d1
	bpl .3
	lda.w #$2000
	sta.w printa
	rtl
