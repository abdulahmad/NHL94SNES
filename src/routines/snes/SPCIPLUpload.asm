; send the stream at [p0] through the boot loader: blocks of length, sound RAM address and data;
SPCIPLUpload:						; called from Reset_Fast
		;   length 0 ends it with the start address
	rep #$30
	ldy.w #$0000
	lda.w #$BBAA
.loop:								; loop: if not zero go to .loop, ...
	cmp.w APUIO0
	bne .loop
	sep #$20
	lda.b #$CC
	bra .4
.1:									; Y + 1, xba, go to .3
	lda.b [p0],y
	iny
	xba
	lda.b #$00
	bra .3
.2:									; loop: X not yet 0: xba, Y + 1, xba
	xba
	lda.b [p0],y
	iny
	xba
.loopx:								; loop: if not zero go to .loopx, ...
	cmp.w APUIO0
	bne .loopx
	inc a
.3:									; APUIO0 = A, X - 1, if X not yet 0 go to .2
	rep #$20
	sta.w APUIO0
	sep #$20
	dex
	bne .2
.loopxx:							; loop: if not zero go to .loopxx
	cmp.w APUIO0
	bne .loopxx
.loop2:								; loop: adc #$03, if zero go to .loop2
	adc.b #$03
	beq .loop2
.4:									; Y + 1, Y + 1, Y + 1, ...
	pha
	rep #$20
	lda.b [p0],y
	iny
	iny
	tax
	lda.b [p0],y
	iny
	iny
	sta.w APUIO2
	sep #$20
	cpx.w #$0001
	lda.b #$00
	rol a
	sta.w APUIO1
	adc.b #$7F
	pla
	sta.w APUIO0
.loopxxx:							; loop: if not zero go to .loopxxx, ...
	cmp.w APUIO0
	bne .loopxxx
	bvs .1
	stz.w APUIO0
	rep #$30
	rtl
