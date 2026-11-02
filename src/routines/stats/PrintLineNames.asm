; Print the current line name. A zero select word uses the best-line list.
PrintLineNames:						; called from LineEditor
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintLineNamesPos>>16
	sta.b a1+2
	lda.w #PrintLineNamesPos
	sta.b a1
	jsl.l print						; print PrintLineNamesPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w SelectedPlayerIdx
	sta.b d0
	lda.w #LineMenuNames>>16
	sta.b a1+2
	lda.w #LineMenuNames
	sta.b a1
	lda.l OptLine
	bne .1
	lda.w #BestLineNames>>16
	sta.b a1+2
	lda.w #BestLineNames
	sta.b a1
.1:									; call AdvanceStringPtr, call print, d4+2 = [a1], ...
	jsl.l AdvanceStringPtr			; a1 = string d0 of the string list [a1]
	jsl.l print
	lda.b [a1]
	sta.b d4+2
	ldy.w #$0002
	lda.b [a1],y
	sta.b d4
	jsr.w PrintLinePlayers
	rtl
