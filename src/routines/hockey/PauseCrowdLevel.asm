; Pause menu Crowd Level
PauseCrowdLevel:					; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: call ShowCrowdMeter, call ReloadRink, go to PauseSu...
	jsl.l ShowCrowdMeter
	jsl.l ReloadRink
	jmp.w PauseSubmenuDone
