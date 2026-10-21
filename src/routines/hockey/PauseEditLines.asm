; Pause menu Edit Lines
PauseEditLines:						; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: pausesubmenu = $0001, call EditLinesScreen, pausesu...
	lda.w #$0001
	sta.l pausesubmenu
	jsl.l EditLinesScreen			; change the lines on the ice
	lda.w #$0000
	sta.l pausesubmenu
	jsl.l ReloadRink				; after a pause screen: unpack the rink map, tiles and palettes again
	bra PauseSubmenuDone
