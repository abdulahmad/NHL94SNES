; At a faceoff: CalcPuckDistances, restore the pad sides kept in padside, reset the pad / player tables
; (playerpad, c1playernum) and give each pad a player again (findpc)
FaceoffPads:						; called from puckfaceoff2
	jsl.l CalcPuckDistances			; for each of the 16 objects: puckdist2 / 4), puckdist and puckdir
	lda.w penshot					;penalty shot?
	bne .2							;yes: keep the sides
	ldy.w #$0008					;pad 5
.loop:								; loop: if not zero go to .1, ...
	lda.w padside,y					;pad side
	and.w #$FF00					;high byte
	cmp.w #$8000					;sat out ($80)?
	bne .1							;no
	lda.w padside,y
	and.w #$00FF					;its team
	sta.w padside,y					;back in
	inc a
	inc a							;team / 2 + 1
	lsr a
	sta.w cont1team,y				;controller team
.1:									; Y - 1, Y - 1, if Y still >= 0 go to .loop
	dey
	dey
	bpl .loop						;all
.2:									; if teampads < $0004 go to .6, ...
	lda.w teampads					;home pads
	cmp.w #$0004					;two or more?
	bcc .6							;no
	ldx.w #$000A					;home skaters
	ldy.w #$0000					;count
.loop2:								; loop: if position,x = 0 go to .3, ...
	lda.w position,x				;on the ice?
	beq .3							;goalie: no
	bmi .3							;no
	iny
.3:									; X - 1, X - 1, if X still >= 0 go to .loop2, ...
	dex
	dex
	bpl .loop2						;all
	sty.b d0						;d0 = home skaters
	ldx.w #$0008					;pad 5
	ldy.w #$0000					;count
.loop3:								; loop: if padside,x != $0000 go to .4, ...
	lda.w padside,x					;pad side
	cmp.w #$0000					;home?
	bne .4							;no
	iny
.4:									; X - 1, X - 1, if X still >= 0 go to .loop3, ...
	dex
	dex
	bpl .loop3						;all
	cpy.b d0						;pads for every skater?
	bcs .6							;yes: done
	cpy.w teampads					;all home pads in?
	beq .6							;yes
	ldy.w padsitnext				;last pad let back in
.loop4:								; loop: Y + 1, Y + 1, if not zero go to .5, ...
	iny
	iny
	cpy.w #$000A					;past pad 5?
	bne .5
	ldy.w #$0000					;wrap
.5:									; if padside,y >= 0 go to .loop4, ...
	lda.w padside,y					;pad side
	bpl .loop4						;playing: skip
	and.w #$00FF
	cmp.w #$0080					;sat out
	beq .loop4						;marker only?
	cmp.w #$0000					;skip
	bne .loop4						;home?
	sta.w padside,y					;no: skip
	inc a							;back in
	inc a
	lsr a							;team / 2 + 1
	sta.w cont1team,y				;controller team
.6:									; if teampads+2 < $0004 go to .10, ...
	lda.w teampads+2				;visitors' pads
	cmp.w #$0004					;two or more?
	bcc .10							;no
	ldx.w #$0016					;visitors' skaters
	ldy.w #$0000					;count
.loop5:								; loop: if position,x = 0 go to .7, ...
	lda.w position,x				;on the ice?
	beq .7							;goalie: no
	bmi .7							;no
	iny
.7:									; X - 1, X - 1, if plus go to .loop5, ...
	dex
	dex
	cpx.w #$000C					;visitors only
	bpl .loop5
	sty.b d0						;d0
	ldx.w #$0008					;pad 5
	ldy.w #$0000					;count
.loop6:								; loop: if padside,x != $0002 go to .8, ...
	lda.w padside,x					;pad side
	cmp.w #$0002					;visitors?
	bne .8							;no
	iny
