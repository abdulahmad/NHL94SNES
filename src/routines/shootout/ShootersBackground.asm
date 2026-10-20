; Shootout shooters: the background, the Shootout title and the team
ShootersBackground:					; called from PrintShooterNames, ShootersSetup, ShootoutShooters
	lda.l drawlinesback
	beq .2
	jsl.l DrawShootersBack
.2:									; call SpriteFrameStart, a1 = ShootoutLabel, call PrintLetterSprites, ...
	jsl.l SpriteFrameStart
	ldx.w #$0058
	ldy.w #$0018
	lda.w #ShootoutLabel>>16
	sta.b a1+2
	lda.w #ShootoutLabel
	sta.b a1
	jsl.l PrintLetterSprites
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShootersBackgroundPos>>16
	sta.b a1+2
	lda.w #ShootersBackgroundPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w HomeTeam
	sta.b d1
	lda.b a2
	beq .1
	lda.w VisTeam
	sta.b d1
.1:									; call DrawTeamBlocks, call DrawMatchupPictures, call SpriteFrameEnd, ...
	jsl.l DrawTeamBlocks
	jsl.l DrawMatchupPictures
	jsl.l SpriteFrameEnd
	lda.l drawlinesback
	beq .rtl
	jsl.l WaitFrame
	lda.w #$0050
	sta.w irqline2
	lda.w #$0000
	sta.l drawlinesback
.rtl:								; return
	rtl
