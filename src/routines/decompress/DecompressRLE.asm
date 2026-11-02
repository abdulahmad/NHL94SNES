; run-length data at Y to WRAM: literal runs and repeats, of bytes if its header word is $0101,
DecompressRLE:						; called from Decompress
									;else of byte pairs
	iny
	iny
	iny
	lda.w $0000,y
	iny
	cmp.w #$0101
	bne .3
	lda.w #$0000
	sep #$20
	bra .2
.1:									; loop: eor #$FF
	eor.b #$FF
	tax
.loop:								; loop: Y + 1, WMDATA = $0000,y, X - 1, ...
	iny
	lda.w $0000,y
	sta.w WMDATA
	dex
	bpl .loop
.2:									; Y + 1, if $0000,y negative go to .1, ...
	iny
	lda.w $0000,y
	bmi .1
	beq .rts
.loopx:								; loop: Y + 1
	tax
	iny
	lda.w $0000,y
.loop2:								; loop: WMDATA = A, X - 1, if X still >= 0 go to .loop2, ...
	sta.w WMDATA
	dex
	bpl .loop2
	iny
	lda.w $0000,y
	bmi .1
	bne .loopx
.rts:								; return
	rts
.3:									; go to .2x
	lda.w #$0000
	sep #$20
	bra .2x
.1x:								; loop: eor #$FF
	eor.b #$FF
	tax
.loopxx:							; loop: Y + 1, WMDATA = $0000,y, Y + 1, ...
	iny
	lda.w $0000,y
	sta.w WMDATA
	iny
	lda.w $0000,y
	sta.w WMDATA
	dex
	bpl .loopxx
.2x:								; Y + 1, if $0000,y negative go to .1x, ...
	iny
	lda.w $0000,y
	bmi .1x
	beq .rtsx
.loopxxx:							; loop: Y + 1, xba, Y + 1, ...
	tax
	iny
	lda.w $0000,y
	xba
	iny
	lda.w $0000,y
.loop2x:							; loop: xba, WMDATA = A, xba, ...
	xba
	sta.w WMDATA
	xba
	sta.w WMDATA
	dex
	bpl .loop2x
	lda.b #$00
	xba
	iny
	lda.w $0000,y
	bmi .1x
	bne .loopxxx
.rtsx:								; return
	rts
