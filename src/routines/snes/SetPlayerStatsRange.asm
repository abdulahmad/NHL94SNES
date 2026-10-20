; The first and last row of the player stats list: the goalies or the skaters
; Takes statcolumn (0 = goalies, otherwise skaters). Sets listtop, listend (last row, inclusive) and curitem
; (= listtop) for the rows of the player stats page. Goalies come first in the roster, so the skaters start
; after GoalieCount.
;
; Called from ShowPlayerStats and SwapPlayerStatsTeam.
SetPlayerStatsRange:				; set the row range of the player stats list
	lda.w statcolumn				; statcolumn: 0 = goalies page
	cmp.w #$0000					; compare with 0
	beq .t1							; goalies page: take the goalie range
	jsl.l GoalieCount				; skaters: they follow the goalies
	lda.b d0						; number of goalies
	sta.w listtop					; first row = first skater
	jsl.l GetPlayerCount			; number of players of the team
	lda.b d0						; end of the list = player count
	sta.w listend					; end of the list = player count
	bra .1							; go set the last row

.t1:								; goalies: list starts at row 0
	stz.w listtop
	jsl.l GoalieCount				; number of goalies
	lda.b d0						; take the goalie count
	sta.w listend					; end of the list = goalie count
.1:									; listend is exclusive so far
	dec.w listend					; make it the last row
	lda.w listtop					; start on the first row
	sta.w curitem					; curitem = listtop
	rtl
