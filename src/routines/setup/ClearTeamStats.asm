;
; Takes nothing, returns nothing. Called from ScoutingReport, SaveRegsStartHL2 and StartGame. Falls into
; setteams.
; Clear the team stats (but the goalie choice) and both penalty box lists, then set up the teams
ClearTeamStats:
	lda.w tmgoalie					; save both goalie choices
	pha
	lda.w tmgoalie+2
	pha
	ldx.w #$0000					; X = byte offset into the team stats
.clr:								; clear the team stats, a word at a time
	stz.w tmPwrGoals,x				; zero a stat word
	inx
	inx
	cpx.w #$01AC					; $01AC bytes cleared from tmPwrGoals
	bne .clr
	pla								; put the goalie choices back
	sta.w tmgoalie+2
	pla
	sta.w tmgoalie
	lda.w #$FFFF					; $FFFF ends a penalty box list
	sta.w tmboxlist					; home penalty box list empty
	sta.w tmboxlist+$1A				; visiting penalty box list empty (the second list is $1A bytes on)
; Point both team structures at their team: sort start, team number and data pointer. Called from
; ClearTeamStats and setoptions.
setteams:							;Set up both team structures from the home and visiting teams
	stz.w tmsort					; home: tmsort 0, away: tmsort $0C
	lda.w #$000C
	sta.w tmsort+2
	lda.w HomeTeam					; home team number
	sta.w tmteam
	asl a							; times 4: long pointer index
	asl a
	tax
	lda.l TeamList,x				; team data pointer
	sta.w tmdata
	lda.w VisTeam					; visiting team
	sta.w tmteam+2
	asl a
	asl a
	tax
	lda.l TeamList,x				; its data pointer
	sta.w tmdata+2
	rtl
