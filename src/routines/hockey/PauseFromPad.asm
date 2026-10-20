; Pause for pad A: pausepad = A, then startpause
PauseFromPad:						; called from demoread, doinput
	sta.w pausepad
	jmp.w startpause
