; Copy tiles to video memory with each pixel colour remapped through a table.
RemapTiles:							; called from LoadPlayerCardScreen, LoadScoutingScreen, PlayoffScreen...
	lda.w #$000E
	sta.b tmp2+1
	sta.b tmp2+1
.tile:								; loop: tmp0 = [a0],y, tmp1 = [a0],y, tmp2 = $07
	rep #$30						; 16-bit registers
	ldy.b tmp2+1					; row offset
	lda.b [a0],y					; bitplanes 0-1
	sta.b tmp0
	tya
	clc								; bitplanes 2-3 are $10 bytes on
	adc.w #$0010
	tay
	lda.b [a0],y					; bitplanes 2-3
	sta.b tmp1
	sep #$30						; 8-bit registers
	ldx.b tmp2+1
	lda.b #$07						; 8 pixels
	sta.b tmp2
.pixel:								; loop: asl tmp1+1, if carry clear go to .lt, ...
	ldy.b #$00						; color index
	asl.b tmp1+1					; bitplane 3
	bcc .lt
	ldy.b #$08
.lt:								; asl tmp1, if carry clear go to .lt2, ...
	asl.b tmp1						; bitplane 2
	bcc .lt2
	iny
	iny
	iny
	iny
.lt2:								; asl tmp0+1, if carry clear go to .lt3, ...
	asl.b tmp0+1					; bitplane 1
	bcc .lt3
	iny
	iny
.lt3:								; asl tmp0, if carry clear go to .lt4, ...
	asl.b tmp0						; bitplane 0
	bcc .lt4
	iny
.lt4:								; rol RemapOut,x, lsr a, rol RemapOut+1,x, ...
	lda.b [a1],y					; new color from the table at [a1]
	lsr a							; its bits into the output planes
	rol.w RemapOut,x
	lsr a
	rol.w RemapOut+1,x
	lsr a
	rol.w RemapOut+16,x
	lsr a
	rol.w RemapOut+17,x
	dec.b tmp2						; next pixel
	bpl .pixel
	dec.b tmp2+1					; next row pair
	dec.b tmp2+1
	bpl .tile
	rep #$30						; 16-bit registers
	ldx.w #$0000
.out:								; loop: VMDATAL = RemapOut,x, X + 1, X + 1, ...
	lda.w RemapOut,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0020
	bne .out
	lda.b a0						; next tile
	clc
	adc.w #$0020
	sta.b a0
	dec.b d0						; tiles left
	bne RemapTiles
	rtl
