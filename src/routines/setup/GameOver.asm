; After a game: the password and the playoff screen, then the next game or the start
;
; Takes nothing, never returns. Jumped to from PeriodOver after the last period. Continues at Restart or at
; the scouting report of the next game.
GameOver:							; called from PeriodOver
	stz.w FrameByNumber				; clear the frame cache flag
	jsl.l EncodePW					; save the password
	jsl.l PlayoffScreen				; show the playoff screen
	lda.l OptPlayMode				; play mode 1 (a playoff series)?
	cmp.w #$0001
	beq .t1
	jml.l Restart					; no: back to the start

.t1:								; playoff series: is this a user game?
	lda.l gamenum
	bpl .t2
	jml.l Restart					; negative (no user game): back to the start

.t2:								; next playoff game: mask the password characters
	lda.l PassWord
	and.w #$7F7F
	sta.l PassWord
	jsl.l DecodePW					; decode the password back into the game state
	jsl.l MakeTree					; rebuild the playoff tree
	lda.w #$0004					; sflags3 mask $0004:
	trb.w sflags3					; test and clear it
	beq .t1x
	jmp.w StartGame					; it was set: start the game directly

.t1x:								; it was clear: start the game at its scouting report
	jml.l StartGame_scout			; reset the game state for a new game, then start the first period
