; Line editor: clear the top, the title (DrawEditLinesTitle) and the line frame
DrawEditLinesTop:					; called from LineEditorExit, LineEditor
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawEditLinesTopPos>>16
	sta.b a1+2
	lda.w #DrawEditLinesTopPos
	sta.b a1
	jsl.l print						; print DrawEditLinesTopPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$000D
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	jsl.l DrawEditLinesTitle		; line editor: the EditLinesLabel title sprites
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawEditLinesTopPos2>>16
	sta.b a1+2
	lda.w #DrawEditLinesTopPos2
	sta.b a1
	jsl.l print						; print DrawEditLinesTopPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0800
	sta.w printa
	lda.w #$0011
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l FramerOutline
	rtl
