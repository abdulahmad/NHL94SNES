; Erase the braces around the visible game-stat rows.
ClearGameStatBraces:				; called from ScrollGameStatsDown, ScrollGameStatsUp
	lda.w #$0001
	sta.w printx
	lda.w listtop
	asl a
	sta.w printy
	lda.w #$2000
	sta.w printa
	lda.w #LineBraces>>16
	sta.b a1+2
	lda.w #LineBraces+6
	sta.b a1
	jsl.l PrintToStatsPage
	lda.w #$0001
	sta.w printx
	lda.w listtop
	clc
	adc.w listrows
	asl a
	sta.w printy
	lda.w #$2000
	sta.w printa
	lda.w #LineBraces>>16
	sta.b a1+2
	lda.w #LineBraces+6
	sta.b a1
	jsl.l PrintToStatsPage
	rts

SendGameStatsPage:					; called from MarkGameStatRows, ScrollGameStatsDown, ScrollGameStatsUp
	lda.w listtop
	xba
	lsr a
	adc.w #$2780
	sta.b p0
	lda.w #$007F
	sta.b p0+2
	lda.w listrows
	inc a
	xba
	lsr a
	tax
	ldy.w #$0180
	jsl.l DMAToVRAM
	rts
