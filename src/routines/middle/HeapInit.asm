; The heap. Each bank holds a chain of blocks from HeapStart7E / HeapStart7F up to $FFF8. A block is a header
; of words (size, flags, next, previous) and its data. Flags 0 = free, bit 15 = used, bit 14 = locked.
; Callers keep handles (HandleTable entries pointing at the data), so unlocked blocks can move.
;
; start the heaps at X in bank $7E (at least $E68C) and Y in bank $7F: one free block each, all handles free
HeapInit:							; set up both heaps; one free block each, all handles free
	cpx.w #$E68C
	bcs .base
	ldx.w #$E68C
.base:								; start of the bank $7E heap kept
	stx.w HeapStart7E
	sty.w HeapStart7F
	lda.w #$FFFF
	sta.l Ram7E+6,x
	lda.w #$0000
	sta.l Ram7E+4,x
	sta.l Ram7E+2,x
	lda.w #$FFF8
	sec
	sbc.w HeapStart7E
	sta.l Ram7E,x
	tyx
	lda.w #$FFFF
	sta.l Ram7F+6,x
	lda.w #$0000
	sta.l Ram7F+4,x
	sta.l Ram7F+2,x
	lda.w #$FFF8
	sec
	sbc.w HeapStart7F
	sta.l Ram7F,x
	ldx.w #$00FE
	lda.w #$0000
.clear:								; clear the 64 handles
	sta.l HandleTable,x
	dex
	dex
	bpl .clear
	rtl
