; a3 = the RAM lines of team a2 (homelines / awaylines)
;
; Takes a2 = team (0 home, else visitors). Called from SetLineSlot, SelectLinePlayer, LoadTeamLines,
; PrintLinePlayers and SetPlList.
GetTeamLines:						; a3 = RAM lines of team a2
	lda.w #$0000					; a3 = the RAM lines of team a2: home for team 0, else visitors
	sta.b a3+2
	lda.b a2
	beq .t1							; team 0: home lines
	lda.w #awaylines
	bra .1

.t1:								; home lines
	lda.w #homelines
.1:									; return a3
	sta.b a3
	rtl
