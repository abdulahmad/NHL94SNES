; After a playoff game, work out the winners and the new password
;
; Takes the playoff state (OptPlayMode, the round and the result of the game in gamenum). Plays on in the
; playoffs by building a new tree and password, or resets the password when the user won it all or failed.
; Called from GameOver.
EncodePW:							; work out the winners and the new password after a playoff game
	lda.l OptPlayMode				; play mode
	bne .t2							; playoffs: continue
	jmp.w .4						; regular season: nothing to do

.t2:								; continue the playoffs
	lda.w #$0001
	sta.l OptPlayMode
	jsl.l ResolveGames				; work out the winners
	jsl.l MakeTree					; build the tree
	lda.l playoffRoundIdx			; finished the playoffs?
	cmp.w #$0004
	beq .t1							; round 4 over: the user won
	lda.l gamenum					; gamenum
	bpl .1							; not negative: the user won this game
	lda.l pojoy						; pojoy
	sec
	sbc.w #$0002					; pojoy below 2 (one player): failed
	bmi .3
	lda.l playoffRoundIdx			; first round only
	cmp.w #$0001
	bne .3							; no: failed
	lda.l potreeteam				; swap the playoff team
	eor.w #$0001
	sta.l potreeteam
	lda.l pojoy
	eor.w #$0001					; and the joystick
	sta.l pojoy
.1:									; password bits, then to characters
	jsl.l WritePassBits				; turn the playoff state into the password bits, with a checksum
	jsl.l BitstoPW					; turn the password bits into the password characters
	lda.w sflags3					; sflags3 bit $0004: use the saved passbits
	bit.w #$0004
	beq .2							; normal tree
	ldx.w #$000E					; 8 words
.loop:								; copy the saved bits back
	lda.l tpassbits,x
	sta.l passbits,x
	dex
	dex
	bpl .loop
	jsl.l ReadPassBits				; read the bits back
.2:									; build the tree
	jml.l MakeTree					; build the playoff tree from the seeds and the series wins

.t1:								; the user won: reset the password
	jsl.l ResetPassWord				; reset the password
.3:									; failed: set PassWord bit 7 (no password)
	lda.w #$0080					; PassWord bit 7: no password
	ora.l PassWord
	sta.l PassWord
	lda.w #$0002					; play mode 2
	sta.l OptPlayMode
	lda.w bosgames
	cmp.w #$0007					; single game round
	beq .4							; keep mode 2
	lda.w #$0003					; else play mode 3
	sta.l OptPlayMode
.4:									; return
	rtl
