; Pause menu Shootout Setup
PauseShootoutSetup:					; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: pausesubmenu = $0001, call ShootoutShooters, pauses...
	lda.w #$0001
	sta.l pausesubmenu
	jsl.l ShootoutShooters
	lda.w #$0000
	sta.l pausesubmenu
	jsl.l ReloadRink
	bra PauseSubmenuDone
