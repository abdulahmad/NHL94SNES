; Write the OAM entries of each piece of the frame at [p0]; DrawSprite jumps here
DrawSpritePieces:
	lda.w SpritesLeft
	beq DrawSpriteExit
	lda.b [p0],y
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
	sty.w PieceNext
	lda.w PieceSize
	beq .t1
	lda.b r5+2
	sec
	sbc.w PieceY
	sec
	sbc.w #$000F
	bra .2

.t1:
	lda.b r5+2
	sec
	sbc.w PieceY
	sec
	sbc.w #$0007
.2:
	cmp.w #$FFF0
	bmi .1
	cmp.w #$00E0
	bmi .t2
.1:
	jmp.w .6

.t2:
	sta.b r7+2
	lda.b r3
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

.t1x:
	lda.b r5
	sec
	sbc.w PieceX
	sec
	sbc.w #$0007
	bra .3

.t3:
	lda.w PieceX
	clc
	adc.b r5
.3:
	cmp.w #$0100
	bpl .6
	cmp.w #$FFF0
	bmi .6
	sta.b r6
	sta.w $0000,x
	lda.b r7+2
	sta.w $0001,x
	lda.w PieceTile
	clc
	adc.b r3+2
	eor.b r3
	sta.w $0002,x
	ldy.w OAMHiPtr
	ldx.w OAMHiShift
	sep #$20
	lda.b r6+1
	bpl .t2x
	lda.w PieceSize
	beq .t1xx
	lda.w $0000,y
	ora.w OAMHiMasks+12,x
	bra .4

.t1xx:
	lda.w $0000,y
	and.w OAMHiMasks,x
	ora.w OAMHiMasks+4,x
	bra .4

.t2x:
	lda.w PieceSize
	beq .t1xxx
	lda.w $0000,y
	and.w OAMHiMasks,x
	ora.w OAMHiMasks+8,x
	bra .4

.t1xxx:
	lda.w $0000,y
	and.w OAMHiMasks,x
.4:
	sta.w $0000,y
	rep #$20
	dec.w SpritesLeft
	dex
	bpl .t1xxxx
	lda.w #$0003
	sta.w OAMHiShift
	inc.w OAMHiPtr
	bra .5

.t1xxxx:
	stx.w OAMHiShift
.5:
	lda.w OAMNext
	clc
	adc.w #$0004
	sta.w OAMNext
	tax
.6:
	ldy.w PieceNext
	dec.b r0
	beq .t1xxxxx
	jmp.w DrawSpritePieces

.t1xxxxx:
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
.7:
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
DrawSpritePieces_exit:
	txa
	plb
	ply
	plx
	rtl
