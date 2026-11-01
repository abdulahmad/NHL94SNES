; For each of the 5 pads: padchange = the buttons that changed, padnew1 = those newly pressed, then padlast1 =
; the buttons held
;
; Takes the PadRaw1 words. Called by ReadPads (jsr), once per frame. Returns nothing.
GetNewPresses:						; compare the 5 pads with the last frame
	lda.w PadRaw1					; pad 1
	eor.w padlast1
	sta.w padchange
	and.w PadRaw1
	sta.w padnew1
	lda.w PadRaw2					; pad 2
	eor.w padlast1+2
	sta.w padchange+2
	and.w PadRaw2
	sta.w padnew1+2
	lda.w PadRaw3					; pad 3
	eor.w padlast1+4
	sta.w padchange+4
	and.w PadRaw3
	sta.w padnew1+4
	lda.w PadRaw4					; pad 4
	eor.w padlast1+6
	sta.w padchange+6
	and.w PadRaw4
	sta.w padnew1+6
	lda.w PadRaw5					; pad 5
	eor.w padlast1+8
	sta.w padchange+8
	and.w PadRaw5
	sta.w padnew1+8
	lda.w PadRaw1					; remember the buttons held for the next frame
	sta.w padlast1
	lda.w PadRaw2
	sta.w padlast1+2
	lda.w PadRaw3
	sta.w padlast1+4
	lda.w PadRaw4
	sta.w padlast1+6
	lda.w PadRaw5
	sta.w padlast1+8
	rts								; return
