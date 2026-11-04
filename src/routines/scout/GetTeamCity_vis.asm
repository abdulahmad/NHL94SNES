; Script code %v: the visitors city (the first team String)
GetTeamCity_vis:						; Script code %v entry
	lda.w tmdata+2					; a1 = visitors team data
	sta.b a1						; type its city string
	bra GetTeamCity
