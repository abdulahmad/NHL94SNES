; Switch player stats to the other team and redraw the heading.
SwapPlayerStatsTeam:				; a2 = team side; called from PlayerStatsScreen, SetPlayerStatsRange
	lda.b a2
	eor.w #$0002					; other team (0 <-> 2)
	sta.b a2
	jsl.l SetPlayerStatsRange		; list range of that team
	jsl.l InitStatsOrder			; reset the sort order
	jsl.l SortPlayerStats			; sort the rows
	jsl.l SpriteFrameStart			; new sprite frame
	ldx.b a2						; team side
	lda.w HomeTeam,x				; its team number
	sta.l setupvis					; used for the team picture
	ldx.w #$0049					; x = 73
	ldy.w #$0018					; y = 24
	lda.w #PlayerStatsHeading>>16	; a1 = the heading text
	sta.b a1+2
	lda.w #PlayerStatsHeading
	sta.b a1
	jsl.l PrintLetterSprites		; print it
	jsl.l DrawMatchupPictures		; team pictures
	jsl.l WaitFrame					; show the frame
	jsl.l DrawPlayerStatsPage		; draw the stats page
	jsl.l SpriteFrameEnd			; close the frame
	jsl.l SendColours				; send the palette
	jmp.w PlayerStatsScreen_redraw	; redraw and return
