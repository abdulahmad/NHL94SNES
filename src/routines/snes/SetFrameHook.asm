; Run the routine at X:A as the frame hook of the next NMI
SetFrameHook:						; called from ClearFrameHook, FadeIn, FadeOut, IntroSequence, ReplayMod...
	sep #$10
	stx.w FrameHookNext+2
	sta.w FrameHookNext
	rep #$10
	rtl
