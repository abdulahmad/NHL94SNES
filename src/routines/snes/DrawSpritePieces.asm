; Write the OAM entries of each piece of the frame at [p0]; DrawSprite jumps here
;
; Takes: p0 = frame record, Y = offset of the next piece, r0 = pieces left, X = OAMNext, r3 = attribute xor
; word (bit 15 vertical flip, bit 14 horizontal flip), r3+2 = first tile, r5/r5+2 = X/Y of the sprite.
; Data bank is $7E. Called only by a jump from DrawSprite, which also ends the draw from here.
DrawSpritePieces:					; flipped sprite: one OAM entry per piece
	lda.w SpritesLeft
	beq DrawSpriteExit				; no OAM entries left: end the draw
	lda.b [p0],y					; read the piece x offset, y offset, tile word and size byte
	sta.w PieceX
	iny
	iny
	lda.b [p0],y
	sta.w PieceY
	iny
	iny
	lda.b [p0],y
	sta.w PieceTile
	iny
	iny
	lda.b [p0],y
	and.w #$00FF
	sta.w PieceSize
	iny
	sty.w PieceNext					; remember where the next piece starts
	lda.w PieceSize					; y = sprite y - piece y - centre of the piece (15 for 16x16, 7 for 8x8)
	beq .t1
	lda.b r5+2
	sec
	sbc.w PieceY
	sec
	sbc.w #$000F
	bra .2

.t1:								; 8x8 piece (size 0): centre 7
	lda.b r5+2
	sec
	sbc.w PieceY
	sec
	sbc.w #$0007
.2:									; y must be -16 <= y < $E0
	cmp.w #$FFF0
	bmi .1
	cmp.w #$00E0
	bmi .t2
.1:									; off screen: next piece
	jmp.w .6

.t2:								; on screen: keep y in r7+2
	sta.b r7+2
	lda.b r3						; bit 14 of r3 (horizontal flip) clear: x = sprite x + piece x
	and.w #$4000
	beq .t3
	lda.w PieceSize
	beq .t1x
	lda.b r5
	sec
	sbc.w PieceX
	sec
	sbc.w #$000F
	bra .3

.t1x:								; 8x8 piece, mirrored x: centre 7
	lda.b r5
	sec
	sbc.w PieceX
	sec
	sbc.w #$0007
	bra .3

.t3:								; not mirrored
	lda.w PieceX
	clc
	adc.b r5
.3:									; x must be -16 <= x < $100, else skip the piece
	cmp.w #$0100
	bpl .6
	cmp.w #$FFF0
	bmi .6
	sta.b r6						; write the OAM entry: x low, y, tile word (piece tile + first tile, eor
									; flip bits)
	sta.w $0000,x
	lda.b r7+2
	sta.w $0001,x
	lda.w PieceTile
	clc
	adc.b r3+2
	eor.b r3
	sta.w $0002,x
	ldy.w OAMHiPtr					; OAM high table: byte pointer and bit position of this entry
	ldx.w OAMHiShift
	sep #$20
	lda.b r6+1						; negative x: the X high bit goes in the high table
	bpl .t2x
	lda.w PieceSize
	beq .t1xx
	lda.w $0000,y
	ora.w OAMHiMasks+12,x
	bra .4

.t1xx:								; negative x, 8x8: clear both bits, set the X high bit
	lda.w $0000,y
	and.w OAMHiMasks,x
	ora.w OAMHiMasks+4,x
	bra .4

.t2x:								; positive x: a 16x16 piece sets the size bit, 8x8 leaves both clear
	lda.w PieceSize
	beq .t1xxx
	lda.w $0000,y
	and.w OAMHiMasks,x
	ora.w OAMHiMasks+8,x
	bra .4

.t1xxx:								; positive x, 8x8: clear both bits
	lda.w $0000,y
	and.w OAMHiMasks,x
.4:									; store the high table byte, one OAM entry used
	sta.w $0000,y
	rep #$20
	dec.w SpritesLeft
	dex								; step to the next entry of the byte; after the fourth use the next byte
	bpl .t1xxxx
	lda.w #$0003
	sta.w OAMHiShift
	inc.w OAMHiPtr
	bra .5

.t1xxxx:							; same byte: remember the shift
	stx.w OAMHiShift
.5:									; advance OAMNext by one entry (4 bytes)
	lda.w OAMNext
	clc
	adc.w #$0004
	sta.w OAMNext
	tax
.6:									; next piece, unless this was the last one
	ldy.w PieceNext
	dec.b r0
	beq .t1xxxxx
	jmp.w DrawSpritePieces

.t1xxxxx:							; all pieces drawn: restore the bank and return
	plb
	rtl

.cacheat:							;unused entry (no caller in the ROM): make sure the tiles of the frame at
									;[p0] are in VRAM; A = its tile cache entry, negative if no room
	phx
	phy
	phb
	pea.w $7E7E
	plb
	plb
	jmp.w .7

.cacheframe:						;unused entry (no caller in the ROM): the same for frame A of the sprite
									;set at [p1]
	phx
	phy
	sta.w DrawFrameNum
	asl a
	asl a
	tay
	lda.b [p1],y
	clc
	adc.b p1
	sta.b p0
	iny
	iny
	lda.b [p1],y
	adc.b p1+2
	sta.b p0+2
	phb
	pea.w $7E7E
	plb
	plb
.7:									; shared tail of the two unused entries
	ldy.w FrameCacheCount
	beq LoadFrameTiles
	ldx.w FrameByNumber
	beq FindCachedFrame
	ldx.w DrawFrameNum
	lda.w FrameCacheOf,x
	bmi LoadFrameTiles
	xba
	and.w #$00FF
	asl a
	tax
DrawSpritePieces_exit:				; exit of the unused entries: restore registers and return A
	txa
	plb
	ply
	plx
	rtl
