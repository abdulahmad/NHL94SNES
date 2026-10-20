; Other scores: team A's full name at x 7 and its score d0 at x $14 on the stats page
PrintOtherScoreTeam:				; called from PrintOtherScore
	jsl.l GetTeamLongName
	lda.w #$0007
	sta.w printx
	jsl.l PrintToStatsPage
	lda.w #$0014
	sta.w printx
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l PrintToStatsPage
	rts
