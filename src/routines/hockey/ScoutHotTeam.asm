; Script code %t: the full name of the hotter team ($1E41), then " has" (" have" for the two New York teams)
ScoutHotTeam:						; Script code %t entry
	lda.w hotterteam				; A = hotter team number
	jsl.l GetTeamLongName			; build its long name string
	lda.w #mesarea>>16				; a3 = mesarea
	sta.b a3+2
	lda.w #mesarea
	sta.b a3
	lda.w #$0002					; start a fresh string (length word 2)
	sta.b [a3]
	jsl.l appstring					; append the team name
	lda.w #ScoutFragments>>16		; a1 = " have" fragment
	sta.b a1+2
	lda.w #ScoutFragments+18
	sta.b a1
	lda.w hotterteam				; teams $D and $E (the two New York teams) keep " have"
	cmp.w #$000D
	beq .1
	cmp.w #$000E
	beq .1
	lda.w #ScoutFragments>>16		; every other team: a1 = " has" fragment
	sta.b a1+2
	lda.w #ScoutFragments+12
	sta.b a1
.1:									; shared exit of the team test
	jsl.l appstring					; append the verb
	lda.w #mesarea>>16				; a1 = mesarea
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	bra ScoutTypeText				; type the sentence text
