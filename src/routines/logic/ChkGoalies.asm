; A computer team pulls its goalie on a delayed penalty, or late in a game it trails
; Takes: nothing. Called from periodicevents. With the clock running, each team in turn (a2 = team, a1 =
; other team) that has the puck and no human pad pulls its goalie on a delayed penalty (gmode bit $0008)
; or, through CPgoalie, late in a game it trails.
ChkGoalies:							; computer teams may pull their goalie
	lda.w gmclock					; game clock
	bne rtss						; clock stopped: leave
	stz.b a2						; first the home team: a2 = 0
	lda.w #$0002					; a1 = other team
	sta.b a1
	jsl.l .1
	stz.b a1						; then the other team: a1 = 0, a2 = 2
	lda.w #$0002
	sta.b a2
.1:									; check team a2
	ldy.b a2
	lda.w tmgoalie,y				; goalie already out?
	bmi rtss						; yes: leave
	ldx.w tmsort,y					; first player of the team
	ldy.w puckc						; puck carrier
	bmi rtss						; nobody has it: leave
	lda.w pfteam,y					; team of the carrier
	cmp.w pfteam,x
	bne rtss						; the other team has the puck: leave
	ldy.b a2						; this team
	lda.w gmode						; game mode
	bit.w #$0008					; bit $0008: delayed penalty
	bne .t1							; delayed penalty: pull the goalie
	lda.w teampads,y				; human pad on this team?
	bne rtss						; yes: leave
	lda.w pucky						; puck y
	sta.b d1
	jsl.l CPgoalie					; the usual late game rule
	rtl								; return

.t1:								; delayed penalty
	lda.w tmgoalie,y				; goalie flags
	ora.w #$FF00					; high byte $FF: goalie pulled
	sta.w tmgoalie,y				; pulled
	jsl.l setpersonel				; set up the players
rtss:								; return
	rtl
