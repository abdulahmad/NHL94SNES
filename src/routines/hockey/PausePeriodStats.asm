; Pause menu Period Stats
PausePeriodStats:					; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: call ShowPeriodStats, call ReloadRink, go to PauseS...
	jsl.l ShowPeriodStats			; period stats for both teams
	jsl.l ReloadRink				; after a pause screen: unpack the rink map, tiles and palettes again
	jmp.w PauseSubmenuDone
