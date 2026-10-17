; Framer with a nine-tile box (FramerNineTileMap: eight border tiles and a centre tile, no flips) from tile
; set $7E35BE
FramerNineTile:
	phx
	phy
	lda.l ninetilechars
	clc
	adc.l printfontset
	sta.b tmp0
	lda.w #FramerNineTileMap>>16
	sta.b p0+2
	lda.w #FramerNineTileMap+6
	sta.b p0
	jsr.w FramerRow
	lda.b tmp2
	lsr a
	cmp.w textdirtylo
	bcs .1
	sta.w textdirtylo
.1:
	dec.b d1
	dec.b d1
.loop:
	lda.w #FramerNineTileMap+12
	sta.b p0
	jsr.w FramerRow
	dec.b d1
	bne .loop
	lda.w #FramerNineTileMap+18
	sta.b p0
	jsr.w FramerRow
	inx
	inx
	txa
	lsr a
	cmp.w textdirtyhi
	bcc .2
	sta.w textdirtyhi
.2:
	ply
	plx
	rtl
