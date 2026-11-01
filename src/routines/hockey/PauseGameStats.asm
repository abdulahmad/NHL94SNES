; Pause menu Game Stats
PauseGameStats:						; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: call StatsReport, call ReloadRink, go to PauseSub...
	jsl.l StatsReport				; game stats screen: both teams and the stat rows
	jsl.l ReloadRink				; after a pause screen: unpack the rink map, tiles and palettes again
	bra PauseSubmenuDone
