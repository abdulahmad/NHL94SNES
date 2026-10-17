; Framer with an outline box (FramerOutlineMap: eight border tiles, the set's base tile in the middle) from
; tile set $7E35C0
FramerOutline:
	phx
	phy
	lda.l outlinechars
	clc
	adc.l printfontset
	sta.b tmp0
	lda.w #FramerOutlineMap>>16
	sta.b p0+2
	lda.w #FramerOutlineMap+6
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
	lda.w #FramerOutlineMap+12
	sta.b p0
	jsr.w FramerRow
	dec.b d1
	bne .loop
	lda.w #FramerOutlineMap+18
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
