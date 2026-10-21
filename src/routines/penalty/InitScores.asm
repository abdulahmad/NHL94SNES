; Playoffs: give the other games of the round scores so far
;
; For the playoff rounds below 2 only: each other game of the round that is not over gets period 0 and a
; random number of SetScore calls, so the scores are plausible when the ticker shows them.
; Called from StartGame.
InitScores:							; random scores for the other games of the round
	lda.l playoffRoundIdx			; playoff round
	cmp.w #$0002					; only the first two rounds
	bcs .5							; later round: nothing to do
	jsl.l GetShifter				; d1 = last game of the round
	lda.b d1
	asl a							; a0 = word offset of that game
	sta.b a0
.1:									; loop over the games, last to first
	lda.b d1						; the user game
	cmp.l gamenum					; the game being played: skip it
	beq .4							; skip
	ldx.b a0
	lda.l gsflags,x					; game flags
	bit.w #$0004					; flag $0004: game over
	bne .4							; over: skip
	lda.w #$0000					; period 0
	sta.l gsper,x
	lda.w #$0003					; random number from 0 to 3
	jsl.l randoma8					; random number below A
	inc a							; plus 1
	sta.b d0						; d0 = number of scoring rounds
	bra .3							; start counting
.2:									; one scoring round
	jsl.l SetScore					; add a goal
.3:									; count
	dec.b d0						; next round
	bpl .2							; until done
.4:									; previous game
	dec.b a0						; previous game
	dec.b a0
	dec.b d1
	bpl .1							; until game 0 is done
.5:									; return
	rtl								; return
