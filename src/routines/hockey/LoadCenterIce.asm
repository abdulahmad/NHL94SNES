; Unpack the home team's centre ice logo tiles (CenterIceTable) to VRAM after the rink tiles, then
; BuildRinkMap
LoadCenterIce:
	lda.w HomeTeam
	asl a
	asl a
	asl a
	tax
	lda.l CenterIceTable,x
	sta.b p0
	lda.l CenterIceTable+2,x
	sta.b p0+2
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p1+2
	sta.b p0+2
	stz.b p0
	stx.b p1
	stx.b r0
	jsl.l LinearToPlanar
	ldx.b p1
	stx.b p0
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l centericechars
	sta.l faceoffvrcset
	lda.l centericechars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	tay
	jsl.l DMAToVRAM
	jsl.l BuildRinkMap
	rtl
