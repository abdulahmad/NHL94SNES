; AssignPadPlayer when player d0 has no pad yet ($19D4 negative)
AssignPadIfFree:					; called from dopass_count, puckglue
	ldy.b d0
	lda.w playerpad,y
	bpl .rtl
	jsl.l AssignPadPlayer
.rtl:								; return
	rtl
