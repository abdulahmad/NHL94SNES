; At a faceoff: CalcPuckDistances, restore the pad sides kept in $19F6, reset the pad / player tables ($19D4,
; $19EC) and give each pad a player again (findpc)
FaceoffPads:
	jsl.l CalcPuckDistances
	lda.w penshot
	bne .2
	ldy.w #$0008
.loop:
	lda.w padside,y
	and.w #$FF00
	cmp.w #$8000
	bne .1
	lda.w padside,y
	and.w #$00FF
	sta.w padside,y
	inc a
	inc a
	lsr a
	sta.w cont1team,y
.1:
	dey
	dey
	bpl .loop
.2:
	lda.w teampads
	cmp.w #$0004
	bcc .6
	ldx.w #$000A
	ldy.w #$0000
.loop2:
	lda.w position,x
	beq .3
	bmi .3
	iny
.3:
	dex
	dex
	bpl .loop2
	sty.b d0
	ldx.w #$0008
	ldy.w #$0000
.loop3:
	lda.w padside,x
	cmp.w #$0000
	bne .4
	iny
.4:
	dex
	dex
	bpl .loop3
	cpy.b d0
	bcs .6
	cpy.w teampads
	beq .6
	ldy.w padsitnext
.loop4:
	iny
	iny
	cpy.w #$000A
	bne .5
	ldy.w #$0000
.5:
	lda.w padside,y
	bpl .loop4
	and.w #$00FF
	cmp.w #$0080
	beq .loop4
	cmp.w #$0000
	bne .loop4
	sta.w padside,y
	inc a
	inc a
	lsr a
	sta.w cont1team,y
.6:
	lda.w teampads+2
	cmp.w #$0004
	bcc .10
	ldx.w #$0016
	ldy.w #$0000
.loop5:
	lda.w position,x
	beq .7
	bmi .7
	iny
.7:
	dex
	dex
	cpx.w #$000C
	bpl .loop5
	sty.b d0
	ldx.w #$0008
	ldy.w #$0000
.loop6:
	lda.w padside,x
	cmp.w #$0002
	bne .8
	iny
.8:
	dex
	dex
	bpl .loop6
	cpy.b d0
	bcs .10
	cpy.w teampads
	beq .10
	ldy.w padsitnext+2
.loop7:
	iny
	iny
	cpy.w #$000A
	bne .9
	ldy.w #$0000
.9:
	lda.w padside,y
	bpl .loop7
	and.w #$00FF
	cmp.w #$0080
	beq .loop7
	cmp.w #$0002
	bne .loop7
	sta.w padside,y
	inc a
	inc a
	lsr a
	sta.w cont1team,y
.10:
	stz.w benchcheer
	ldx.w #$0016
	lda.w #$FFFF
.loop8:
	sta.w playerpad,x
	stz.w goalieflags,x
	stz.w goalieturnwait,x
	stz.w goaliedivewait,x
	stz.w FaceoffUnused,x
	dex
	dex
	bpl .loop8
	sta.w dumpinplayer
	ldx.w #$0008
.loop9:
	sta.w c1playernum,x
	dex
	dex
	bpl .loop9
	lda.w teampads
	beq .15
	lda.w #$0005
	sta.b p0
	ldx.w fopadfirst
	lda.w #$FFFF
	sta.w fopadfirst
	dex
	dex
	bpl .11
	ldx.w #$0008
.11:
	lda.w padside,x
	bne .13
	stx.b d4
	phx
	lda.w fopadfirst
	bpl .12
	stx.w fopadfirst
.12:
	jsl.l findpc
	plx
.13:
	dex
	dex
	bpl .14
	ldx.w #$0008
.14:
	dec.b p0
	bne .11
.15:
	lda.w teampads+2
	beq .rtl
	lda.w #$0005
	sta.b p0
	ldx.w fopadfirst+2
	lda.w #$FFFF
	sta.w fopadfirst+2
	dex
	dex
	bpl .16
	ldx.w #$0008
.16:
	lda.w padside,x
	cmp.w #$0002
	bne .18
	stx.b d4
	phx
	lda.w fopadfirst+2
	bpl .17
	stx.w fopadfirst+2
.17:
	jsl.l findpc
	plx
.18:
	dex
	dex
	bpl .19
	ldx.w #$0008
.19:
	dec.b p0
	bne .16
.rtl:
	rtl
