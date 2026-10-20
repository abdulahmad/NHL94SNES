; d0 = d0 mod 100
Mod100:								; called from PrintTeamNameAndScore, printscores1
	lda.b d0
.loop:								; loop: if carry clear go to .t1, ...
	cmp.w #$0064
	bcc .t1
	sbc.w #$0064
	bra .loop

.t1:								; d0 = A, return
	sta.b d0
	rtl
