; Erase the scouting report name line
EraseScoutName:						; entry point, no direct callers found
	jsl.l ScoutNamePos				; set the print position of a scouting report name
	lda.w #$000B
	sta.b d0
	lda.w #$0002
	sta.b d1
	lda.l blankchar
	sta.b d2
	jml.l eraser
