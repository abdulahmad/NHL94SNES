; Put one recorded replay frame back into the objects, the puck and the screen
RestoreReplayFrame:					; called from ReplayMode, adda4, suba4
	lda.b d1
	pha
	inc.w replaynewframe			;a new frame shown
	sep #$20
	ldx.b a4						;frame address
	stx.w WMADDL					;WRAM port address
	lda.b a4+2
	sta.w WMADDH					;bank
	lda.b #$0F						;16 objects
	sta.b d1
	ldx.w #$0000					;from object 0
.loop:								; loop: Xpos,x = WMDATA, r3 = WMDATA, if zero go to .1, ...
	lda.w WMDATA					;byte 0
	sta.w Xpos,x					;x low
	lda.w WMDATA					;byte 1
	sta.b r3						;keep it
	and.b #$0F						;x high nibble
	bit.b #$08						;negative?
	beq .1
	ora.b #$F0						;sign extend
.1:									; Xpos+1,x = A, Ypos,x = WMDATA, if zero go to .2, ...
	sta.w Xpos+1,x					;x high
	lda.w WMDATA					;byte 2
	sta.w Ypos,x					;y low
	lda.b r3						;byte 1
	lsr a
	lsr a
	lsr a
	lsr a							;y high nibble
	bit.b #$08						;negative?
	beq .2
	ora.b #$F0						;sign extend
.2:									; Ypos+1,x = A, frame,x = WMDATA, r3 = WMDATA, ...
	sta.w Ypos+1,x					;y high
	lda.w WMDATA					;byte 3
	sta.w frame,x					;frame low
	lda.w WMDATA					;byte 4
	sta.b r3						;keep it
	and.b #$3F						;frame high bits
	sta.w frame+1,x
	lda.w attribute+1,x				;attribute
	and.b #$E7						;clear the flips
	sta.w attribute+1,x
	lda.b r3						;byte 4
	lsr a
	lsr a
	lsr a							;flips back in place
	and.b #$18
	ora.w attribute+1,x				;plus the attribute
	sta.w attribute+1,x				;restored
	inx
	inx
	dec.b d1						;count
	bpl .loop						;all 16
	lda.b #$05						;6 pairs
	sta.b d1
	ldx.w #$0000					;from object 0
.loop2:								; loop: rostnum,x = WMDATA, rostnum+2,x = WMDATA, position+1,x = 0, ...
	lda.w WMDATA					;roster number
	sta.w rostnum,x
	lda.w WMDATA					;next player's
	sta.w rostnum+2,x
	stz.w position+1,x				;position high 0
	lda.w WMDATA					;packed positions
	sta.b r3						;keep it
	and.b #$0F						;first
	cmp.b #$0F						;none ($F)?
	bne .3
	lda.b #$FF						;none: -1
	sta.w position+1,x
.3:									;position high
	sta.w position,x				;position
	stz.w position+3,x				;next high 0
	lda.b r3
	lsr a
	lsr a
	lsr a
	lsr a							;second
	and.b #$0F
	cmp.b #$0F						;none ($F)?
	bne .4
	lda.b #$FF						;none: -1
	sta.w position+3,x
.4:									;position high
	sta.w position+2,x				;position
	inx
	inx
	inx
	inx
	dec.b d1						;count
	bpl .loop2						;all 6
	lda.w WMDATA
	sta.w puckz						;puck height
	bpl .t1							;above the ice
	lda.b #$FF						;below: high $FF
	bra .5

.t1:								; falls through
	lda.b #$00						;high 0
.5:									; puckz+1 = A, shadowz = WMDATA, if plus go to .t1x, ...
	sta.w puckz+1					;puck height high
	lda.w WMDATA
	sta.w shadowz					;shadow height
	bpl .t1x						;above
	lda.b #$FF						;below: $FF
	bra .6

.t1x:								; falls through
	lda.b #$00						;high 0
.6:									; shadowz+1 = A, recsfx = WMDATA, recsfxpitch = WMDATA, ...
	sta.w shadowz+1					;shadow high
	lda.w WMDATA
	sta.w recsfx					;sound 1
	lda.w WMDATA
	sta.w recsfxpitch				;its pitch
	lda.w WMDATA
	sta.w recsfxpitch+1				;pitch high
	lda.w WMDATA
	sta.w recsfxvol+1				;volume
	lda.w WMDATA
	sta.w recsfx2					;sound 2
	lda.w WMDATA
	sta.w recsfxpitch2				;its pitch
	lda.w WMDATA
	sta.w recsfxpitch2+1			;pitch high
	lda.w WMDATA
	sta.w recsfxvol2+1				;volume
	lda.w WMDATA
	sta.b d7						;frame time
	lda.w WMDATA
	sta.b r3						;pad objects
	and.b #$0F						;pad 1
	sta.w PadControlObj				;pad 1's object
	lda.b r3						;pad 2
	lsr a
	lsr a
	lsr a
	lsr a
	sta.w PadControlObj+2			;pad 2's object
	lda.w WMDATA
	sta.b r3						;pad 3 and 4
	and.b #$0F
	sta.w PadControlObj+4			;pad 3's object
	lda.b r3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.w PadControlObj+6			;pad 4's object
	lda.w WMDATA
	sta.b r3						;pad 5 and 6
	and.b #$0F
	sta.w PadControlObj+8			;pad 5's object
	lda.b r3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.w PadControlObj+$A			;pad 6's object
	lda.w WMDATA
	sta.l Crowdlevel				;crowd level
	lda.w WMDATA
	sta.l Crowdlevel+1				;high byte
	lda.w WMDATA
	sta.w PBnum						;score digits
	bpl .t1xx						;positive
	lda.b #$FF						;negative: $FF
	bra .7

.t1xx:								; falls through
	lda.b #$00						;high 0
.7:									; PBnum+1 = A, if sflags bit $20 set go to .t1xxx, ...
	sta.w PBnum+1					;score high
	lda.w sflags					;flags
	bit.b #$20						;replay camera on?
	bne .t1xxx						;yes: skip the view
	lda.w WMDATA
	sta.w Hpos						;view x
	lda.w WMDATA
	sta.w Hpos+1					;high
	lda.w WMDATA
	sta.w Vpos						;view y
	lda.w WMDATA
	sta.w Vpos+1					;high
	lda.w WMDATA
	sta.w benchframe				;bench frame
	lda.w WMDATA
	sta.w benchframe+1				;high
	bra .8

.t1xxx:								;camera on: skip the view bytes
	lda.w WMDATA
	lda.w WMDATA
	lda.w WMDATA
	lda.w WMDATA
	lda.w WMDATA
	sta.w benchframe				;bench frame
	lda.w WMDATA
	sta.w benchframe+1				;high
.8:									; if carry clear go to .1x, ...
	rep #$20
	lda.w recsfx					;sound 1
	and.w #$00FF
	cmp.w #$0080					;signed byte?
	bcc .1x
	ora.w #$FF00					;sign extend
.1x:								; recsfx = A, if carry clear go to .2x, ...
	sta.w recsfx					;sound 1
	lda.w recsfx2					;sound 2
	and.w #$00FF
	cmp.w #$0080					;signed?
	bcc .2x
	ora.w #$FF00					;sign extend
.2x:								; recsfx2 = A, d1 = pulled value, return
	sta.w recsfx2					;sound 2
	pla
	sta.b d1
	rtl
