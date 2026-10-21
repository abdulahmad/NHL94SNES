; Print the abbreviation of the home team (d3 = 0) or the visitors on the stats page, then two rows down
PrintTeamAbbrev:					; called from FillPenaltyPage, FillScoringPage
	lda.w printx
	pha
	lda.w tmdata
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	lda.b d3
	beq .1
	lda.w tmdata+2
	sta.b a1
.1:									; a1 = [a1],y + a1, a1 = [a1] + a1, call PrintToStatsPage, ...
	ldy.w #$0004
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	adc.b a1
	sta.b a1
	jsl.l PrintToStatsPage
	pla
	sta.w printx
	inc.w printy
	inc.w printy
	rtl
