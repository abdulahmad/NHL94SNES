; Wait for the next frame (FrameCount changes)
; Takes nothing, returns when FrameCount has changed (it is incremented by the NMI).
;
; Called from SetupScreen, SelectLinePlayer, TeamRoster, setoptions and many others.
WaitFrame:							; wait for the next frame
	pha
	lda.w FrameCount
.loop:								; wait until the NMI has run
	cmp.w FrameCount
	beq .loop
	pla
	rtl
