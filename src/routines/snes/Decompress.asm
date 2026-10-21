; unpack the data at [p0] to WRAM at [p1] by its format word ($FB10 LZ, $FB46 pairs, $FB30 Huffman,
Decompress:							; called from BuildRinkMap, DrawEditLinesBack, DrawPlayerPicture, DrawS...
		;   $FB7A run-length); X = the unpacked size from the header, or 1 for an unknown format
	php
	phb
	rep #$30
	jsl.l WaitDMAQueue
	lda.b p1+1
	sta.w WMADDM
	lda.b p1
	sta.w WMADDL
	lda.b p0+1
	pha
	plb
	plb
	ldy.b p0
	lda.w cmpsizelow,y
	xba
	pha
	lda.w cmpformat,y
	iny
	iny
	cmp.w #$FB10
	bne .t3
	jsr.w DecompressLZ
	bra .t4

.t3:								; if not zero go to .t1, ...
	cmp.w #$FB46
	bne .t1
	jsr.w DecompressPairs
	bra .t4

.t1:								; if not zero go to .t2, ...
	cmp.w #$FB30
	bne .t2
	jsr.w DecompressHuffman
	bra .t4

.t2:								; if not zero go to .t1x, ...
	cmp.w #$FB7A
	bne .t1x
	jsr.w DecompressRLE
	bra .t4

.t1x:								; return
	plx
	ldx.w #$0001
	plb
	plp
	rtl

.t4:								; return
	rep #$30
	plx
	plb
	plp
	rtl
