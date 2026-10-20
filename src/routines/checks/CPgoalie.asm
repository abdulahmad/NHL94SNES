; Should the computer pull its goalie in the last minute of the third period when it is behind
; Takes: d1 = puck y, a1 = other team, a2 = this team. Pulls the goalie of team a2 (tmgoalie high byte
; $FF, then setpersonel) in the third period (gsp = 2) when behind by one or two goals, with $3D (61)
; or fewer on gameclock and the puck on the attacking side. Called from ChkGoalies.
CPgoalie:							; should the computer pull its goalie?
	lda.w gsp						; period
	cmp.w #$0002					; third period only
	bne .t1
	ldy.b a1						; other team
	lda.w tmscore,y					; its score
	ldy.b a2						; this team
	sec
	sbc.w tmscore,y					; goals behind
	bmi .t1							; ahead: leave
	beq .t1							; tied: leave
	cmp.w #$0003					; three or more behind: leave
	bcs .t1
	lda.w gameclock					; game clock
	cmp.w #$003D					; more than 60 seconds left: leave
	bcs .t1
	lda.w tmsort,y					; first player of the team
	tay
	lda.w pfgoal,y					; which goal he shoots at
	bne .1
	lda.w #$0000					; mirror the puck y for the other end
	sec
	sbc.b d1
	sta.b d1
.1:
	lda.b d1						; puck y in the attacking half?
	bmi .t1							; no: leave
	ldy.b a2						; this team
	lda.w tmgoalie,y				; goalie flags
	ora.w #$FF00					; high byte $FF: goalie pulled
	sta.w tmgoalie,y
	jml.l setpersonel				; set up the players

.t1:								; return
	rtl
