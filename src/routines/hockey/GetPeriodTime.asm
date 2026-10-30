; d0 = the period length in seconds for the period length option
; Called from ShowThreeStars, ResetClock and setplayer.
GetPeriodTime:						; called from ResetClock, ShowThreeStars, setplayer
	phx								; save X, index the period length table by Optperlen
	lda.l Optperlen
	asl a							; option times 2: word table
	tax
	lda.l GetPeriodTime_timetab,x	; d0 = the length in seconds
	sta.b d0
	plx								; restore X
	rtl
