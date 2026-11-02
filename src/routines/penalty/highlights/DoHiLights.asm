; Playoffs: play the highlight of each game of the round that has one
;
; Playoffs: for each game of the round that still has a highlight pending (and is not played out),
; clears that flag and plays the highlight through SaveRegsStartHL2. Does nothing in a regular season.
; Called from Intermission_tick.
DoHiLights:							; play the pending highlights
	lda.l OptPlayMode				; play mode of the game options
	beq .rtl						; not playoffs: nothing to do
	jsl.l GetShifter				; d1 = number of games
	lda.b d1
	asl a							; offset
	sta.b a0						; a0 = game offset (word entries)
.loop:								; loop over the games, last to first
	ldx.b a0
	lda.l gsflags,x					; game flags
	bit.w #gsfso					; flag $0004: game already played out
	bne .1							; played: next game
	bit.w #gsfhl					; flag $0002: highlight pending
	beq .1							; none: next game
	and.w #(~gsfhl&$FFFF)			; clear the highlight flag
	sta.l gsflags,x
	jsl.l SaveRegsStartHL2			; play the highlight
.1:									; previous game
	dec.b a0						; previous game
	dec.b a0
	dec.b d1						; until game 0
	bpl .loop						; until game 0 is done
.rtl:								; return
	rtl
