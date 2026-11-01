; a0 = the roster record of player d0 of team a2
;
; Takes d0 = player index and a2 = team (0/2); called from ScoutPlayerName, PlayerInitialName,
; FormatPlayerNumInitial and getname.
GetPlayerRecord:					; a0 = roster record of player d0 of team a2
	lda.w #TeamList>>16				; a0 = start of the team data, then step over its header to the first
									; player record
	sta.b a0+2
	ldy.b a2
	lda.w tmdata,y					; team data pointer
	sta.b a0
	ldy.w #Playerdata
	clc								; offset of the player data
	adc.b [a0]
	sta.b a0						; a0 = start of the player data
	bra .2							; go to the count test
.1:									; skip one record (its length word plus 8)
	lda.b a0
	clc
	adc.b [a0]						; plus the record length
	adc.w #$0008					; plus 8
	sta.b a0
.2:									; loop d0 times
	dec.b d0						; until record d0
	bpl .1
	rtl
