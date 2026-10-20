; d0 = the period length in seconds for the period length option
; Called from ShowStars, ResetClock and setplayer.
GetPeriodTime:
	phx								; save X, index the period length table by OptPerlen
	lda.l OptPerlen
	asl a
	tax
	lda.l GetPeriodTime_timetab,x	; d0 = the length in seconds
	sta.b d0
	plx
	rtl
