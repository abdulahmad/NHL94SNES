; start filling OAMDrawBuf after the reserved entries; free the tiles of frames not drawn
SpriteFrameStart:					;start filling OAMDrawBuf after the reserved entries; free the tiles of
									;frames not drawn
			;   since the last call
	phb
	lda.w #$7E7E
	pha
	plb
	plb
	lda.w #$0080
	sec
	sbc.w SpritesReserved
	sta.w SpritesLeft
	lda.w SpritesReserved
	lsr a
	lsr a
	tax
	clc
	adc.w OAMDrawBuf
	adc.w #$0200
	sta.w OAMHiPtr
	txa
	and.w #$0003
	eor.w #$0003
	sta.w OAMHiShift
	lda.w SpritesReserved
	asl a
	asl a
	adc.w OAMDrawBuf
	sta.w OAMNext
	lda.w FrameCacheCount
	beq .2
	dec a
	asl a
	tax
.1:
	lda.w FrameCacheUse,x
	bmi .t1
	lsr a
	sta.w FrameCacheUse,x
	bcc .t1
	ldy.w FrameCacheNum,x
	sep #$20
	lda.b #$80
	pha
	rep #$20
	lda.w #.t1-1
	pha
	phx
	phy
	phb
	jmp.w FreeCacheEntry

.t1:
	dex
	dex
	bpl .1
.2:
	plb
	rtl
