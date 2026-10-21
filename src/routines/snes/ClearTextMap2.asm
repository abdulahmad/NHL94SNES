; Fill the second text map (textmap2, the one SendTextMap2 sends) with the blank tile
ClearTextMap2:						; called from LoadPlayerCardScreen
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	lda.l blankchar
	clc
	adc.l charofs2
	ldx.w #$0800
	jsl.l MemFill
	rtl
