; Pause menu Game Stats
PauseGameStats:						; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: call ShowGameStats, call ReloadRink, go to PauseSub...
	jsl.l ShowGameStats
	jsl.l ReloadRink
	bra PauseSubmenuDone
