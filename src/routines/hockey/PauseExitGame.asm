; Pause menu Exit Game
PauseExitGame:						; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t2
	jmp.w PauseMenuPoll

.t2:								; d1 bit $8080 set: call AskExitGame, if not zero go to .t1, ...
	jsl.l AskExitGame				; yes or No exit prompt
	cmp.w #$0000
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; FrameByNumber = 0, go to Opening2
	stz.w FrameByNumber
	jml.l Opening2					; start over at the option screens
