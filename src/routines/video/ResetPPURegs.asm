; Reset the scroll, window and colour math registers and their copies
ResetPPURegs:						; called from forceblack
	pha
	stz.w BG1HScroll
	stz.w BG2HScroll
	stz.w BG3HScroll
	lda.w #$FFFF
	sta.w BG1VScroll
	sta.w BG2VScroll
	sta.w BG3VScroll
	lda.w #$FFF0
	sta.b ClipTopUnused
	sta.b r9
	lda.w #$00E0
	sta.b ClipBottomUnused
	lda.w #$0100
	sta.b r9+2
	sep #$20
	stz.w CGADSUB
	stz.w CGWSEL
	stz.w TMW
	stz.w MOSAIC
	stz.w SETINI
	stz.w TS
	stz.w TSW
	stz.w W12SEL
	stz.w W34SEL
	stz.w WOBJSEL
	stz.w Mode7InUse
	rep #$20
	pla
	rtl
