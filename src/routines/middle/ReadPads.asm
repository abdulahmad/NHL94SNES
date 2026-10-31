; Once per frame: each pad's direction, changed buttons and new presses
ReadPads:							; called from AskExitGame, BadPasswordPrompt, EditLinesMenu, EditLinesS...
	lda.w PadRaw1
	xba
	and.w #$000F
	tax
	lda.l PadDirection,x
	and.w #$00FF
	sta.w paddir
	lda.w PadRaw2
	xba
	and.w #$000F
	tax
	lda.l PadDirection,x
	and.w #$00FF
	sta.w paddir+2
	lda.w PadRaw3
	xba
	and.w #$000F
	tax
	lda.l PadDirection,x
	and.w #$00FF
	sta.w paddir+4
	lda.w PadRaw4
	xba
	and.w #$000F
	tax
	lda.l PadDirection,x
	and.w #$00FF
	sta.w paddir+6
	lda.w PadRaw5
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
