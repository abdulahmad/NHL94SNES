; Wait until every standard pad (low nibble 0) has no button down
; Takes nothing. Loops over the 5 pads (X = 0..8): a pad whose low nibble is not 0 (not a standard pad) is
; skipped; if a standard pad has a button down, the scan starts again. Registers are preserved.
;
; Called from PlayerSelect.
WaitPadsRelease:					; wait until no standard pad has a button down
	phx
	pha
.loop:								; rescan from the last pad
	ldx.w #$0008					; pad offset, 5 pads
.loop2:								; next pad
	lda.w JoyPad,x					; buttons held on pad X
	bit.w #$000F					; low nibble set: not a standard pad
	bne .1							; skip this pad
	and.w #$FFF0					; buttons only
	bne .loop						; one is down: rescan
.1:									; next pad
	dex
	dex
	bpl .loop2
	pla
	plx
	rtl
