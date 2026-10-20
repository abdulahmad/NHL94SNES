; Wait for a frame, set the default hooks, turn the IRQ off, force blank and stop HDMA
BlankScreen:						; called from forceblack
	jsl.l WaitFrame
	jsl.l IRQOff
	jsl.l ClearFrameHook
	jsl.l ClearNMIHook
	sep #$20
	lda.b #$8F
	sta.w IniDispShadow
	jsl.l WaitFrame
	stz.w HDMAEN
	rep #$20
	lda.b DMAQueueHead
	sta.b DMAQueueTail
	rtl
