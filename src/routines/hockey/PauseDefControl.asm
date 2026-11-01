; Pause menu: toggle defensive control
PauseDefControl:					; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8380
	beq PauseDefStore
	jsl.l seta2						; a2 = the team of the controller that paused, from its side
	ldy.b a2
	lda.w defcontrol,y
	eor.w #$0001
	sta.w defcontrol,y
PauseDefStore:						; called from PauseDefControl, PauseTimeout
	jmp.w PauseMenuPoll
