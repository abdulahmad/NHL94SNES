; Add d0 to a team stat for player X's team
;
; d1 = address of the team 0 word of a stat (team 1's is the next word); x = player object;
; d0 = amount to add. Adds it to the stat of the player's team.
addteamstat:						; adds d0 to a team stat
	ldy.b d1						; pfteam: team 2 word
	lda.w pfteam,x
	beq .add						; team 0: stat as is
	iny								; team 1: the next word
	iny
.add:								; absolute stat address in d1 plus d0
	lda.w $0000,y					; absolute stat address in d1 (+$0000,y)
	clc								; stat + d0
	adc.b d0
	sta.w $0000,y					; store it
	rtl
