; Before a period: reset the bench, refill energy and pick each team's starting line
;
; Before a period: resets the bench, sets newperiod, refills the energy of both teams (reenergizeteam)
; and chooses each team's line. When OptLine is on, a team with more players on the ice than the other starts
; on line 3 and one with fewer on line 5. Called from SaveRegsStartHL2 and Intermission.
SetupTeamForIntermission:			; sets both teams up for a period
	jsl.l ResetBench				; reset the bench
	lda.w #$0001					; newperiod
	sta.l newperiod
	stz.b a2						; a2 = team 0
	lda.w #$0002					; a3 = team 1
	sta.b a3
	jsl.l .team						; do team 0 (a3 is the other)
	stz.b a3						; swap the teams
	lda.w #$0002
	sta.b a2
.team:								; team a2, a3 = the other team
	jsl.l reenergizeteam			; refill the energy
	ldx.b a3						; x = team a3
	ldy.b a2						; y = team a2
	stz.w tmline,x					; line 0
	lda.l OptLine					; line changes option
	beq .rtl						; off: keep line 0
	lda.w tmap,x					; players on the ice of x
	sec
	sbc.w tmap,y					; minus those of y
	sta.b d0						; d0 = difference
	beq .rtl						; equal: line 0
	lda.w #$0003					; more players: line 3
	sta.w tmline,x
	lda.b d0						; sign of the difference
	bpl .rtl						; positive: keep line 3
	lda.w #$0005					; fewer players: line 5
	sta.w tmline,x
.rtl:								; done
	rtl								; return
