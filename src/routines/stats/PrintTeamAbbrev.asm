; Print the abbreviation of the home team (d3 = 0) or the visitors on the stats page, then two rows down
PrintTeamAbbrev:					; called from FillPenaltyPage, FillScoringPage
	lda.w printx					; keep print x
	pha
	lda.w tmdata					; tmdata of team d3
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	lda.b d3						; team 0?
	beq .1							; yes
	lda.w tmdata+2					; else the away team
	sta.b a1
.1:									; a1 = [a1],y + a1, a1 = [a1] + a1, call PrintToStatsPage, ...
	ldy.w #$0004
	lda.b [a1],y
	clc								; name pointer
	adc.b a1
	sta.b a1
	lda.b [a1]						; name string
	adc.b a1
	sta.b a1
	jsl.l PrintToStatsPage
	pla
	sta.w printx					; restore x
	inc.w printy					; down two rows
	inc.w printy
	rtl
