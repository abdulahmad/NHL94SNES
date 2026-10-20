; Update the ticker scores of the other playoff games
;
; Called from PeriodOver. Sets TickerNum to the last game of the round, then for every other game clears
; the highlight flag (bit 1) and, if the game is not over (bit 2), adds goals with SetScore.
UpdateScores:						; updates the other games
	jsl.l GetShifter				; d1 = last game
	lda.b d1
	sta.w TickerNum					; the ticker starts there
	asl a							; times 2
	sta.b a0						; a0 = word offset
.loop:								; loop over the games
	lda.b d1
	cmp.l gamenum					; the game being played?
	beq .1							; yes: skip it
	ldx.b a0						; x = game offset
	lda.l gsflags,x					; game flags
	and.w #$FFFD					; clear the highlight flag
	sta.l gsflags,x
	bit.w #$0004					; flag $0004: game over
	bne .1							; over: keep the score
	jsl.l SetScore					; add goals to the score
.1:									; previous game
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .loop						; until game 0 is done
	rtl								; return
