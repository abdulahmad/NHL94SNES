; Script code %H: the home full name (GetTeamLongName)
ScoutHomeName:						; Script code %H entry
	lda.w HomeTeam					; A = home team number
	jsl.l GetTeamLongName			; build its long name string
	bra ScoutAppend					; append and type it
