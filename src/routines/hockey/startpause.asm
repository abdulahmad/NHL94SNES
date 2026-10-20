; Start a pause (sflags sfpz)
;
; Called from PauseFromPad, startpause1 and StartPer.
startpause:							; set the pause mode flag and return
	lda.w #sfpz						; sfpz = pause mode
	tsb.w sflags					; set it in sflags
	rtl
