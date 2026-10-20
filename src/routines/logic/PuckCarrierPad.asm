; When player d0 has the puck and no pad: give him the next pad of his team in turn ($0AFD), if that team has
; pads ($19D0)
PuckCarrierPad:						; called from puckglue
	ldy.b d0
	lda.w playerpad,y
	bpl .6
	phx
	ldx.w #$0000
	cpy.w #$000C
	bcc .1
	ldx.w #$0002
.1:									; if teampads,x = 0 go to .4, ...
	lda.w teampads,x
	beq .4
	ldy.w puckpadnext,x
	dey
	dey
	bpl .2
	ldy.w #$0008
.2:									; r3 = $0005
	lda.w #$0005
	sta.b r3
	txa
.3:									; if not zero go to .5, ...
	cmp.w padside,y
	bne .5
	sty.b d4
	tya
	sta.w puckpadnext,x
	jsl.l AssignPadPlayer
.4:									; return
	plx
	rtl
.5:									; Y - 1, Y - 1, if Y still >= 0 go to .1x, ...
	dey
	dey
	bpl .1x
	ldy.w #$0008
.1x:								; decrement r3, if r3 not yet 0 go to .3, ...
	dec.b r3
	bne .3
	plx
.6:									; return
	rtl
