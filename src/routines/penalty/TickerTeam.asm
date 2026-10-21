; Print one ticker line: team d0's name and score d1
;
; Prints one ticker line: d0 = team, d1 = its score. Takes the printx on the stack from NewTicker3.
; Called from NewTicker3. Ends in a jump to print.
TickerTeam:							; prints one team line of the ticker
	lda.b r1,s
	sta.w printx
	inc.w printy
	lda.b d0
	jsl.l GetTeamLongName
	jsl.l print
	lda.b r1,s
	clc
	adc.w #$0017
	sta.w printx
	lda.b d1
	sta.b d0
	jsl.l PushNumber				; a1 = d0 as a decimal string, no leading zeros
	jml.l print						; printx saved by NewTicker3
