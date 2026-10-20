; a2 = the team of the controller that owns the pause menu
;
; Takes: pausepad. Returns a2 = 2 if the pause pad belongs to the away team (cont1team = 2), else 0.
; Called by TeamRoster, ShowPlayerStats, ShowPlayerCards, ShootoutShooters and EditLinesScreen.
GetPauseTeam:						; team of the pause controller
	stz.b a2						; default 0
	ldx.w pausepad					; pause pad
	lda.w cont1team,x
	cmp.w #$0002
	bne .rtl						; not team 2: keep 0
	lda.w #$0002
	sta.b a2
.rtl:								; return
	rtl
