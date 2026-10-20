; Fill the text map with the blank tile
ClearTextMap:						; called from ClrHor, LoadPlayerCardScreen, LoadScoutingScreen, Passwor...
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.l blankchar
	clc
	adc.l charofs
	ldx.w #$0800
	jsl.l MemFill
	rtl
