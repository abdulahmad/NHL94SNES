; Pause menu: cycle the goalie
PauseGoalie:						; called from PauseMenuHandlers
	jsl.l GetPadTeam				; a2 = the team of the controller that paused, from its side
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	jsl.l GetPadTeam				; a2 = the team of the controller that paused, from its side
	ldy.b a2
	lda.b d1
	bit.w #$8180
	bne .4
	bit.w #$0200
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; if tmgoalie,y negative go to .3
	lda.w tmgoalie,y
	bmi .3
.1:									; decrement a
	dec a
.2:									; tmgoalie,y = A, call setpersonel, go to PauseMenuPoll
	sta.w tmgoalie,y
	jsl.l setpersonel				; put the wanted players of team a2 on the ice
	jmp.w PauseMenuPoll
.3:									; tmgoalie,y negative: go to .1
	lda.b d0
	bra .1
.4:									; d1 bit $8180 set: if tmgoalie,y negative go to .t1x, ...
	lda.w tmgoalie,y
	bmi .t1x
	inc a
	cmp.b d0
	bcc .2
	lda.w #$FFFF
	bra .2

.t1x:								; tmgoalie,y negative: go to .2
	lda.w #$0000
	bra .2
