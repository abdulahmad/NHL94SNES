; Draw the picture of player A of team a2 (PlayerPhotoTable) at x, y
DrawPlayerPicture:
	sta.b d0
	lda.l matchupphotos
	beq .t1
	jmp.w .10

.t1:
	phy
	phx
	lda.b a2
	beq .t2
	lda.w #$2400
	sta.w picattr
	bra .1

.t2:
	lda.w #$3400
	sta.w picattr
.1:
	lda.b d0
	ldy.b a2
	sta.b d0
	lda.w HomeTeam,y
	ldx.w #$001A
	jsl.l Mul8U
	clc
	adc.b d0
	asl a
	asl a
	tax
	lda.l PlayerPhotoTable,x
	sta.b p0
	lda.l PlayerPhotoTable+2,x
	sta.b p0+2
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	stx.b r0
	lda.b a2
	beq .t1x
	lda.w #$6900
	sta.b p1
	sta.l vispicaddr
	bra .2

.t1x:
	lda.w #$6F00
	sta.b p1
	sta.l homepicaddr
.2:
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	jsl.l LinearToPlanar
	jsl.l .6
	bne .t1xx
	lda.w #PhotoMap>>16
	sta.b p0+2
	lda.w #PhotoMap
	sta.b p0
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.w #$0020
	sta.b r7
	lda.l picchars
	clc
	adc.w picattr
	ldy.b a2
	beq .1x
	clc
	adc.w #$0030
.1x:
	plx
	ply
	jsl.l PasteMap
	bra .3

.t1xx:
	lda.w #PhotoMap>>16
	sta.b p0+2
	lda.w #PhotoMap
	sta.b p0
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.w #$0020
	sta.b r7
	lda.l picchars
	clc
	adc.w picattr
	ldy.b a2
	beq .1xx
	clc
	adc.w #$0030
.1xx:
	plx
	ply
	jsl.l .5
.3:
	ldy.b a2
	lda.w HomeTeam,y
	asl a
	asl a
	clc
	adc.w #$D8B3
	sta.b a1
	lda.w #$009D
	sta.b a1+2
	lda.b [a1]
	sta.b p0
	inc.b a1
	inc.b a1
	lda.b [a1]
	sta.b p0+2
	lda.b a2
	beq .t1xxx
	ldy.w #$0010
	bra .4

.t1xxx:
	ldy.w #$0050
.4:
	ldx.w #$0010
	jsl.l SetColours
	rtl
.5:
	sta.b r7+2
	lda.b p1+2
	sta.b r3+2
	stx.b r5
	tya
	asl a
	ldx.b r7
	jsl.l Mul16U
	lda.b r5
	asl a
	clc
	adc.b r2
	adc.b p1
	sta.b p1
	ldy.w #$0000
	lda.b [p0],y
	sta.b r4
	iny
	iny
	lda.b [p0],y
	sta.b r4+2
	lda.b p0
	clc
	adc.w #$0006
	sta.b p0
.loop:
	ldx.b r4
	ldy.w #$0000
.loop2:
	tya
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.b r4
	dec a
	asl a
	adc.b p1
	sta.b r3
	lda.b [p0],y
	clc
	adc.b r7+2
	ora.w #$4000
	sta.b [r3]
	iny
	iny
	dex
	bne .loop2
	lda.b r7
	asl a
	adc.b p1
	sta.b p1
	lda.b r4
	asl a
	adc.b p0
	sta.b p0
	dec.b r4+2
	bne .loop
	rtl
.6:
	jsl.l .9
	beq .1xxx
	jsl.l .7
	sta.b r3
	jsl.l .8
	bne .t1xxxx
	lda.b r3
	rtl

.t1xxxx:
	lda.b r3
	eor.w #$0001
.1xxx:
	rtl
.7:
	jsl.l .8
	bne .t1xxxxx
	lda.w #$0005
	sta.b d1
	bra .1xxxx

.t1xxxxx:
	lda.w #$0004
	sta.b d1
.1xxxx:
	jsl.l GetPlayerRating
	lda.b d0
	and.w #$0001
	rtl
.8:
	lda.w #AttribMenuSkater>>16
	sta.b a1+2
	lda.w #AttribMenuSkater
	sta.b a1
	stz.b r2
	jsl.l GoalieCount
	lda.w curplayer
	cmp.b d0
	bpl .t1xxxxxx
	lda.w #$0001
	rtl

.t1xxxxxx:
	lda.w #$0000
	rtl
.9:
	ldy.b a2
	lda.w #$009C
	sta.b a3+2
	lda.w tmdata,y
	sta.b a3
	ldy.w #$000C
	clc
	adc.b [a3],y
	sta.b a3
	ldy.w #$0005
.loopx:
	lda.b [a3],y
	and.w #$00FF
	dec a
	cmp.w curplayer
	beq .t1xxxxxxx
	dey
	bpl .loopx
	lda.w #$0001
	rtl

.t1xxxxxxx:
	lda.w #$0000
	rtl
.10:
	phy
	phx
	ldx.b a2
	jsl.l LoadMatchupPhotos
	lda.b d0
	asl a
	tax
	lda.b a2
	beq .t1xxxxxxxx
	lda.w #$2400
	sta.w picattr
	lda.w #$2D00
	clc
	adc.l MatchupPhotoOffsets,x
	sta.l vispicaddr
	bra .2x

.t1xxxxxxxx:
	lda.w #$3400
	sta.w picattr
	lda.w #$5100
	clc
	adc.l MatchupPhotoOffsets,x
	sta.l homepicaddr
.2x:
	lda.w #PhotoMap>>16
	sta.b p0+2
	lda.w #PhotoMap
	sta.b p0
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.w #$0020
	sta.b r7
	lda.l picchars
	clc
	adc.w picattr
	ldy.b a2
	beq .1xxxxx
	clc
	adc.w #$0030
.1xxxxx:
	plx
	ply
	jsl.l PasteMap
	ldy.b a2
	lda.w HomeTeam,y
	asl a
	asl a
	clc
	adc.w #$D8B3
	sta.b a1
	lda.w #$009D
	sta.b a1+2
	lda.b [a1]
	sta.b p0
	inc.b a1
	inc.b a1
	lda.b [a1]
	sta.b p0+2
	lda.b a2
	beq .t1xxxxxxxxx
	ldy.w #$0010
	bra .3x

.t1xxxxxxxxx:
	ldy.w #$0050
.3x:
	ldx.w #$0010
	jsl.l SetColours
	rtl
