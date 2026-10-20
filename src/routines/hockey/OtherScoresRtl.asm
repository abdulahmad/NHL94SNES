; The rtl ShowOtherScores leaves through, then an unused IRQ wait
;
; Jumped to from ShowOtherScores; .waitirq has no caller.
OtherScoresRtl:						; the rtl ShowOtherScores leaves through
	rtl

.waitirq:							;unused: wait for the stats scroll IRQ to set
									;$1DCD, as ScrollGameStatsDown
	lda.w #$0000					; clear scrollirqdone and wait until it is $FFFF
	sta.w scrollirqdone
.loop:								; wait for the IRQ
	lda.w scrollirqdone
	cmp.w #$FFFF
	bne .loop
	rts
