; Erase the braces around the visible player-stat rows.
ClearPlayerStatBraces:				; called from PlayerStatsScreen_down, PlayerStatsScreen_up
	lda.w #$0001
	sta.w printx
	lda.w curitem
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
	lda.w curitem
	clc
	adc.w listrows
	dec a
	asl a
	sta.w printy
	lda.w #$2000
	sta.w printa
	lda.w #LineBraces>>16
	sta.b a1+2
	lda.w #LineBraces+6
	sta.b a1
	jsl.l PrintToStatsPage
	rtl
