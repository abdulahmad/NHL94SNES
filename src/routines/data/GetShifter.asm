; d1 = the number of games of the playoff round less one, d2 = its first win bit
;
; Takes playoffRoundIdx. Returns d1 = games in the round minus one (8, 4, 2, 1, less one) and d2 = the first
; win bit of the round. Called from DoHiLights, FigureJoy, InitScores, Intermission_ticker, NewTicker3,
; ResolveGames, ShowOtherScores, NewTicker2_next, UpdateScores and MakeTree.
GetShifter:							; games of the round less one and its first win bit
	lda.w #$FFF0					; d2 = -16
	sta.b d2
	lda.w #$0010					; d1 = 16
	sta.b d1
	lda.l playoffRoundIdx			; round
	tay
.3:									; add the shift for each finished round
	lda.b d2						; d2 = d2 + d1
	clc
	adc.b d1						; d2 += d1
	sta.b d2
	lsr.b d1						; d1 halves
	dey								; next round
	bpl .3
	dec.b d1						; games - 1
	rtl
