; Start the score ticker for the other games of the round
;
; Starts the ticker at the last game of the round unless a game is already running.
; Called from Intermission.
Intermission_ticker:							; starts the score ticker
	lda.w TickerNum					; current ticker game
	bmi .1							; none (negative): start from the last game
	ora.l gamenum					; ticker game 0 and the current game 0?
	bne .2							; no: show it
.1:									; start from the last game
	jsl.l GetShifter				; d1 = last game of the round
	lda.b d1
	sta.w TickerNum					; the ticker game
	bmi Intermission_rtl			; no games: leave
.2:									; show the ticker box
	jmp.w NewTicker2				; show it
