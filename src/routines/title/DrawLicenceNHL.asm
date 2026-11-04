; Licence screen: the NHL shield, the NHLPA logo and "Officially licensed product of the National Hockey
; League" (title sprites 9, 10, 11)
DrawLicenceNHL:						; called from TitleScreen
	jsl.l SpriteFrameStart
	lda.w #titlesprbuf>>16
	sta.b p1+2
	lda.w #titlesprbuf
	sta.b p1
	lda.w #$0009
	jsr.w DrawTitleSprite
	lda.w #$000A
	jsr.w DrawTitleSprite
	lda.w #$000B
	sta.b r0
	ldx.w #$003C
	ldy.w #$00B0
	lda.w #$2800
	jsl.l DrawSprite
	jsl.l SpriteFrameEnd
	rts
