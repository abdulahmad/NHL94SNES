; Pause for pad A: sfpj = A, then startpause
PauseFromPad:						; called from demoread, doinput
	sta.w sfpj
	jmp.w startpause				; set the pause mode flag and return
