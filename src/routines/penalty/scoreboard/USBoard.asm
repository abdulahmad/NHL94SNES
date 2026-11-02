; Update the scoreboard, with the players in the penalty box and their time left
;
; Called from InProgress and SetHor_rink. Saves the d0 and a0 register blocks, redraws the scores
; (printscores1), then prints the box list of team 0 and of team 1 (DispPen). Returns with x = a3.
USBoard:							; redraws the scoreboard with the penalty boxes
	stx.b xsave						; keep x
	ldx.w #$0000
.save:								; save d0 and the next 15 words
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .save
	ldx.b xsave						; restore x
	stx.b xsave						; keep X
	ldx.w #$0000
.savea:								; save a0 and the next 7 words
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
	ldx.b xsave						; restore x
	jsl.l printscores1				; redraw the scores
	lda.b a1+2						; save a1
	pha
	lda.b a1
	pha
	lda.w #USBoardPos>>16			; a1 = position of the first box
	sta.b a1+2
	lda.w #USBoardPos
	sta.b a1
	jsl.l print						; print the position
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	stz.b a2						; team 0
	jsl.l DispPen					; print its box list
	lda.b a1+2						; save a1
	pha
	lda.b a1
	pha
	lda.w #IntermissionPos>>16		; a1 = position of the second box
	sta.b a1+2
	lda.w #IntermissionPos
	sta.b a1
	jsl.l print						; print the position
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0002					; team 1
	sta.b a2
	jsl.l DispPen					; print its box list
	stx.b xsave						; keep x
	ldx.w #$000E
.resta:								; pull back a0 and the next 7 words
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave						; restore x
	stx.b xsave						; keep X
	ldx.w #$001E
.restore:							; pull back d0 and the next 15 words
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave						; restore x
	ldx.b a3						; x = a3
USBoard_rtl:						; the rtl DispPen and pplpen leave through
	rtl								; return
