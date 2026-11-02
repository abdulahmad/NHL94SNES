; Line editor: the EditLinesLabel title sprites, the team name and picture; the background first when
; drawlinesback is set
DrawEditLinesTitle:					; called from DrawEditLinesTop, PrintLinePlayers
	lda.l drawlinesback
	beq .1
	jsr.w DrawEditLinesBack			; redraw the line editor background: clear the top, the frame
.1:									; call SpriteFrameStart, a1 = EditLinesLabel, call PrintLetterSprites, ...
	jsl.l SpriteFrameStart
	ldx.w #$0058
	ldy.w #$0018
	lda.w #EditLinesLabel>>16
	sta.b a1+2
	lda.w #EditLinesLabel
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites EditLinesLabel
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawEditLinesTitlePos>>16
	sta.b a1+2
	lda.w #DrawEditLinesTitlePos
	sta.b a1
	jsl.l print						; print DrawEditLinesTitlePos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w HomeTeam
	sta.b d1
	lda.b a2
	beq .3
.2:									; d1 = VisTeam
	lda.w VisTeam
	sta.b d1
	lda.w #$0030
.3:									; d0 = A, call DrawTeamBlocks, call DrawMatchupPictures, ...
	sta.b d0
	jsl.l DrawTeamBlocks			; entry: the block of team d1
	jsl.l DrawMatchupPictures
	jsl.l SpriteFrameEnd
	lda.l drawlinesback
	beq .4
	jsl.l WaitFrame
	lda.w #$0068
	sta.w irqline2
	lda.w #$0000
	sta.l drawlinesback
.4:									; call SendColours, return
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	rtl
