; Shootout shooters: the background, the Shootout title and the team
ShootersBackground:					; called from PrintShooterNames, ShootersSetup, ShootoutShooters
	lda.l drawlinesback				;redraw the background?
	beq .2							;no background redraw
	jsl.l DrawShootersBack			;draw the background
.2:									;draw the title
	jsl.l SpriteFrameStart			;start the sprite frame
	ldx.w #$0058					;x $58
	ldy.w #$0018					;y $18
	lda.w #ShootoutLabel>>16		;"Shootout" label
	sta.b a1+2
	lda.w #ShootoutLabel			;"Shootout" label
	sta.b a1
	jsl.l PrintLetterSprites		;draw the letter sprites
	lda.b a1+2						;save a1
	pha
	lda.b a1						;save a1
	pha
	lda.w #ShootersBackgroundPos>>16	;title position string
	sta.b a1+2
	lda.w #ShootersBackgroundPos	;title position string
	sta.b a1
	jsl.l print						;print the team title
	pla
	sta.b a1						;restore a1
	pla
	sta.b a1+2						;restore a1
	lda.w HomeTeam					;home team
	sta.b d1						;team for the block
	lda.b a2						;which team
	beq .1							;home team list
	lda.w VisTeam					;visitors team
	sta.b d1						;visitors
.1:									;draw the team parts
	jsl.l DrawTeamBlocks			;the team block of d1
	jsl.l DrawMatchupPictures		;the player pictures
	jsl.l SpriteFrameEnd			;end the sprite frame
	lda.l drawlinesback				;background redrawn this time?
	beq .rtl						;no new background: done
	jsl.l WaitFrame					;wait for the frame
	lda.w #$0050					;IRQ line 2
	sta.w irqline2					;split line $50
	lda.w #$0000					;clear the flag
	sta.l drawlinesback				;background drawn
.rtl:								;done
	rtl
