; Clear the team stats (but the goalie choice) and both penalty box lists, then set up the teams
ClearTeamStats:
	lda.w tmgoalie
	pha
	lda.w tmgoalie+2
	pha
	ldx.w #$0000
.clr:
	stz.w tmPwrGoals,x
	inx
	inx
	cpx.w #$01AC
	bne .clr
	pla
	sta.w tmgoalie+2
	pla
	sta.w tmgoalie
	lda.w #$FFFF
	sta.w tmboxlist
	sta.w tmboxlist+$1A
setteams:
	stz.w tmsort
	lda.w #$000C
	sta.w tmsort+2
	lda.w HomeTeam
	sta.w tmteam
	asl a
	asl a
	tax
	lda.l TeamList,x
	sta.w tmdata
	lda.w VisTeam
	sta.w tmteam+2
	asl a
	asl a
	tax
	lda.l TeamList,x
	sta.w tmdata+2
	rtl
