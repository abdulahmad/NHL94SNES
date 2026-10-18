; Start a sweep check by player X (SPAsweepchk, held in pf2aip)
Sweepcheck:
	lda.w #SPAsweepchk
	sta.w pf2aip,x
	jml.l SetSPAFromA
