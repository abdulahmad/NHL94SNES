; Clear the message rows and redraw the PlayerSelectAlt title and the team pictures
RedrawPlayerSelect:					; no input; returns nothing
	jsl.l ClearTextMapBottom		; clear the message rows
	jsl.l SpriteFrameStart			; new sprite frame
	ldx.w #$0047					; x = 71
	ldy.w #$0018					; y = 24
	lda.w #PlayerSelectAlt>>16		; a1 = the title text
	sta.b a1+2
	lda.w #PlayerSelectAlt
	sta.b a1
	jsl.l PrintLetterSprites		; print it as letter sprites
	jsl.l DrawMatchupPictures		; the team pictures
	jsl.l WaitFrame					; show the frame
	jsl.l SpriteFrameEnd			; close the sprite frame
	rtl
