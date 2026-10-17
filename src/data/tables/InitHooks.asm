; initial FrameHook, NMIHook, IRQHook (long pointers, copied to FrameHook ...) and random seed
InitHooks:							;initial FrameHook, NMIHook, IRQHook (long pointers, copied to FrameHook
									;...) and random seed
	dl NullHook&$FFFF,NullHook&$FFFF,IRQHook_Off&$FFFF	; bank $00 mirror
	dw $AFE5,$F527
