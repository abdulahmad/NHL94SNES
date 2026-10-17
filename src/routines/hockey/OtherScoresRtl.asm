; The rtl ShowOtherScores leaves through, then an unused IRQ wait
OtherScoresRtl:
	rtl

.waitirq:							;unused: wait for the stats scroll IRQ to set
									;$1DCD, as ScrollGameStatsDown
	lda.w #$0000
	sta.w scrollirqdone
.loop:
	lda.w scrollirqdone
	cmp.w #$FFFF
	bne .loop
	rts
