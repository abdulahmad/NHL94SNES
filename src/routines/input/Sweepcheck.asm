; Start a sweep check by player X (SPAsweepchk, held in pf2aip)
;
; Takes X = player. Called from findpc and skatetopuck.
Sweepcheck:							; start a sweep check by player X
	lda.w #SPAsweepchk				; SPAsweepchk
	sta.w pf2aip,x					; hold it in pf2aip
	jml.l SetSPAFromA				; start the animation
