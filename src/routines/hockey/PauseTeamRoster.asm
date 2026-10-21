; Pause menu Team Roster
PauseTeamRoster:					; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: call TeamRoster, call ReloadRink, go to PauseSubmen...
	jsl.l TeamRoster				; roster screen of a team
	jsl.l ReloadRink				; after a pause screen: unpack the rink map, tiles and palettes again
	bra PauseSubmenuDone
