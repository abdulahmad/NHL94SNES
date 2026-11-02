; Reset vector (93S/Genesis Start): native mode, stack $1FFF, direct page 0, then Reset_Fast
Start:								; entry point (RESET vector), no direct callers
	clc
	xce
	rep #$30
	ldx.w #$1FFF
	txs
	lda.w #$0000
	tcd
	jml.l Reset_Fast				; reset in FastROM: clear the PPU and CPU registers, then start the game
