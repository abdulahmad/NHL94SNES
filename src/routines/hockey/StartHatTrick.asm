; Start the hat trick sprites: clear the ten slots (hatstep) and set hattrick
StartHatTrick:						; called from ShowGoalBox
	phx
	ldx.w #$0012
	lda.w #$0000
.loop:								; loop: hatstep,x = A, X - 1, X - 1, ...
	sta.l hatstep,x
	dex
	dex
	bpl .loop
	plx
	lda.w #$0001
	sta.l hattrick
	rtl
