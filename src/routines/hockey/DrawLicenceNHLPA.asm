; Licence screen: the two logos, the NHL line moved up and "Players Association" under it (title sprites 9-12)
DrawLicenceNHLPA:					; called from TitleScreen
	jsl.l SpriteFrameStart
	lda.w #$007F
	sta.b p1+2
	lda.w #$5000
	sta.b p1
	lda.w #$0009
	jsr.w DrawTitleSprite
	lda.w #$000A
	jsr.w DrawTitleSprite
	lda.w #$000B
	sta.b r0
	ldx.w #$003C
	ldy.w #$00A0
	lda.w #$2800
	jsl.l DrawSprite
	lda.w #$000C
	sta.b r0
	ldx.w #$003C
	ldy.w #$00D0
	lda.w #$2800
	jsl.l DrawSprite
	jsl.l SpriteFrameEnd
	rts
