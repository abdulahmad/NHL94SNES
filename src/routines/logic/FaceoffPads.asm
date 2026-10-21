; At a faceoff: CalcPuckDistances, restore the pad sides kept in padside, reset the pad / player tables
; (playerpad, c1playernum) and give each pad a player again (findpc)
FaceoffPads:						; called from puckfaceoff2
	jsl.l CalcPuckDistances
	lda.w penshot
	bne .2
	ldy.w #$0008
.loop:								; loop: if not zero go to .1, ...
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
.1:									; Y - 1, Y - 1, if Y still >= 0 go to .loop
	dey
	dey
	bpl .loop
.2:									; if teampads < $0004 go to .6, ...
	lda.w teampads
	cmp.w #$0004
	bcc .6
	ldx.w #$000A
	ldy.w #$0000
.loop2:								; loop: if position,x = 0 go to .3, ...
	lda.w position,x
	beq .3
	bmi .3
	iny
.3:									; X - 1, X - 1, if X still >= 0 go to .loop2, ...
	dex
	dex
	bpl .loop2
	sty.b d0
	ldx.w #$0008
	ldy.w #$0000
.loop3:								; loop: if padside,x != $0000 go to .4, ...
	lda.w padside,x
	cmp.w #$0000
	bne .4
	iny
.4:									; X - 1, X - 1, if X still >= 0 go to .loop3, ...
	dex
	dex
	bpl .loop3
	cpy.b d0
	bcs .6
	cpy.w teampads
	beq .6
	ldy.w padsitnext
.loop4:								; loop: Y + 1, Y + 1, if not zero go to .5, ...
	iny
	iny
	cpy.w #$000A
	bne .5
	ldy.w #$0000
.5:									; if padside,y >= 0 go to .loop4, ...
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
.6:									; if teampads+2 < $0004 go to .10, ...
	lda.w teampads+2
	cmp.w #$0004
	bcc .10
	ldx.w #$0016
	ldy.w #$0000
.loop5:								; loop: if position,x = 0 go to .7, ...
	lda.w position,x
	beq .7
	bmi .7
	iny
.7:									; X - 1, X - 1, if plus go to .loop5, ...
	dex
	dex
	cpx.w #$000C
	bpl .loop5
	sty.b d0
	ldx.w #$0008
	ldy.w #$0000
.loop6:								; loop: if padside,x != $0002 go to .8, ...
	lda.w padside,x
	cmp.w #$0002
	bne .8
	iny
.8:									; X - 1, X - 1, if X still >= 0 go to .loop6, ...
	dex
	dex
	bpl .loop6
	cpy.b d0
	bcs .10
	cpy.w teampads
	beq .10
	ldy.w padsitnext+2
.loop7:								; loop: Y + 1, Y + 1, if not zero go to .9, ...
	iny
	iny
	cpy.w #$000A
	bne .9
	ldy.w #$0000
.9:									; if padside,y >= 0 go to .loop7, ...
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
.10:								; benchcheer = 0
	stz.w benchcheer
	ldx.w #$0016
	lda.w #$FFFF
.loop8:								; loop: playerpad,x = A, goalieflags,x = 0, goalieturnwait,x = 0, ...
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
.loop9:								; loop: c1playernum,x = A, X - 1, X - 1, ...
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
.11:								; loop: if padside,x != 0 go to .13, ...
	lda.w padside,x
	bne .13
	stx.b d4
	phx
	lda.w fopadfirst
	bpl .12
	stx.w fopadfirst
.12:								; call findpc
	jsl.l findpc
	plx
.13:								; X - 1, X - 1, if X still >= 0 go to .14, ...
	dex
	dex
	bpl .14
	ldx.w #$0008
.14:								; decrement p0, if p0 not yet 0 go to .11
	dec.b p0
	bne .11
.15:								; if teampads+2 = 0 go to .rtl, ...
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
.16:								; loop: if padside,x != $0002 go to .18, ...
	lda.w padside,x
	cmp.w #$0002
	bne .18
	stx.b d4
	phx
	lda.w fopadfirst+2
	bpl .17
	stx.w fopadfirst+2
.17:								; call findpc
	jsl.l findpc
	plx
.18:								; X - 1, X - 1, if X still >= 0 go to .19, ...
	dex
	dex
	bpl .19
	ldx.w #$0008
.19:								; decrement p0, if p0 not yet 0 go to .16
	dec.b p0
	bne .16
.rtl:								; return
	rtl
