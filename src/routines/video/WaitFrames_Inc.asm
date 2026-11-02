; Wait X frames, Y counting the rounds of 65536 (the _Inc entry adds 1 to Y first)
; Takes X = frame count, Y = count of rounds of 65536 frames. WaitFrames_Inc first adds 1 to Y so that
; X = 0, Y = 0 does not wait forever; WaitFrames is the entry without it.
;
; Called from PauseTimeout, TitleWait and ReplayMode.
WaitFrames_Inc:						; wait X frames, Y rounds (adds 1 to Y first)
	iny

WaitFrames:							; wait X + 65536 * Y frames
	jsl.l WaitFrame
	dex
	bne WaitFrames
	dey
	bne WaitFrames
	rtl
