; Draw the centre ice logo of team A (CenterIceTable) into the mode 7 map of the title
;
; Takes A = team. Called from TitleScreen.
;
; Builds the logo from the CenterIceTable entry of the team (two pointers: a tile map and the graphics).
; Local routines below convert the data into titlelogobuf.
LoadTitleLogo:						; draw the centre ice logo of team A into the title Mode 7 map
	pha								; keep the team, send the map buffer at introbuf (60 by 60) to the
									; Mode 7 map
	lda.w #introbuf>>16
	sta.b p0+2
	lda.w #introbuf
	sta.b p0
	lda.w #$0000
	sta.w MapVRAM
	ldx.w #$003C
	ldy.w #$003C
	jsl.l Mode7MapToVRAM
	pla								; CenterIceTable entry = team * 8; x kept on the stack
	asl a
	asl a
	asl a
	tax
	phx
	lda.l CenterIceTable+4,x		; second pointer (the logo map data) into p0, .t3 builds the header and
									; tile numbers; returns x, y = width, height
	sta.b p0
	lda.l CenterIceTable+6,x
	sta.b p0+2
	jsr.w .t3
	txa								; x = $42 - width / 2, y = $40 - height / 2: centre of the logo in the
									; Mode 7 map
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0042
	tax
	tya
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0040
	tay
	lda.w #titlelogobuf>>16			; send the map at titlelogobuf to the Mode 7 map in VRAM
	sta.b p0+2
	lda.w #titlelogobuf
	sta.b p0
	lda.w #$0000
	sta.w MapVRAM
	jsl.l Mode7MapToVRAM
	plx								; first pointer (the logo graphics): unpack to unpackbuf, convert with .t2
	lda.l CenterIceTable,x
	sta.b p0
	lda.l CenterIceTable+2,x
	sta.b p0+2
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	jsr.w .t2
	lda.w #titlelogobuf>>16			; copy the converted graphics to VRAM
	sta.b p0+2
	lda.w #titlelogobuf
	sta.b p0
	ldy.w #$0000
	jsl.l DMAToVRAMHigh
	rts								; done

.t2:								; convert the unpacked logo graphics (called above)
	phx								; convert the unpacked graphics: clear the first 32 words of titlelogobuf,
									; then one .t1 pass per 32 bytes of source
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	inc a
	tax
	phx
	ldx.w #$0000
	lda.w #$0000
.loop:								; clear a word of titlelogobuf
	sta.l titlelogobuf,x
	inx
	inx
	cpx.w #$0040
	bcc .loop
	plx
	stz.w LogoSrcOfs				; source offset 0, destination offset $40
	lda.w #$0040
	sta.w LogoDstOfs
.loop2:								; next block of 32 source bytes (each becomes 32 words)
	phx
	jsr.w .t1
	lda.w LogoSrcOfs
	clc
	adc.w #$0020
	sta.w LogoSrcOfs
	lda.w LogoDstOfs
	clc
	adc.w #$0040
	sta.w LogoDstOfs
	plx
	dex
	bne .loop2
	pla								; x = width * 2 + $40 for the caller
	asl a
	clc
	adc.w #$0040
	tax
	rts

.t1:								; convert one block of source bytes
	stz.b d0+2						; split 32 source bytes into nibbles: d0+2 counts them
	ldx.w LogoDstOfs
	ldy.w LogoSrcOfs
	sep #$20
.loopx:								; low nibble goes to the odd byte, high nibble to the even byte, both with
									; LogoPalBits
	lda.b [p0],y
	sta.b d0
	and.b #$0F
	ora.w LogoPalBits
	sta.l titlelogobuf+1,x
	lda.b d0
	lsr a
	lsr a
	lsr a
	lsr a
	and.b #$0F
	ora.w LogoPalBits
	sta.l titlelogobuf,x
	inx
	inx
	iny
	inc.b d0+2
	lda.b d0+2
	cmp.b #$20
	bcc .loopx
	rep #$20
	rts

.t3:								; build the header of titlelogobuf from the map at p0: width, height, $10,
									; then the tile numbers + 1
	lda.w #$0060					; palette bits $60 unless some attribute byte has bits $1C set (then $70)
	sta.w LogoPalBits
	ldx.w #$0000
	ldy.w #$0000
	lda.b [p0],y
	sta.b d0
	sta.l titlelogobuf,x			; width and height words copied to the header
	ldx.w #$0002
	ldy.w #$0002
	lda.b [p0],y
	sta.b d0+2
	sta.l titlelogobuf,x
	ldx.w #$0004
	lda.w #$0010
	sta.l titlelogobuf,x
	lda.b d0						; d1 = width * height + 6: end of the data
	ldx.b d0+2
	jsl.l Mul8U
	clc
	adc.w #$0006
	sta.b d1
	ldx.w #$0006
	ldy.w #$0006
	sep #$20
.loopx2:							; copy tile numbers (+1)
	lda.b [p0],y
	inc a
	sta.l titlelogobuf,x
	iny
	cmp.b #$00						; tile number was $FF (now 0): skip the palette test
	beq .1
	lda.b [p0],y					; attribute bits $1C set: palette bits $70
	bit.b #$1C
	beq .1
	lda.b #$70
	sta.w LogoPalBits
.1:									; next byte
	iny
	inx
	cpx.b d1
	bcc .loopx2
	rep #$20						; return width in x, height in y
	ldx.b d0
	ldy.b d0+2
	rts