.8:									; X - 1, X - 1, if X still >= 0 go to .loop6, ...
	dex
	dex
	bpl .loop6						;all
	cpy.b d0						;pads for every skater?
	bcs .10							;yes
	cpy.w teampads					;all pads in?
	beq .10							;yes
	ldy.w padsitnext+2				;last visitors' pad let back in
.loop7:								; loop: Y + 1, Y + 1, if not zero go to .9, ...
	iny
	iny
	cpy.w #$000A					;past pad 5?
	bne .9
	ldy.w #$0000					;wrap
.9:									; if padside,y >= 0 go to .loop7, ...
	lda.w padside,y					;pad side
	bpl .loop7						;playing: skip
	and.w #$00FF
	cmp.w #$0080					;sat out
	beq .loop7						;marker only?
	cmp.w #$0002					;skip
	bne .loop7						;visitors?
	sta.w padside,y					;no: skip
	inc a							;back in
	inc a
	lsr a							;team / 2 + 1
	sta.w cont1team,y				;controller team
.10:								; benchcheer = 0
	stz.w benchcheer				;no bench cheer
	ldx.w #$0016					;every player
	lda.w #$FFFF					;none
.loop8:								; loop: playerpad,x = A, goalieflags,x = 0, goalieturnwait,x = 0, ...
	sta.w playerpad,x				;no pad
	stz.w goalieflags,x				;goalie state cleared
	stz.w goalieturnwait,x
	stz.w goaliedivewait,x
	stz.w FaceoffUnused,x
	dex
	dex
	bpl .loop8						;all
	sta.w dumpinplayer				;no dump-in player
	ldx.w #$0008					;pad 5
.loop9:								; loop: c1playernum,x = A, X - 1, X - 1, ...
	sta.w c1playernum,x				;no player
	dex
	dex
	bpl .loop9						;all
	lda.w teampads					;home pads
	beq .15							;none
	lda.w #$0005					;5 pads
	sta.b p0						;count
	ldx.w fopadfirst				;first pad last time
	lda.w #$FFFF					;none yet
	sta.w fopadfirst				;this time
	dex
	dex
	bpl .11							;in range
	ldx.w #$0008					;wrap to pad 5
.11:								; loop: if padside,x != 0 go to .13, ...
	lda.w padside,x					;pad side
	bne .13							;home?
	stx.b d4						;pad
	phx								;d4
	lda.w fopadfirst
	bpl .12							;first one found?
	stx.w fopadfirst				;yes
.12:								;remember it
	jsl.l findpc					;give the pad a player
	plx
.13:								; X - 1, X - 1, if X still >= 0 go to .14, ...
	dex
	dex
	bpl .14							;in range
	ldx.w #$0008					;wrap
.14:								; decrement p0, if p0 not yet 0 go to .11
	dec.b p0						;count
	bne .11							;all 5
.15:								; if teampads+2 = 0 go to .rtl, ...
	lda.w teampads+2				;visitors' pads
	beq .rtl						;none
	lda.w #$0005					;5 pads
	sta.b p0
	ldx.w fopadfirst+2				;first pad last time
	lda.w #$FFFF					;none yet
	sta.w fopadfirst+2
	dex
	dex
	bpl .16							;in range
	ldx.w #$0008					;wrap to pad 5
.16:								; loop: if padside,x != $0002 go to .18, ...
	lda.w padside,x					;pad side
	cmp.w #$0002					;visitors?
	bne .18							;no
	stx.b d4						;pad
	phx								;d4
	lda.w fopadfirst+2
	bpl .17							;first found?
	stx.w fopadfirst+2				;yes
.17:								;remember it
	jsl.l findpc					;give the pad a player
	plx
.18:								; X - 1, X - 1, if X still >= 0 go to .19, ...
	dex
	dex
	bpl .19							;in range
	ldx.w #$0008					;wrap
.19:								; decrement p0, if p0 not yet 0 go to .16
	dec.b p0						;count
	bne .16							;all 5
.rtl:								; return
	rtl
