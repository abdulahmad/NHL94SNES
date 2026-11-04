; Clear the list of called penalties
ClearPenaltyBuffer:					; called from PenGoalStuff, PlayShootout, SetupPenaltyShot, StartHL2, c...
	lda.w #$001F
	sta.b d0
	lda.w #$0000
	sta.b a0+2
	lda.w #PenBuf
	sta.b a0
.loop:								; loop: [a0] = $0000, increment a0, increment a0, ...
	lda.w #$0000
	sta.b [a0]
	inc.b a0						; next word
	inc.b a0
	dec.b d0						; count down
	bpl .loop
	rtl
