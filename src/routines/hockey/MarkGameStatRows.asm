; Draw the braces around the visible game-stat rows.
;
; Called from GameStatsInput, ScrollGameStatsUp, ScrollGameStatsDown and StatsReport.
MarkGameStatRows:					; draw the braces around the visible rows, then wait for input
	lda.w listtop					; rows hidden above (listtop not 0)?
	beq .1
	lda.w #$0001					; print the upper brace at x 1, y = listtop * 2, attribute $2000
	sta.w printx
	lda.w listtop
	asl a
	sta.w printy
	lda.w #$2000
	sta.w printa
	lda.w #LineBraces>>16
	sta.b a1+2
	lda.w #LineBraces
	sta.b a1
	jsl.l PrintToStatsPage
.1:									; lower brace
	lda.w listtop					; rows hidden below (listtop + listrows is not listcount)?
	clc
	adc.w listrows
	cmp.w listcount
	beq .2
	lda.w #$0001					; print the lower brace (LineBraces+3) at y = (listtop + listrows) * 2
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
	lda.w #LineBraces+3
	sta.b a1
	jsl.l PrintToStatsPage
.2:									; send the page
	jsr.w SendGameStatsPage			; send the page, wait a frame and go to the input loop
	jsl.l WaitFrame
	jmp.w GameStatsInput			; game stats input
; The rtl the game stats screen leaves through
GameStatsRtl:						; the rtl the game stats screen leaves through
	rtl
