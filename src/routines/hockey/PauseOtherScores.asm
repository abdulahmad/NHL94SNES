; Pause menu Other Scores
PauseOtherScores:					; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: call ShowOtherScores, call ReloadRink, go to PauseS...
	jsl.l ShowOtherScores			; other scores screen
	jsl.l ReloadRink				; after a pause screen: unpack the rink map, tiles and palettes again
	jmp.w PauseSubmenuDone
