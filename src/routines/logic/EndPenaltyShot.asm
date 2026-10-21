; End the penalty shot or shootout attempt in progress (PenShotActive and penshot): clear it, no shooter,
; ShootoutWonBy 10, put back the saved scores
EndPenaltyShot:						; called from Gameloop, Goal, clockcont_0, puckglue, pucknorm_move and...
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
	jsl.l ShootoutWonBy				; "<team> Wins!" once the shootout is decided
	lda.w psfoxsave
	sta.l ltx
	lda.w psfoysave
	sta.l lty
	plx
.rtl:								; return
	rtl
