; free bytes of both heaps in X:A
HeapFree:							; free bytes of both heaps in X:A
	stz.b r3
	stz.b r3+2
	stz.b p0
	lda.w #$007E
	sta.b p0+2
	ldy.w HeapStart7E
	jsr.w HeapFreeBank
	lda.w #$007F
	sta.b p0+2
	ldy.w HeapStart7F
	jsr.w HeapFreeBank
	ldx.b r3+2
	lda.b r3
	rtl
