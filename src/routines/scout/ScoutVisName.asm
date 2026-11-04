; Script code %V: the visitors full name (GetTeamLongName)
ScoutVisName:						; Script code %V entry
	lda.w VisTeam					; A = visitors team number
	jsl.l GetTeamLongName			; build its long name string
	bra ScoutAppend					; append and type it
