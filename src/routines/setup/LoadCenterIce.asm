; Unpack the home team's centre ice logo tiles (CenterIceTable) to VRAM after the rink tiles, then
; BuildRinkMap
;
; Takes no registers (uses HomeTeam). Called from SaveRegsStartHL2 and setupice.
LoadCenterIce:						; unpack the home team's centre ice logo to VRAM
	lda.w HomeTeam					; x = HomeTeam * 8: its CenterIceTable entry
	asl a
	asl a
	asl a
	tax
	lda.l CenterIceTable,x
	sta.b p0
	lda.l CenterIceTable+2,x
	sta.b p0+2
	lda.w #unpackbuf>>16			; unpack the logo graphics to unpackbuf
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16			; convert from linear to planar tiles in place
	sta.b p1+2
	sta.b p0+2
	stz.b p0
	stx.b p1
	stx.b r0
	jsl.l LinearToPlanar
	ldx.b p1						; d0.. = size; faceoffvrcset = first tile of the logo (centericechars +
									; size in tiles)
	stx.b p0
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l centericechars
	sta.l faceoffvrcset
	lda.l centericechars			; VRAM word address = centericechars * 16 + $1000
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	tay
	jsl.l DMAToVRAM					; copy the tiles to VRAM, then build the rink map
	jsl.l BuildRinkMap
	rtl
