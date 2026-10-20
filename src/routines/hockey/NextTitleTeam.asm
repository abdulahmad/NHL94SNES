; A = the next team of the shuffled list ($0BD5), shuffling again after the 26th
;
; Returns A = team. Called from TitleScreen.
NextTitleTeam:						; A = next team of the shuffled title list
	lda.w TitleTeamIdx				; index + 1, wrap at 26 (reshuffle)
	inc a
	cmp.w #$001A
	bcc .1
	jsr.w ShuffleTitleTeams			; reshuffle with ShuffleTitleTeams, index 0
	lda.w #$0000
.1:									; store the index
	sta.w TitleTeamIdx				; store the index and fetch the team from titleteams
	asl a
	tax
	lda.l titleteams,x
	rts
