; Pause started from controller 1: pausepad = 0, then startpause
;
; Called from demoread (Start pressed on pad 1 in the demo).
startpause1:						; pause from pad 1
	stz.w pausepad					; pausepad = pad 0
	jmp.w startpause				; set the pause flag

.t1:								; unreferenced second jump to startpause
	jmp.w startpause				; set the pause mode flag and return
