; Player cards. Left and right change the player, start leaves.
ShowPlayerCards:					; called from PausePlayerCards
	jsl.l GetPauseTeam				; team of the pause controller
	lda.b a2
	pha
	stz.w FrameByNumber
	jsl.l LoadPlayerCardScreen		; set up the player card screen graphics and palettes
	pla
	sta.b a2
	lda.b a2
	pha
	stz.w curitem
	jsl.l GetPlayerCount			; count the players of the team
	lda.b d0
	clc
	adc.w #$0006
	sta.w listend
	jsl.l ScreenOn
	jsl.l DrawPlayerCard			; draw the player card
PlayerCardsRedraw:					; called from NextPlayerCard, PrevPlayerCard, SwapPlayerCardTeam
	jsl.l SendTextMap
PlayerCardsLoop:					; called from PlayerCardsWait
	jsl.l WaitFrame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l ReadPausePad				; ReadjoyA for the controller that owns the pause menu
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
	lda.b d1
	bit.w #$1000
	bne PlayerCardsExit
	bit.w #$0100
	bne NextPlayerCard
	bit.w #$0200
	bne PrevPlayerCard
	bit.w #$4000
	beq PlayerCardsWait
	jmp.w SwapPlayerCardTeam		; switch player cards to the other team
PlayerCardsWait:					; called from NextPlayerCard, PlayerCardsLoop, PrevPlayerCard
	bra PlayerCardsLoop
PlayerCardsExit:					; called from PlayerCardsLoop
	pla
	sta.b a2
	rtl
