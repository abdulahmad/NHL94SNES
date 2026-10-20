; Player cards. Left and right change the player, start leaves.
ShowPlayerCards:					; called from PausePlayerCards
	jsl.l GetPauseTeam
	lda.b a2
	pha
	stz.w FrameByNumber
	jsl.l LoadPlayerCardScreen
	pla
	sta.b a2
	lda.b a2
	pha
	stz.w curitem
	jsl.l GetPlayerCount
	lda.b d0
	clc
	adc.w #$0006
	sta.w listend
	jsl.l ScreenOn
	jsl.l DrawPlayerCard
PlayerCardsRedraw:					; called from NextPlayerCard, PrevPlayerCard, SwapPlayerCardTeam
	jsl.l SendTextMap
PlayerCardsLoop:					; called from PlayerCardsWait
	jsl.l WaitFrame
	jsl.l ReadPads
	jsl.l ReadPausePad
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$1000
	bne PlayerCardsExit
	bit.w #$0100
	bne NextPlayerCard
	bit.w #$0200
	bne PrevPlayerCard
	bit.w #$4000
	beq PlayerCardsWait
	jmp.w SwapPlayerCardTeam
PlayerCardsWait:					; called from NextPlayerCard, PlayerCardsLoop, PrevPlayerCard
	bra PlayerCardsLoop
PlayerCardsExit:					; called from PlayerCardsLoop
	pla
	sta.b a2
	rtl
