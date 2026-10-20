; Title: an empty sprite frame, then TitleWait
TitleBlankSprites:					; called from TitleScreen
	jsl.l SpriteFrameStart			; start a frame ...
	jsl.l SpriteFrameEnd			; ... and end it with no sprites
	ldx.w #$0023					; 35 frames
	jsl.l TitleWait					; wait
	rts								; done
