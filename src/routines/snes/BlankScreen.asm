; Wait for a frame, set the default hooks, turn the IRQ off, force blank and stop HDMA
BlankScreen:						; called from forceblack
	jsl.l WaitFrame
	jsl.l IRQOff					; stop the IRQs
	jsl.l ClearFrameHook			; set the frame hook back to the empty routine
	jsl.l ClearNMIHook				; set the NMI hook back to the empty routine
	sep #$20
	lda.b #$8F
	sta.w IniDispShadow
	jsl.l WaitFrame
	stz.w HDMAEN
	rep #$20
	lda.b DMAQueueHead
	sta.b DMAQueueTail
	rtl
