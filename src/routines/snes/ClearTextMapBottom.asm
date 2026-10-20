; Fill the text map from row 12 down with the blank tile
ClearTextMapBottom:					; called from ClearMessageArea, PlayerSelect, RedrawPlayerSelect, setop...
	lda.w #$007E
	sta.b p1+2
	lda.w #$3AF4
	sta.b p1
	lda.l blankchar
	clc
	adc.l charofs
	ldx.w #$0500
	jsl.l MemFill
	rtl
