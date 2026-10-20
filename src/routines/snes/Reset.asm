; Reset vector: native mode, stack $1FFF, direct page 0, then Reset_Fast
Reset:								; entry point, no direct callers found
	clc
	xce
	rep #$30
	ldx.w #$1FFF
	txs
	lda.w #$0000
	tcd
	jml.l Reset_Fast
