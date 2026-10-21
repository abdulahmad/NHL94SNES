; Run one frame of game logic
DoGameFrame:						; called from Gameloop, StartHL2
	jsl.l SpriteFrameStart
	jsl.l UpdateBenchCheer
	jsl.l periodicevents			; periodicevents
	jsl.l updateplayers				; updateplayers
	jsl.l checkwindow				; checkwindow
	jsl.l updatereplay				; updatereplay
	jsl.l setvideo
	jsl.l SpriteFrameEnd
	rtl
