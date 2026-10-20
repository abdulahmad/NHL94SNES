; Set the frame hook back to the empty routine
ClearFrameHook:						; called from BlankScreen
	pha
	phx
	ldx.w #NullHook>>16
	lda.w #NullHook
	jsl.l SetFrameHook
	plx
	pla
	rtl
