; End the penalty shot or shootout attempt in progress ($163A and $1E9B): clear it, no shooter, ShootoutWonBy
; 10, put back the saved scores
EndPenaltyShot:
	lda.w PenShotActive
	beq .rtl
	lda.w penshot
	beq .rtl
	phx
	stz.w penshot
	lda.w #$FFFF
	sta.w BA_Sktr_SCnum
	lda.w #$000A
	sta.b d0
	jsl.l ShootoutWonBy
	lda.w psfoxsave
	sta.l ltx
	lda.w psfoysave
	sta.l lty
	plx
.rtl:
	rtl
