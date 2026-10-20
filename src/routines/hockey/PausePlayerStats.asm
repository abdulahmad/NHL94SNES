; Pause menu Player Stats
PausePlayerStats:					; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: call ShowPlayerStats, call ReloadRink, go to PauseS...
	jsl.l ShowPlayerStats
	jsl.l ReloadRink
	jmp.w PauseSubmenuDone
