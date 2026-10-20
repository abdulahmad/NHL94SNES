; ReadjoyA for the controller that owns the pause menu
ReadPausePad:						; called from AskExitGame, EditLinesMenu, EditLinesScreen, GameStatsInp...
	lda.w pausepad
	lsr a
	jmp.w ReadjoyA
