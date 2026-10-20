; a0 = the roster record of player d0 of team a2
;
; Takes d0 = player index and a2 = team (0/2); called from ScoutPlayerName, PlayerInitialName,
; PlayerShortName and PlayerNumName.
GetPlayerRecord:					; a0 = roster record of player d0 of team a2
	lda.w #TeamList>>16				; a0 = start of the team data, then step over its header to the first
									; player record
	sta.b a0+2
	ldy.b a2
	lda.w tmdata,y
	sta.b a0
	ldy.w #Playerdata
	clc
	adc.b [a0]
	sta.b a0
	bra .2							; go to the count test
.1:									; skip one record (its length word plus 8)
	lda.b a0
	clc
	adc.b [a0]
	adc.w #$0008
	sta.b a0
.2:									; loop d0 times
	dec.b d0
	bpl .1
	rtl
