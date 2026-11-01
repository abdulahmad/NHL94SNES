; ReadjoyA for the controller that owns the pause menu
getpzjoy:							; called from AskExitGame, EditLinesMenu, EditLinesScreen, GameStatsInp...
	lda.w pausepad
	lsr a
	jmp.w ReadjoyA					; read pad A: d0 = direction, d1 = new presses, d2 = changed buttons
