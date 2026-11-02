; Pause for pad A: sfpj = A, then startpause
startpause_pad:						; called from demoread, doinput
	sta.w sfpj
	jmp.w startpause				; set the pause mode flag and return
