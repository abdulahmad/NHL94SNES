; printx / printy and the size of team a2's line change box
;
; Takes a2 = team. Returns the print position (printx/printy) and d0 = $C (width), d1 = 6 (height; 5 when
; choice 2 has no line). Called from SetLCmode2 and lcfound2.
setlccords:							; position and size of the line change box of team a2
	stz.b d0						; d0 = 0
	lda.b a2						; team
	bne .1							; team 1: keep 0
	inc.b d0						; team 0: d0 = 1
.1:									; a1 = setlccordsPos, call print, a1 = pulled value, ...
	lda.b a1+2						; save a1
	pha
	lda.b a1
	pha
	lda.w #setlccordsPos>>16		; position table
	sta.b a1+2
	lda.w #setlccordsPos
	sta.b a1
	jsl.l print						; sets printx / printy
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.w gmode						; game mode
	bit.w #gmdir					; direction flag?
	beq .2							; no: keep the side
	lda.b d0						; swap the sides
	eor.w #$0001
	sta.b d0
.2:									; call Mul8U, adc printy, printy = A, ...
	phx								; keep X
	lda.w #$0015					; 21 rows per side
	ldx.b d0
	jsl.l Mul8U						; times d0
	plx								; restore X
	adc.w printy					; add to the print row
	sta.w printy
	lda.w #$0002					; ask for choice 2
	sta.b d0
	jsl.l getlchoice				; d0 = its line
	lda.w #$0006					; box height 6
	sta.b d1
	lda.b d0						; choice 2 has a line?
	bpl .3							; yes
	dec.b d1						; no: one row less
	inc.w printy					; and start a row lower
.3:									; d0 = $000C, return
	lda.w #$000C					; width 12
	sta.b d0
	rtl
