; The injury box: the injured player and whether he is out for the period or the game
ShowInjuryBox:						; called from CheckInjury
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	stx.b xsave
	ldx.w #$0000
.loop:								; loop: X + 1, X + 1, if not zero go to .loop, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .loop
	ldx.b xsave
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowInjuryBoxPos>>16
	sta.b a1+2
	lda.w #ShowInjuryBoxPos
	sta.b a1
	jsl.l print						; print ShowInjuryBoxPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0012
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #InjuryToOutForPeriodTxt>>16
	sta.b a1+2
	lda.w #InjuryToOutForPeriodTxt
	sta.b a1
	jsl.l print						; print InjuryToOutForPeriodTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w TempPlOffset
	bit.w #$4000
	beq .1
	and.w #$BFFF
	sta.w TempPlOffset
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #TheGameTxt>>16
	sta.b a1+2
	lda.w #TheGameTxt
	sta.b a1
	jsl.l print						; print TheGameTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
.1:									; call GetPlayerNumInitial, call print, xsave = X, ...
	jsl.l GetPlayerNumInitial		; the number, first initial and last name of player TempPlOffset
	jsl.l print
	stx.b xsave
	ldx.w #$0012
.loop2:								; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop2
	ldx.b xsave
	pla
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	ldx.b a3
	rtl
