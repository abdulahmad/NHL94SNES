; Go to the next ticker game
;
; Like InitTicker: wraps to the last game of the round when the ticker is at game 0 and the current game is 0.
; Otherwise NewTicker2 steps to the next game. Called from IntermissionTick.
TickerNext:							; steps the ticker to the next game
	lda.w TickerNum					; current ticker game
	bmi .1							; none (negative): start from the last game
	ora.l gamenum					; ticker game 0 and the current game 0?
	bne .2							; no: show it
.1:									; start from the last game
	jsl.l GetShifter				; d1 = last game of the round
	lda.b d1
	sta.w TickerNum					; the ticker game
	bmi IntermissionTick_done		; no games: leave
.2:									; show the ticker box
	jmp.w NewTicker2				; picks the next game
