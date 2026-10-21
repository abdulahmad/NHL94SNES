; button on a row: the goalie row cycles the goalie, a shooter row opens ShooterSelectList
PickShooterRow:						; called from ShootersPick
	lda.w curitem
	bne ShooterSelectList
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	lda.w #homeshooters>>16
	sta.b a1+2
	lda.w #homeshooters
	sta.b a1
	lda.b a2
	beq .2
	lda.w #awayshooters>>16
	sta.b a1+2
	lda.w #awayshooters
	sta.b a1
.2:									; if zero go to .1, ...
	lda.b [a1]
	and.w #$00FF
	inc a
	cmp.b d0
	beq .1
	bmi .1
	lda.w #$0001
.1:									; [a1] = A, return
	sep #$20
	sta.b [a1]
	rep #$20
	rtl
