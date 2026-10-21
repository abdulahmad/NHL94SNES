; Wait until every pad that has a side (cont1team) has no button down
; Takes nothing. Loops over the pads (X = 0..8): a pad without a team (cont1team = 0) is ignored, a pad with a
; team that has anything held restarts the scan. Registers are preserved.
;
; Called from ScoutingReport.
WaitSidePadsRelease:				; wait until the pads that have a team are released
	phx
	pha
.loop:								; rescan from the last pad
	ldx.w #$0008					; pad offset
.loop2:								; next pad
	lda.w cont1team,x				; team of pad X
	beq .1							; no team: ignore the pad
	lda.w JoyPad,x					; buttons held on the pad
	bne .loop						; still held: rescan
.1:									; next pad
	dex
	dex
	bpl .loop2
	pla
	plx
	rtl
