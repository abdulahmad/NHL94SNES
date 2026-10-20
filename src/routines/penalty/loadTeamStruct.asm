; a2 = player X's team, a1 = the other team
loadTeamStruct:						; called from SetLCmode, dopass_count, lcfound, lineinput, updateplayers
	lda.w pfteam,x
	beq .t1
	stz.b a1
	lda.w #$0002
	sta.b a2
	rtl

.t1:								; pfteam,x = 0: a1 = $0002, a2 = 0, return
	lda.w #$0002
	sta.b a1
	stz.b a2
	rtl
