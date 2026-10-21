; Matchups screen
ShowMatchups:						; called from ScoutingReport
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
	lda.w #$0020
	sta.b d0
	lda.w #$000B
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	jsl.l SpriteFrameStart
	ldx.w #$0056
	ldy.w #$0010
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
	lda.w VisTeam
	sta.b d1
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
	lda.w HomeTeam
	sta.b d1
	jsl.l DrawTeamBlocks			; entry: the block of team d1
	lda.w curitem
	bne .t1
	jmp.w .t2

.t1:								; curitem != 0: decrement curitem, setupvis = $FFFF, setuphome = $FFFF...
	dec.w curitem
	lda.w #$FFFF
	sta.l setupvis
	sta.l setuphome
	stz.b a2
	lda.w curitem
	sta.l matchuphome
	lda.w #$0002
	sta.b a2
	lda.w curitem
	sta.l matchupvis
	jsl.l DrawMatchupPictures
	lda.w #$3568
	sta.l colourbuf
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.w #$0002
	sta.b a2
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
	jsl.l GetMatchupPlayer			; d0 = the roster slot of team a2's player for matchup A
	lda.b d0
	sta.w curplayer
	lda.w #$0001
	sta.b d1
	jsl.l GetPlayerRating			; rating of curplayer with hot / cold
	lda.b d0
	pha
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l print
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
	lda.w curplayer
	sta.b d0
	jsl.l PlayerInitialName			; mesarea = the first initial
	jsl.l print
	stz.b a2
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
	jsl.l GetMatchupPlayer			; d0 = the roster slot of team a2's player for matchup A
	lda.b d0
	sta.w curplayer
	lda.w #$0001
	sta.b d1
	jsl.l GetPlayerRating			; rating of curplayer with hot / cold
	lda.b d0
	pha
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l print
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
	lda.w curplayer
	sta.b d0
	jsl.l PlayerInitialName			; mesarea = the first initial
	lda.w #$0021
	sec
	sbc.b [a1]
	sta.w printx
	jsl.l print
	inc.w curitem
	jmp.w .1

.t2:								; setuphome = HomeTeam, setupvis = VisTeam, call DrawMatchupPictures, ...
	lda.w HomeTeam
	sta.l setuphome
	lda.w VisTeam
	sta.l setupvis
	jsl.l DrawMatchupPictures
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.w #$0002
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
	jsl.l GetTeamRating				; d0 = the team rating of team a2
	lda.b d0
	pha
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l print
	stz.b a2
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
	jsl.l GetTeamRating				; d0 = the team rating of team a2
	lda.b d0
	pha
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l print
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
	lda.w curitem
	sta.b d0
	lda.w #LineSlotNames>>16
	sta.b a1+2
	lda.w #LineSlotNames
	sta.b a1
	jsl.l AdvanceStringPtr			; a1 = string d0 of the string list [a1]
	jsl.l print
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
	pla
	sta.b d0
	pla
	cmp.b d0
	beq .t2x
	bmi .t1x
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
