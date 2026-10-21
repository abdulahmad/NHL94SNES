; Save this frame into the replay buffer
updatereplay:						; called from DoGameFrame
	lda.w gmode
	bit.w #gmhl
	bne .1
	lda.w replaydelay
	beq .5
	dec a
	bne .t1
.1:									; go to .6
	jmp.w .6

.t1:								; a not yet 0: replaydelay = A
	sta.w replaydelay
.5:									; if sflags bit $0400 set go to .2, ...
	lda.w sflags
	bit.w #$0400
	bne .2
	lda.w ReplayBufferPtr
	clc
	adc.w #replaysize
	sta.w ReplayBufferPtr
	bcc .1x
	inc.w ReplayBufferPtr+2
.1x:								; if not zero go to .2, ...
	cmp.w #ReplayBufferEnd
	bne .2
	lda.w ReplayBufferPtr+2
	cmp.w #ReplayBufferEnd>>16
	bne .2
	lda.w #$0010
	tsb.w sflags
	lda.w #ReplayBufferStart>>16
	sta.w ReplayBufferPtr+2
	lda.w #ReplayBufferStart
	sta.w ReplayBufferPtr
.2:									; WMADDL = ReplayBufferPtr, WMADDH = ReplayBufferPtr+2, d2 = $0F, ...
	sep #$20
	ldx.w ReplayBufferPtr
	stx.w WMADDL
	lda.w ReplayBufferPtr+2
	sta.w WMADDH
	lda.b #$0F
	sta.b d2
	ldx.w #$0000
	ldy.w #$0001
.loop:								; loop: WMDATA = Xpos,x, r3 = Xpos+1,x & $0F, ora r3, ...
	lda.w Xpos,x
	sta.w WMDATA
	lda.w Xpos+1,x
	and.b #$0F
	sta.b r3
	lda.w Ypos+1,x
	asl a
	asl a
	asl a
	asl a
	ora.b r3
	sta.w WMDATA
	lda.w Ypos,x
	sta.w WMDATA
	lda.w frame,x
	sta.w WMDATA
	lda.w frame+1,x
	and.b #$3F
	sta.b r3
	lda.w attribute+1,x
	and.b #$18
	asl a
	asl a
	asl a
	ora.b r3
	sta.w WMDATA
	inx
	inx
	dec.b d2
	bpl .loop
	lda.b #$05
	sta.b d2
	ldx.w #$0000
.loop2:								; loop: WMDATA = rostnum,x, WMDATA = rostnum+2,x, if position,x >= 0 go...
	lda.w rostnum,x
	sta.w WMDATA
	lda.w rostnum+2,x
	sta.w WMDATA
	lda.w position,x
	bpl .3
	lda.b #$FF
.3:									; and #$0F, r3 = A, if position+2,x >= 0 go to .4, ...
	and.b #$0F
	sta.b r3
	lda.w position+2,x
	bpl .4
	lda.b #$FF
.4:									; asl a, asl a, asl a, ...
	asl a
	asl a
	asl a
	asl a
	ora.b r3
	sta.w WMDATA
	inx
	inx
	inx
	inx
	dec.b d2
	bpl .loop2
	lda.w puckz
	sta.w WMDATA
	lda.w shadowz
	sta.w WMDATA
	lda.w recsfx
	sta.w WMDATA
	lda.w recsfxpitch
	sta.w WMDATA
	lda.w recsfxpitch+1
	sta.w WMDATA
	lda.w recsfxvol+1
	sta.w WMDATA
	lda.w recsfx2
	sta.w WMDATA
	lda.w recsfxpitch2
	sta.w WMDATA
	lda.w recsfxpitch2+1
	sta.w WMDATA
	lda.w recsfxvol2+1
	sta.w WMDATA
	lda.b d7
	sta.w WMDATA
	lda.w PadControlObj+2
	asl a
	asl a
	asl a
	asl a
	ora.w PadControlObj
	sta.w WMDATA
	lda.w PadControlObj+6
	asl a
	asl a
	asl a
	asl a
	ora.w PadControlObj+4
	sta.w WMDATA
	lda.w PadControlObj+$A
	asl a
	asl a
	asl a
	asl a
	ora.w PadControlObj+8
	sta.w WMDATA
	lda.l Crowdlevel
	sta.w WMDATA
	lda.l Crowdlevel+1
	sta.w WMDATA
	lda.w PBnum
	sta.w WMDATA
	lda.w Hpos
	sta.w WMDATA
	lda.w Hpos+1
	sta.w WMDATA
	lda.w Vpos
	sta.w WMDATA
	lda.w Vpos+1
	sta.w WMDATA
	lda.w benchframe
	sta.w WMDATA
	lda.w benchframe+1
	sta.w WMDATA
	rep #$20
	lda.w #$FFFF
	sta.w recsfx
	sta.w recsfx2
.6:									; return
	rtl
