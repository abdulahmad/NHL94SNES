; d0 = the number of players on team a2's roster.
; Takes a2 = team offset, returns d0 = number of players (counts the players of the roster list until the
; terminator word $0002). a0 is preserved.
;
; Called from ScoutingReport, ShowThreeStars, SwapPlayerCardTeam, PlayerCards and ShooterSelectList.
GetPlayerCount:						; count the players of the team
	lda.b a0
	pha
	lda.b a0+2
	pha
	ldy.b a2						; team
	lda.w tmdata,y					; team data pointer
	sta.b a0
	lda.w #TeamList>>16				; bank
	sta.b a0+2
	ldy.w #Playerdata				; player data offset
	lda.b [a0],y					; start of the player data
	clc
	adc.b a0
	sta.b a0
	stz.b d0						; count = 0
.count:								; next player record
	inc.b d0						; one more player
	lda.b [a0]						; record length
	clc
	adc.b a0
	adc.w #$0008					; plus 8
	sta.b a0
	lda.b [a0]						; next record
	cmp.w #$0002					; end marker 2
	bne .count						; not the end
	pla								; restore a0
	sta.b a0+2
	pla
	sta.b a0
	rtl
