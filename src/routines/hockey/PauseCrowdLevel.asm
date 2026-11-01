; Pause menu Crowd Level
PauseCrowdLevel:					; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: call CrowdMeterScreen, call ReloadRink, go to...
	jsl.l CrowdMeterScreen			; crowd meter screen
	jsl.l ReloadRink				; after a pause screen: unpack the rink map, tiles and palettes again
	jmp.w PauseSubmenuDone
