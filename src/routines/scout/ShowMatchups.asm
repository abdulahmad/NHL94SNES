; Matchups screen
ShowMatchups:						;matchups box: matchup curitem (0 = overall), both players or teams,
									;ratings and the advantage arrows; called from ScoutingReport
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowMatchupsPos>>16
	sta.b a1+2
	lda.w #ShowMatchupsPos
	sta.b a1
	jsl.l print						; print ShowMatchupsPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020					;32 wide
	sta.b d0
	lda.w #$000B					;11 high
	sta.b d1
	lda.l blankchar					;blank tile
	sta.b d2
	jsl.l eraser					;clear the box
	jsl.l SpriteFrameStart
	ldx.w #$0056					;x
	ldy.w #$0010					;y
	lda.w #MatchupsLabel>>16
	sta.b a1+2
	lda.w #MatchupsLabel
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites MatchupsLabel
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowMatchupsPos2>>16
	sta.b a1+2
	lda.w #ShowMatchupsPos2
	sta.b a1
	jsl.l print						; print ShowMatchupsPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w VisTeam					;visitors
	sta.b d1						;d1
	jsl.l DrawTeamBlocks			; entry: the block of team d1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowMatchupsPos3>>16
	sta.b a1+2
	lda.w #ShowMatchupsPos3
	sta.b a1
	jsl.l print						; print ShowMatchupsPos3
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w HomeTeam					;home
	sta.b d1						;d1
	jsl.l DrawTeamBlocks			; entry: the block of team d1
	lda.w curitem					;matchup
	bne .t1							;a position: show the two players
	jmp.w .t2						;0: overall team ratings

.t1:								;matchup curitem - 1: players' photos, ratings and names
	dec.w curitem					;position index
	lda.w #$FFFF					;no team photos
	sta.l setupvis
	sta.l setuphome
	stz.b a2						;home side
	lda.w curitem					;position
	sta.l matchuphome				;home player for it
	lda.w #$0002					;visitors side
	sta.b a2
	lda.w curitem					;position
	sta.l matchupvis				;visitors player for it
	jsl.l DrawMatchupPictures		;their photos
	lda.w #$3568					;backdrop colour
	sta.l colourbuf					;set
	jsl.l SendColours				;send the colours
	lda.w #$0002
	sta.b a2						;visitors
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowMatchupsPos4>>16
	sta.b a1+2
	lda.w #ShowMatchupsPos4
	sta.b a1
	jsl.l print						; print ShowMatchupsPos4
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w curitem
	jsl.l GetMatchupPlayer			;visitors' player
	lda.b d0
	sta.w curplayer					;curplayer
	lda.w #$0001					;scale 1
	sta.b d1
	jsl.l GetPlayerRating			;rating
	lda.b d0
	pha								;kept for the arrows
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			;push it
	jsl.l print						;print it
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowMatchupsPos5>>16
	sta.b a1+2
	lda.w #ShowMatchupsPos5
	sta.b a1
	jsl.l print						; print ShowMatchupsPos5
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w curplayer					;player
	sta.b d0
	jsl.l PlayerInitialName			;initial and name
	jsl.l print						;print it
	stz.b a2						;home
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowMatchupsPos6>>16
	sta.b a1+2
	lda.w #ShowMatchupsPos6
	sta.b a1
	jsl.l print						; print ShowMatchupsPos6
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w curitem
	jsl.l GetMatchupPlayer			;home player
	lda.b d0
	sta.w curplayer					;curplayer
	lda.w #$0001					;scale 1
	sta.b d1
	jsl.l GetPlayerRating			;rating
	lda.b d0
	pha								;kept for the arrows
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			;push it
	jsl.l print						;print it
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowMatchupsPos7>>16
	sta.b a1+2
	lda.w #ShowMatchupsPos7
	sta.b a1
	jsl.l print						; print ShowMatchupsPos7
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w curplayer					;player
	sta.b d0
	jsl.l PlayerInitialName			;initial and name
	lda.w #$0021					;right edge 33
	sec
	sbc.b [a1]						;minus the length
	sta.w printx					;right aligned
	jsl.l print						;print it
	inc.w curitem					;back to the matchup number
	jmp.w .1						;advantage

.t2:								;overall: team logos and ratings
	lda.w HomeTeam
	sta.l setuphome
	lda.w VisTeam
	sta.l setupvis
	jsl.l DrawMatchupPictures
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.w #$0002					;visitors
	sta.b a2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #OverallTxt>>16
	sta.b a1+2
	lda.w #OverallTxt
	sta.b a1
	jsl.l print						; print OverallTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l GetTeamRating				;team rating
	lda.b d0
	pha								;kept for the arrows
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			;push it
	jsl.l print						;print it
	stz.b a2						;home
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #OverallTxt2>>16
	sta.b a1+2
	lda.w #OverallTxt2
	sta.b a1
	jsl.l print						; print OverallTxt2
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l GetTeamRating				;team rating
	lda.b d0
	pha								;kept for the arrows
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			;push it
	jsl.l print						;print it
.1:									; a1 = ShowMatchupsPos8, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowMatchupsPos8>>16
	sta.b a1+2
	lda.w #ShowMatchupsPos8
	sta.b a1
	jsl.l print						; print ShowMatchupsPos8
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w curitem					;matchup
	sta.b d0						;name index
	lda.w #LineSlotNames>>16
	sta.b a1+2
	lda.w #LineSlotNames
	sta.b a1
	jsl.l AdvanceStringPtr			;matchup name
	jsl.l print						;print it
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #AdvantageTxt>>16
	sta.b a1+2
	lda.w #AdvantageTxt
	sta.b a1
	jsl.l print						; print AdvantageTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	pla								;home rating
	sta.b d0
	pla								;visitors rating
	cmp.b d0						;same?
	beq .t2x						;yes: none
	bmi .t1x						;home higher
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #UpArrowsTxt>>16
	sta.b a1+2
	lda.w #UpArrowsTxt
	sta.b a1
	jsl.l print						; print UpArrowsTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .2

.t1x:								; a1 = DownArrowsTxt, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DownArrowsTxt>>16
	sta.b a1+2
	lda.w #DownArrowsTxt
	sta.b a1
	jsl.l print						; print DownArrowsTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .2

.t2x:								; a1 = NoneTxt, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #NoneTxt>>16
	sta.b a1+2
	lda.w #NoneTxt
	sta.b a1
	jsl.l print						; print NoneTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
.2:									; call WaitFrame, call SpriteFrameEnd, return
	jsl.l WaitFrame
	jsl.l SpriteFrameEnd
	rtl
