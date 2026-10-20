; Line editor: erase the menu area (32 x 17 from row 9)
ClearEditLinesMenu:					; called from EditLinesMenu
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ClearEditLinesMenuPos>>16
	sta.b a1+2
	lda.w #ClearEditLinesMenuPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$0011
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	rts
