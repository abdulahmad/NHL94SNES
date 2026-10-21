; Line editor: erase the line area and print the selected line's players by position, with the goalie marks
PrintLinePlayers:					; called from PrintLineNames
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintLinePlayersPos>>16
	sta.b a1+2
	lda.w #PrintLinePlayersPos
	sta.b a1
	jsl.l print						; print PrintLinePlayersPos
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
	lda.w #PrintLinePlayersPos2>>16
	sta.b a1+2
	lda.w #PrintLinePlayersPos2
	sta.b a1
	jsl.l print						; print PrintLinePlayersPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	lda.b d0
	dec a
	sta.b d1
	lda.w #LineGoalieMarks
	sta.b a5
	lda.w #LineGoalieMarks>>16
	sta.b a5+2
	lda.w #.4
	sta.b a3
	lda.w #.4>>16
	sta.b a3+2
	lda.w SelectedPlayerIdx
	dec a
	sta.b d0
	bmi .3
	asl a
	asl a
	asl a
	sta.b d0
	jsl.l GetTeamLines				; a3 = the RAM lines of team a2
	sec
	adc.b d0
	sta.b a3
	lda.w #PositionNames
	sta.b a5
	lda.w #PositionNames>>16
	sta.b a5+2
	lda.w #$0004
	sta.b d1
	lda.w SelectedPlayerIdx
	sec
	sbc.w #$0005
	beq .3
	bmi .t1
.1:									; if overflow clear go to .2, ...
	bvc .2
	bra .3

.t1:								; if overflow clear go to .3
	bvc .3
.2:									; decrement d1
	dec.b d1
.3:									; loop: printa = $3800, if d1 != linecursor go to .1x, ...
	lda.w #$3800
	sta.w printa
	lda.b d1
	cmp.w linecursor
	bne .1x
	lda.w #$2000
	sta.w printa
	lda.b [a3]
	and.w #$00FF
	dec a
	sta.l matchuphome
.1x:								; printx = $0005, a1 = a5, a1+2 = a5+2, ...
	lda.w #$0005
	sta.w printx
	lda.b a5
	sta.b a1
	lda.b a5+2
	sta.b a1+2
	jsl.l print
	lda.b a1
	sta.b a5
	lda.b a1+2
	sta.b a5+2
	lda.w #$0008
	sta.w printx
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.b [a3]
	and.w #$00FF
	dec a
	sta.b d0
	jsl.l PlayerNumName				; mesarea = the uniform number and name of roster player d0 of team a2
	jsl.l print
	inc.b a3
	pla
	sta.b a1+2
	pla
	sta.b a1
	inc.w printy
	inc.w printy
	dec.b d1
	bmi .t1x
	jmp.w .3

.t1x:								; d1 counted below 0: call DrawEditLinesTitle, return
	jsl.l DrawEditLinesTitle		; line editor: the EditLinesLabel title sprites
	rts
.4:									; db $01,$02,$03,$04
	db $01,$02,$03,$04
