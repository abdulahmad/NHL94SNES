; Put one recorded replay frame back into the objects, the puck and the screen
RestoreReplayFrame:					; called from ReplayMode, adda4, suba4
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
.loop:								; loop: Xpos,x = WMDATA, r3 = WMDATA, if zero go to .1, ...
	lda.w WMDATA
	sta.w Xpos,x
	lda.w WMDATA
	sta.b r3
	and.b #$0F
	bit.b #$08
	beq .1
	ora.b #$F0
.1:									; Xpos+1,x = A, Ypos,x = WMDATA, if zero go to .2, ...
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
.2:									; Ypos+1,x = A, frame,x = WMDATA, r3 = WMDATA, ...
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
.loop2:								; loop: rostnum,x = WMDATA, rostnum+2,x = WMDATA, position+1,x = 0, ...
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
.3:									; position,x = A, position+3,x = 0, if not zero go to .4, ...
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
.4:									; position+2,x = A, X + 1, X + 1, ...
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

.t1:								; falls through
	lda.b #$00
.5:									; puckz+1 = A, shadowz = WMDATA, if plus go to .t1x, ...
	sta.w puckz+1
	lda.w WMDATA
	sta.w shadowz
	bpl .t1x
	lda.b #$FF
	bra .6

.t1x:								; falls through
	lda.b #$00
.6:									; shadowz+1 = A, recsfx = WMDATA, recsfxpitch = WMDATA, ...
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
	sta.l Crowdlevel
	lda.w WMDATA
	sta.l Crowdlevel+1
	lda.w WMDATA
	sta.w PBnum
	bpl .t1xx
	lda.b #$FF
	bra .7

.t1xx:								; falls through
	lda.b #$00
.7:									; PBnum+1 = A, if sflags bit $20 set go to .t1xxx, ...
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

.t1xxx:								; sflags bit $20 set: benchframe = WMDATA, benchframe+1 = WMDATA
	lda.w WMDATA
	lda.w WMDATA
	lda.w WMDATA
	lda.w WMDATA
	lda.w WMDATA
	sta.w benchframe
	lda.w WMDATA
	sta.w benchframe+1
.8:									; if carry clear go to .1x, ...
	rep #$20
	lda.w recsfx
	and.w #$00FF
	cmp.w #$0080
	bcc .1x
	ora.w #$FF00
.1x:								; recsfx = A, if carry clear go to .2x, ...
	sta.w recsfx
	lda.w recsfx2
	and.w #$00FF
	cmp.w #$0080
	bcc .2x
	ora.w #$FF00
.2x:								; recsfx2 = A, d1 = pulled value, return
	sta.w recsfx2
	pla
	sta.b d1
	rtl
