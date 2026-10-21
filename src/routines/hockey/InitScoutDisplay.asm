; Reset the scouting report text scroll
;
; Called from ScoutingReport.
InitScoutDisplay:					; reset the scouting report scroll state
	lda.w #$FFFF					; no vertical scroll, no player scroll
	sta.w VertLineScrolling
	sta.w PlayerScrollCtr			; no player scrolling
	stz.w SelectedPlayerIdx			; first player, report timer 0
	stz.w ScoutingReportTimer		; timer 0
	lda.w #TestList>>16				; a0 = TestList
	sta.b a0+2
	lda.w #TestList
	sta.b a0
	rtl
