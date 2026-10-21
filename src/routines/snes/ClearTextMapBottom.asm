; Fill the text map from row 12 down with the blank tile
ClearTextMapBottom:					; called from ClearMessageArea, PlayerSelect, RedrawPlayerSelect, setop...
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap+$300
	sta.b p1
	lda.l blankchar
	clc
	adc.l charofs
	ldx.w #$0500
	jsl.l MemFill
	rtl
