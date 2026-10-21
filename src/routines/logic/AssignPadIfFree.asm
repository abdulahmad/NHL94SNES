; AssignPadPlayer when player d0 has no pad yet (playerpad negative)
AssignPadIfFree:					; called from dopass_count, puckglue
	ldy.b d0
	lda.w playerpad,y
	bpl .rtl
	jsl.l AssignPadPlayer			; pad d4 takes control of player d0: its old player is released
.rtl:								; return
	rtl
