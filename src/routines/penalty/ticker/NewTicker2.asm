; d3 = the next game for the ticker, or negative when none is left
;
; Called from Intermission_ticker, NewTicker2_next, NewTicker and NewTicker3.
NewTicker2:							; picks the next game
	lda.w TickerNum					; ticker game
	sta.b d3						; d3 = it
	bmi .rtl						; negative: none left
	dec.w TickerNum					; following game next time
	lda.b d3
	cmp.l gamenum					; the game being played?
	beq NewTicker2					; yes: skip it
	bra NewTicker3					; no: show it
.rtl:								; return
	rtl								; return
