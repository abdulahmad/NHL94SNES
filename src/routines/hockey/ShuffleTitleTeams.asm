; Fill titleteams with the 26 team numbers in random order (RandomWord, no repeats)
ShuffleTitleTeams:					; no input; fills titleteams; called from TitleScreen
	stz.w TitleTeamIdx				; none chosen yet
	ldx.w #$0000					; x = byte index of the list
	lda.w #$0000
.1:									; pick a candidate
	jsl.l RandomWord				; random number
	and.w #$001F					; 0 to 31
	cmp.w #$001A					; 26 teams
	bcs .1							; 26 or more: pick again
	phx								; keep the index
	ldx.w #$0000					; search the chosen so far
.loop:								; compare with each chosen team
	cpx.w TitleTeamIdx				; all compared?
	bcs .t2							; yes, new team
	cmp.l titleteams,x				; same team?
	beq .t1							; yes, pick again
	inx
	inx
	bra .loop						; next

.t1:								; repeat
	plx								; restore the index
	bra .1							; pick again

.t2:								; new team
	plx								; restore the index
	sta.l titleteams,x				; store the team
	inx
	inx
	stx.w TitleTeamIdx				; count of chosen teams (bytes)
	cpx.w #$0034					; all 26 chosen?
	bcc .1							; no
	stz.w TitleTeamIdx				; start at the first
	rts
