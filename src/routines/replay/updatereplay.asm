; Save this frame into the replay buffer
updatereplay:						; called from DoGameFrame
	lda.w gmode						;game mode
	bit.w #gmhl						;highlight?
	bne .1							;yes: no recording
	lda.w replaydelay				;replay delay
	beq .5							;none: record
	dec a							;count it down
	bne .t1							;still waiting: record
.1:									; go to .6
	jmp.w .6						;reached 0: stop recording

.t1:								; a not yet 0: replaydelay = A
	sta.w replaydelay
.5:									; if sflags bit $0400 set go to .2, ...
	lda.w sflags					;flags
	bit.w #$0400					;recording paused?
	bne .2							;yes: overwrite the frame
	lda.w recbpr					;record pointer
	clc
	adc.w #replaysize				;next frame
	sta.w recbpr
	bcc .1x							;no carry
	inc.w recbpr+2					;next bank
.1x:								; if not zero go to .2, ...
	cmp.w #replayend				;at the end?
	bne .2							;no
	lda.w recbpr+2
	cmp.w #replayend>>16			;same bank?
	bne .2							;no
	lda.w #$0010					;buffer wrapped
	tsb.w sflags					;flag it
	lda.w #replaystart>>16
	sta.w recbpr+2					;back to the start
	lda.w #replaystart
	sta.w recbpr
.2:									; WMADDL = recbpr, WMADDH = recbpr+2, d2 = $0F, ...
	sep #$20
	ldx.w recbpr					;frame address
	stx.w WMADDL					;WRAM port address
	lda.w recbpr+2
	sta.w WMADDH					;bank
	lda.b #$0F						;16 objects
	sta.b d2
	ldx.w #$0000					;from object 0
	ldy.w #$0001
.loop:								; loop: WMDATA = Xpos,x, r3 = Xpos+1,x & $0F, ora r3, ...
	lda.w Xpos,x					;x low
	sta.w WMDATA					;byte 0
	lda.w Xpos+1,x					;x high
	and.b #$0F						;low nibble
	sta.b r3						;r3
	lda.w Ypos+1,x					;y high
	asl a							;x16
	asl a
	asl a
	asl a
	ora.b r3						;plus the x high nibble
	sta.w WMDATA					;byte 1
	lda.w Ypos,x					;y low
	sta.w WMDATA					;byte 2
	lda.w frame,x					;frame low
	sta.w WMDATA					;byte 3
	lda.w frame+1,x					;frame high
	and.b #$3F						;6 bits
	sta.b r3
	lda.w attribute+1,x				;attribute flips
	and.b #$18						;h and v flip bits
	asl a							;shifted up
	asl a
	asl a
	ora.b r3						;plus the frame high bits
	sta.w WMDATA					;byte 4
	inx
	inx
	dec.b d2						;count
	bpl .loop						;all 16
	lda.b #$05						;6 pairs
	sta.b d2
	ldx.w #$0000					;from object 0
.loop2:								; loop: WMDATA = rostnum,x, WMDATA = rostnum+2,x, if position,x >= 0 go...
	lda.w rostnum,x					;roster number
	sta.w WMDATA					;byte
	lda.w rostnum+2,x				;next player's
	sta.w WMDATA					;byte
	lda.w position,x				;position
	bpl .3							;on the ice
	lda.b #$FF						;none: $F
.3:									; and #$0F, r3 = A, if position+2,x >= 0 go to .4, ...
	and.b #$0F						;low nibble
	sta.b r3
	lda.w position+2,x				;next player's position
	bpl .4							;on the ice
	lda.b #$FF						;none: $F
.4:									;x16
	asl a
	asl a
	asl a
	asl a
	ora.b r3						;plus the first
	sta.w WMDATA					;packed byte
	inx
	inx
	inx
	inx
	dec.b d2						;count
	bpl .loop2						;all 6 pairs
	lda.w puckz						;puck height
	sta.w WMDATA
	lda.w shadowz					;shadow height
	sta.w WMDATA
	lda.w recsfx					;sound 1
	sta.w WMDATA
	lda.w recsfxpitch				;its pitch
	sta.w WMDATA
	lda.w recsfxpitch+1				;pitch high
	sta.w WMDATA
	lda.w recsfxvol+1				;volume
	sta.w WMDATA
	lda.w recsfx2					;sound 2
	sta.w WMDATA
	lda.w recsfxpitch2				;its pitch
	sta.w WMDATA
	lda.w recsfxpitch2+1			;pitch high
	sta.w WMDATA
	lda.w recsfxvol2+1				;volume
	sta.w WMDATA
	lda.b d7						;frame time
	sta.w WMDATA
	lda.w PadControlObj+2			;pad 2's object
	asl a							;x16
	asl a
	asl a
	asl a
	ora.w PadControlObj				;plus pad 1's
	sta.w WMDATA					;packed
	lda.w PadControlObj+6			;pad 4's
	asl a
	asl a
	asl a
	asl a
	ora.w PadControlObj+4			;plus pad 3's
	sta.w WMDATA
	lda.w PadControlObj+$A			;pad 6's
	asl a
	asl a
	asl a
	asl a
	ora.w PadControlObj+8			;plus pad 5's
	sta.w WMDATA
	lda.l Crowdlevel				;crowd level
	sta.w WMDATA
	lda.l Crowdlevel+1				;high byte
	sta.w WMDATA
	lda.w PBnum						;score digits
	sta.w WMDATA
	lda.w Hpos						;view x
	sta.w WMDATA
	lda.w Hpos+1					;high byte
	sta.w WMDATA
	lda.w Vpos						;view y
	sta.w WMDATA
	lda.w Vpos+1					;high byte
	sta.w WMDATA
	lda.w benchframe				;bench frame
	sta.w WMDATA
	lda.w benchframe+1				;high byte
	sta.w WMDATA
	rep #$20
	lda.w #$FFFF					;sounds recorded
	sta.w recsfx					;clear them
	sta.w recsfx2
.6:									; return
	rtl
