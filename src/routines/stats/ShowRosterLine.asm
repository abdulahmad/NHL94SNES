; Print the selected line name and attribute column (DispAttribCtr, wrapping) and each player of the line with
; GetNameandAttrib
; Takes a2 = team offset, SelectedPlayerIdx = line (0 = goalies), DispAttribCtr = attribute column. Prints
; the line name and the column title, clears the area below and prints each player of the line with
; GetNameandAttrib, with the position names (PositionNames) of the line or the goalie marks.
;
; Called from MoveRosterColumn and TeamRoster.
ShowRosterLine:						; print the roster line with the chosen attribute
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowRosterLinePos>>16
	sta.b a1+2
	lda.w #ShowRosterLinePos
	sta.b a1
	jsl.l print						; print ShowRosterLinePos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w SelectedPlayerIdx
	sta.b d0
	lda.w #RosterLineNames>>16
	sta.b a1+2
	lda.w #RosterLineNames
	sta.b a1
	jsl.l AdvanceStringPtr			; a1 = string d0 of the string list [a1]
	jsl.l print
	lda.w #$0011
	sta.w printx
	lda.w #$0009
	sta.w printy
.col:								; find the attribute entry of the current column
	lda.w #AttribMenuSkater>>16
	sta.b a1+2
	lda.w #AttribMenuSkater
	sta.b a1
	lda.w DispAttribCtr
	sta.b d0
	lda.w SelectedPlayerIdx
	bne .top
	lda.w #AttribMenuGoalie>>16
	sta.b a1+2
	lda.w #AttribMenuGoalie
	sta.b a1
	bra .top
.next:								; skip to the next entry of the menu
	lda.b a1
	clc
	adc.b [a1]
	adc.w #$0004
	sta.b a1
.top:								; end of the menu?
	lda.b [a1]
	bmi .1
	dec.b d0
	bpl .next
.1:									; past the last column: wrap back
	lda.b [a1]
	bpl .t2
	dec.w DispAttribCtr
	bra .col

.t2:								; print the column title
	jsl.l print
	lda.b [a1]
	sta.b d4+2
	ldy.w #$0002
	lda.b [a1],y
	sta.b d4
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowRosterLinePos2>>16
	sta.b a1+2
	lda.w #ShowRosterLinePos2
	sta.b a1
	jsl.l print						; print ShowRosterLinePos2
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
	lda.w #YSwitchTeamsTxt2>>16
	sta.b a1+2
	lda.w #YSwitchTeamsTxt2
	sta.b a1
	jsl.l print						; print YSwitchTeamsTxt2
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	lda.b d0
	dec a
	sta.b d1
	lda.w #RosterGoalieMarks>>16
	sta.b a5+2
	lda.w #RosterGoalieMarks
	sta.b a5
	lda.w #RosterGoalieList>>16
	sta.b a3+2
	lda.w #RosterGoalieList
	sta.b a3
	lda.w SelectedPlayerIdx
	dec a
	sta.b d0
	bmi .3
	asl a
	asl a
	asl a
	sta.b d0
	ldy.b a2
	lda.w #TeamList>>16
	sta.b a3+2
	lda.w tmdata,y
	sta.b a3
	ldy.w #$0006
	clc
	adc.b [a3],y
	sec
	adc.b d0
	sta.b a3
	lda.w #PositionNames>>16
	sta.b a5+2
	lda.w #PositionNames
	sta.b a5
	lda.w #$0004
	sta.b d1
	lda.w SelectedPlayerIdx
	sec
	sbc.w #$0005
	beq .3
	bmi .t1
	bvc .2
.1x:								; compare result: keep the row count
	bra .3

.t1:								; line is the last one (overflow test)
	bvc .3
.2:									; fewer rows
	dec.b d1
.3:									; print the next player row
	lda.w #$0001
org $9DA000
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
	lda.w #$0004
	sta.w printx
	lda.b [a3]
	inc.b a3
	and.w #$00FF
	dec a
	sta.b d0
	sta.b r1
	stz.b r2
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	lda.b r1
	cmp.b d0
	bpl .1xx
	lda.w #$0010
	sta.b r2
.1xx:								; a goalie when r1 is not below the goalie count
	lda.b r1
	sta.b d0
	jsl.l GetNameandAttrib			; print player name and one attribute
	inc.w printy
	inc.w printy
	dec.b d1
	bpl .3
RosterRtl:							; shared return of the roster routines
	rtl
RosterGoalieList:					;the roster players shown on the goalie page (with RosterGoalieMarks):
									;1-4, the goalies come first
	db $01,$02,$03,$04
