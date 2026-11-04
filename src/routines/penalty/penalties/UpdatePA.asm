; Animate the referee, and reprint the penalty message line when its time runs out
;
; d7 = frames elapsed. Counts RefCnt down and runs the next animation step (SetPA2) when it runs out.
; When penmsgtimer runs out it clears the message line and reprints the player's name there, centered.
; Called from chkprogress and PenaltyManager.
UpdatePA:							; animates the referee and the message line
	lda.w RefCnt					; referee counter
	bmi .t1							; negative: idle
	sec								; minus the elapsed frames
	sbc.b d7
	sta.w RefCnt					; new count
	bpl .1							; still running
	jsl.l SetPA2					; time up: next animation step
.1:									; message timer
	lda.w penmsgtimer
	sec								; message timer
	sbc.b d7
	sta.w penmsgtimer				; new timer
	bpl .t1							; still running
	lda.w #$7FFF					; reload
	sta.w penmsgtimer
	jsl.l ClearPenaltyMessage		; clear the message line
	lda.b a1+2						; save a1
	pha
	lda.b a1
	pha
	lda.w #UpdatePAPos>>16			; a1 = position of the message
	sta.b a1+2
	lda.w #UpdatePAPos
	sta.b a1
	jsl.l print						; print the position
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	jsl.l GetPlayerName				; a1 = the player name
	lda.b [a1]						; name length
	lsr a							; half of it
	sta.b d0
	lda.w printx					; x
	sec
	sbc.b d0						; minus half the length: centered
	sta.w printx
	jmp.w print						; print the name

.t1:								; return
	rtl								; return
