; Once per frame: each pad's direction, changed buttons and new presses
ReadPads:							; called from AskExitGame, BadPasswordPrompt, EditLinesMenu, EditLinesS...
	lda.w JoyPad
	xba
	and.w #$000F
	tax
	lda.l PadDirection,x
	and.w #$00FF
	sta.w paddir
	lda.w JoyPad+2
	xba
	and.w #$000F
	tax
	lda.l PadDirection,x
	and.w #$00FF
	sta.w paddir+2
	lda.w JoyPad+4
	xba
	and.w #$000F
	tax
	lda.l PadDirection,x
	and.w #$00FF
	sta.w paddir+4
	lda.w JoyPad+6
	xba
	and.w #$000F
	tax
	lda.l PadDirection,x
	and.w #$00FF
	sta.w paddir+6
	lda.w JoyPad+8
	xba
	and.w #$000F
	tax
	lda.l PadDirection,x
	and.w #$00FF
	sta.w paddir+8
	jsr.w GetNewPresses				; compare the 5 pads with the last frame
	lda.w padchange
	ora.w padchange+2
	ora.w padchange+4
	ora.w padchange+6
	ora.w padchange+8
	sta.w padchangeany
	rtl
