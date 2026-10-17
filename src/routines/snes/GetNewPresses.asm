; For each of the 5 pads: padchange = the buttons that changed, padnew = those newly pressed, then padlast =
; the buttons held
GetNewPresses:
	lda.w JoyPad
	eor.w padlast
	sta.w padchange
	and.w JoyPad
	sta.w padnew
	lda.w JoyPad+2
	eor.w padlast+2
	sta.w padchange+2
	and.w JoyPad+2
	sta.w padnew+2
	lda.w JoyPad+4
	eor.w padlast+4
	sta.w padchange+4
	and.w JoyPad+4
	sta.w padnew+4
	lda.w JoyPad+6
	eor.w padlast+6
	sta.w padchange+6
	and.w JoyPad+6
	sta.w padnew+6
	lda.w JoyPad+8
	eor.w padlast+8
	sta.w padchange+8
	and.w JoyPad+8
	sta.w padnew+8
	lda.w JoyPad
	sta.w padlast
	lda.w JoyPad+2
	sta.w padlast+2
	lda.w JoyPad+4
	sta.w padlast+4
	lda.w JoyPad+6
	sta.w padlast+6
	lda.w JoyPad+8
	sta.w padlast+8
	rts
