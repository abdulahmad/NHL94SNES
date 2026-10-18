; Put one recorded replay frame back into the objects, the puck and the screen
RestoreReplayFrame:
	lda.b d1
	pha
	inc.w replaynewframe
	sep #$20
	ldx.b a4
	stx.w WMADDL
	lda.b a4+2
	sta.w WMADDH
	lda.b #$0F
	sta.b d1
	ldx.w #$0000
.loop:
	lda.w WMDATA
	sta.w Xpos,x
	lda.w WMDATA
	sta.b r3
	and.b #$0F
	bit.b #$08
	beq .1
	ora.b #$F0
.1:
	sta.w Xpos+1,x
	lda.w WMDATA
	sta.w Ypos,x
	lda.b r3
	lsr a
	lsr a
	lsr a
	lsr a
	bit.b #$08
	beq .2
	ora.b #$F0
.2:
	sta.w Ypos+1,x
	lda.w WMDATA
	sta.w frame,x
	lda.w WMDATA
	sta.b r3
	and.b #$3F
	sta.w frame+1,x
	lda.w attribute+1,x
	and.b #$E7
	sta.w attribute+1,x
	lda.b r3
	lsr a
	lsr a
	lsr a
	and.b #$18
	ora.w attribute+1,x
	sta.w attribute+1,x
	inx
	inx
	dec.b d1
	bpl .loop
	lda.b #$05
	sta.b d1
	ldx.w #$0000
.loop2:
	lda.w WMDATA
	sta.w rostnum,x
	lda.w WMDATA
	sta.w rostnum+2,x
	stz.w position+1,x
	lda.w WMDATA
	sta.b r3
	and.b #$0F
	cmp.b #$0F
	bne .3
	lda.b #$FF
	sta.w position+1,x
.3:
	sta.w position,x
	stz.w position+3,x
	lda.b r3
	lsr a
	lsr a
	lsr a
	lsr a
	and.b #$0F
	cmp.b #$0F
	bne .4
	lda.b #$FF
	sta.w position+3,x
.4:
	sta.w position+2,x
	inx
	inx
	inx
	inx
	dec.b d1
	bpl .loop2
	lda.w WMDATA
	sta.w puckz
	bpl .t1
	lda.b #$FF
	bra .5

.t1:
	lda.b #$00
.5:
	sta.w puckz+1
	lda.w WMDATA
	sta.w shadowz
	bpl .t1x
	lda.b #$FF
	bra .6

.t1x:
	lda.b #$00
.6:
	sta.w shadowz+1
	lda.w WMDATA
	sta.w recsfx
	lda.w WMDATA
	sta.w recsfxpitch
	lda.w WMDATA
	sta.w recsfxpitch+1
	lda.w WMDATA
	sta.w recsfxvol+1
	lda.w WMDATA
	sta.w recsfx2
	lda.w WMDATA
	sta.w recsfxpitch2
	lda.w WMDATA
	sta.w recsfxpitch2+1
	lda.w WMDATA
	sta.w recsfxvol2+1
	lda.w WMDATA
	sta.b d7
	lda.w WMDATA
	sta.b r3
	and.b #$0F
	sta.w PadControlObj
	lda.b r3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.w PadControlObj+2
	lda.w WMDATA
	sta.b r3
	and.b #$0F
	sta.w PadControlObj+4
	lda.b r3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.w PadControlObj+6
	lda.w WMDATA
	sta.b r3
	and.b #$0F
	sta.w PadControlObj+8
	lda.b r3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.w PadControlObj+$A
	lda.w WMDATA
	sta.l crowdlevel
	lda.w WMDATA
	sta.l crowdlevel+1
	lda.w WMDATA
	sta.w PBnum
	bpl .t1xx
	lda.b #$FF
	bra .7

.t1xx:
	lda.b #$00
.7:
	sta.w PBnum+1
	lda.w sflags
	bit.b #$20
	bne .t1xxx
	lda.w WMDATA
	sta.w Hpos
	lda.w WMDATA
	sta.w Hpos+1
	lda.w WMDATA
	sta.w Vpos
	lda.w WMDATA
	sta.w Vpos+1
	lda.w WMDATA
	sta.w benchframe
	lda.w WMDATA
	sta.w benchframe+1
	bra .8

.t1xxx:
	lda.w WMDATA
	lda.w WMDATA
	lda.w WMDATA
	lda.w WMDATA
	lda.w WMDATA
	sta.w benchframe
	lda.w WMDATA
	sta.w benchframe+1
.8:
	rep #$20
	lda.w recsfx
	and.w #$00FF
	cmp.w #$0080
	bcc .1x
	ora.w #$FF00
.1x:
	sta.w recsfx
	lda.w recsfx2
	and.w #$00FF
	cmp.w #$0080
	bcc .2x
	ora.w #$FF00
.2x:
	sta.w recsfx2
	pla
	sta.b d1
	rtl
