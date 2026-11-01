; Pause menu Player Cards
PausePlayerCards:					; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: call PlayerCards, call ReloadRink, go to PauseS...
	jsl.l PlayerCards				; player cards
	jsl.l ReloadRink				; after a pause screen: unpack the rink map, tiles and palettes again
	jmp.w PauseSubmenuDone
