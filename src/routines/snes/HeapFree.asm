; free bytes of both heaps in X:A
;
; Returns X:A = the free bytes of the two heaps. No caller found in the ROM.
HeapFree:							; free bytes of both heaps in X:A
	stz.b r3						; total = 0
	stz.b r3+2
	stz.b p0						; bank $7E from its first block
	lda.w #Ram7E>>16
	sta.b p0+2
	ldy.w HeapStart7E
	jsr.w HeapFreeBank				; add the sizes of the free blocks of the chain
	lda.w #Ram7F>>16				; bank $7F from its first block
	sta.b p0+2
	ldy.w HeapStart7F
	jsr.w HeapFreeBank				; add the sizes of the free blocks of the chain
	ldx.b r3+2
	lda.b r3
	rtl
