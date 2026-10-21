; HeapCompactBank for both banks
;
; Takes nothing, keeps all registers. Called by NewHandle when an allocation fails.
HeapCompact:						; compact the banks $7E and $7F heaps
	pha
	phx
	phy
	lda.w #Ram7E>>16				; bank $7E from its first block
	sta.b p0+2
	stz.b p0
	ldy.w HeapStart7E
	jsr.w HeapCompactBank
	lda.w #Ram7F>>16				; bank $7F from its first block
	sta.b p0+2
	stz.b p0
	ldy.w HeapStart7F
	jsr.w HeapCompactBank
	ply
	plx
	pla
	rtl
