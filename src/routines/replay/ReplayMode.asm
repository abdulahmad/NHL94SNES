; Instant replay
ReplayMode:							; called from PauseReplay
	lda.w SoundFadeSpeed
	bne ReplayMode
	jsl.l SPCGameUpload
	lda.w #$0000
	sta.l Crowdlevel
	lda.w #$0800
	tsb.w sflags
	jsl.l ClrHor
	lda.w #$FFFF
	sta.w textdirtylo
	stz.w textdirtyhi
	lda.l blankchar
	clc
	adc.l charofs
	ldx.w #$0400
	ldy.w #$0000
	jsl.l FillVRAMSplit
	lda.w #$FFFF
	sta.w replaylock
	sta.l replaypanel
	lda.w #rinkmapbuf>>16
	sta.b p0+2
	lda.w #rinkmapbuf
	sta.b p0
	lda.w #$0020
	sta.b r7
	lda.w #$0055
	sta.b r7+2
	lda.w #$0008
	sta.b r4
	lda.w #$0008
	sta.b r4+2
	lda.w #$0000
	sta.w MapVRAM
	lda.w #$2000
	sta.b r3
	lda.l charofs
	ldx.w #$0002
	ldy.w #$0002
	jsl.l MapPartToVRAMOffset
	lda.w ReplayBufferPtr
	pha
	lda.w ReplayBufferPtr+2
	pha
	lda.w #$0020
	trb.w sflags
	lda.w Vpos
	pha
	lda.w Hpos
	pha
	lda.w ReplayBufferPtr
	cmp.w #ReplayBufferStart
	lda.w ReplayBufferPtr+2
	sbc.w #ReplayBufferStart>>16
	bcs .1
.loop:								; loop: ReplayBufferPtr+2 = $007E, ReplayBufferPtr = ReplayBufferStart
	lda.w #ReplayBufferStart>>16
	sta.w ReplayBufferPtr+2
	lda.w #ReplayBufferStart
	sta.w ReplayBufferPtr
.1:									; if carry clear go to .loop, ...
	lda.w #ReplayBufferEnd
	cmp.w ReplayBufferPtr
	lda.w #ReplayBufferEnd>>16
	sbc.w ReplayBufferPtr+2
	bcc .loop
	lda.w ReplayBufferPtr
	sec
	sbc.w #ReplayBufferStart
	sta.b r2
	lda.w ReplayBufferPtr+2
	sbc.w #ReplayBufferStart>>16
	sta.b r2+2
	lda.w #replaysize
	sta.b r1
	jsl.l Div32U
	lda.b r2+2
	bne .loop
	lda.w ReplayBufferPtr+2
	sta.b a4+2
	lda.w ReplayBufferPtr
	sta.b a4
	lda.w #$0000
	pha
.loop2:								; loop: call suba4, if d7 != 0 go to .loop2, ...
	jsl.l suba4
	pla
	inc a
	pha
	lda.b d7
	bne .loop2
	pla
	lsr a
	pha
.loop3:								; loop: if r0+1,s = 0 go to .t1, ...
	lda.b r0+1,s
	beq .t1
	jsl.l adda4
	pla
	dec a
	pha
	bra .loop3

.t1:								; r0+1,s = 0: replayHpos = Hpos, replayVpos = Vpos, call InitSprites, ...
	pla
	lda.w Hpos
	sta.w replayHpos
	lda.w Vpos
	sta.w replayVpos
	ldx.w #$0000
	ldy.w #$01C0
	lda.w #$6000
	jsl.l InitSprites
	stz.w brightness
	lda.w #$000A
	sta.w fadestep
	ldx.w #BrightnessHook>>16
	lda.w #BrightnessHook
	jsl.l SetFrameHook
	jsl.l ScreenOn
	jsl.l SprSort
	jsl.l SpriteFrameStart
	jsl.l setvideo
	jsl.l SpriteFrameEnd
	lda.w #$0001
	sta.b d7
	lda.w #$0002
	trb.w sflags3
	jmp.w .13
.10:								; if replaylock >= 0 go to .t2, ...
	lda.w replaylock
	bpl .t2
	jmp.w .7

.t2:								; replaylock >= 0: Xpos+camobj = Xpos,x, if plus go to .t1x, ...
	tax
	lda.w Xpos,x
	sta.w Xpos+camobj
	cmp.w replayHpos
	bpl .t1x
	lda.w replayHpos
	sec
	sbc.w #$0004
	cmp.w Xpos+camobj
	bpl .2
.1x:								; falls through
	lda.w Xpos+camobj
.2:									; go to .5
	bra .5

.t1x:								; if minus go to .5, ...
	lda.w replayHpos
	clc
	adc.w #$0004
	cmp.w Xpos+camobj
	bmi .5
	lda.w Xpos+camobj
.5:									; if plus go to .1xx, ...
	cmp.w #$FFC0
	bpl .1xx
	lda.w #$FFC0
.1xx:								; if minus go to .2x, ...
	cmp.w #$0040
	bmi .2x
	lda.w #$0040
.2x:								; Hpos = A, replayHpos = A, Ypos+camobj = Ypos,x, ...
	sta.w Hpos
	sta.w replayHpos
	lda.w Ypos,x
	sta.w Ypos+camobj
	cmp.w replayVpos
	bpl .t1xx
	lda.w replayVpos
	sec
	sbc.w #$0004
	cmp.w Ypos+camobj
	bpl .4
.3:									; falls through
	lda.w Ypos+camobj
.4:									; go to .6
	bra .6

.t1xx:								; if minus go to .6, ...
	lda.w replayVpos
	clc
	adc.w #$0004
	cmp.w Ypos+camobj
	bmi .6
	lda.w Ypos+camobj
.6:									; if plus go to .2xx
	cmp.w #$FF39
	bpl .2xx
.1xxx:								; falls through
	lda.w #$FF39
.2xx:								; if minus go to .4x
	cmp.w #$0100
	bmi .4x
.3x:								; falls through
	lda.w #$0100
.4x:								; Vpos = A, replayVpos = A, PadControlObj+$C = X / 2, ...
	sta.w Vpos
	sta.w replayVpos
	txa
	lsr a
	sta.w PadControlObj+$C
	jmp.w .12

.7:									; if zero go to .11, ...
	cmp.w #$FFFF
	beq .11
	lda.w Xpos+camobj
	cmp.w replayHpos
	bpl .t2x
	lda.w replayHpos
	sec
	sbc.w #$0002
	cmp.w Xpos+camobj
	bpl .1xxxx
	lda.w Xpos+camobj
.1xxxx:								; go to .8
	bra .8

.t2x:								; Xpos+camobj - replayHpos >= 0: if minus go to .8, ...
	lda.w replayHpos
	clc
	adc.w #$0002
	cmp.w Xpos+camobj
	bmi .8
	lda.w Xpos+camobj
.8:									; if plus go to .1xxxxx, ...
	cmp.w #$FFC0
	bpl .1xxxxx
	lda.w #$FFC0
.1xxxxx:							; if minus go to .2xxx, ...
	cmp.w #$0040
	bmi .2xxx
	lda.w #$0040
.2xxx:								; Hpos = A, replayHpos = A, compare Ypos+camobj with replayVpos
	sta.w Hpos
	sta.w replayHpos
	lda.w Ypos+camobj
	cmp.w replayVpos
	bpl .t1xxx
	lda.w replayVpos
	sec
	sbc.w #$0002
	cmp.w Ypos+camobj
	bpl .3xx
	lda.w Ypos+camobj
.3xx:								; go to .9
	bra .9

.t1xxx:								; Ypos+camobj - replayVpos >= 0: if minus go to .9, ...
	lda.w replayVpos
	clc
	adc.w #$0002
	cmp.w Ypos+camobj
	bmi .9
	lda.w Ypos+camobj
.9:									; if plus go to .2xxxx
	cmp.w #$FF39
	bpl .2xxxx
.1xxxxxx:							; falls through
	lda.w #$FF39
.2xxxx:								; if minus go to .4xx
	cmp.w #$0100
	bmi .4xx
.3xxx:								; falls through
	lda.w #$0100
.4xx:								; Vpos = A, replayVpos = A, go to .12
	sta.w Vpos
	sta.w replayVpos
	bra .12
.11:								; replayHpos = Hpos, replayVpos = Vpos
	lda.w Hpos
	sta.w replayHpos
	lda.w Vpos
	sta.w replayVpos
.12:								; timestep = d7, call SprSort, call SpriteFrameStart, ...
	lda.b d7
	sta.w timestep
	jsl.l SprSort
	jsl.l SpriteFrameStart
	jsl.l setvideo
	jsl.l SpriteFrameEnd
	stz.w replaynewframe
.13:								; if d7 != 0 go to .2xxxxx
	ldx.b d7
	bne .2xxxxx
.1xxxxxxx:							; X + 1
	inx
.2xxxxx:							; call WaitFrames_Inc, call ReadPads, call ReadPausePad, ...
	ldy.w #$0000
	jsl.l WaitFrames_Inc
	jsl.l ReadPads
	jsl.l ReadPausePad
	lda.w #$0001
	sta.b d7
	lda.b d0
	bit.w #$0008
	beq .t2xx
	jmp.w .16

.t2xx:								; d0 bits $0008 clear: d5 = A, d4 = $FFFF, d4+2 = $FFFF, ...
	sta.b d5
	lda.w #$FFFF
	sta.b d4
	sta.b d4+2
	sta.w replaylock
	lda.w #$0016
	sta.b a0
.loopx:								; loop: if position,y negative go to .4xxx, ...
	ldy.b a0
	lda.w position,y
	bmi .4xxx
	lda.w Xpos,y
	sec
	sbc.w Xpos+camobj
	sta.b d0
	sta.b d2
	lda.w Ypos,y
	sec
	sbc.w Ypos+camobj
	sta.b d1
	sta.b d3
	jsl.l vtoa
	cmp.w #$0008
	beq .4xxx
	sec
	sbc.b d5
	beq .1xxxxxxxx
	cmp.w #$0001
	beq .1xxxxxxxx
	cmp.w #$0007
	bne .4xxx
.1xxxxxxxx:							; if zero go to .2xxxxxx, ...
	lda.b d2
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .2xxxxxx
	ora.w #$E000
.2xxxxxx:							; call Mul8S, d0 = A, if zero go to .3xxxx, ...
	tax
	jsl.l Mul8S
	sta.b d0
	lda.b d3
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .3xxxx
	ora.w #$E000
.3xxxx:								; call Mul8S, adc d0, if carry set go to .4xxx, ...
	tax
	jsl.l Mul8S
	clc
	adc.b d0
	cmp.b d4+2
	bcs .4xxx
	sta.b d4+2
	lda.b a0
	sta.b d4
.4xxx:								; decrement a0, decrement a0, if a0 still >= 0 go to .loopx, ...
	dec.b a0
	dec.b a0
	bpl .loopx
	lda.b d4
	bmi .t1xxxx
	lda.b d4+2
	cmp.w #$0002
	bcs .t1xxxx
	lda.b d4
	sta.w replaylock
	lda.w #$001E
	sta.b d7
	lda.w #$0020
	trb.w sflags
	jmp.w .10

.t1xxxx:							; call ReadPausePad, replaylock = $FFFE, tsb sflags, ...
	phk								; data bank = program bank
	plb
	jsl.l ReadPausePad
	lda.w #$FFFE
	sta.w replaylock
	lda.w #$0020
	tsb.w sflags
	asl.b d0
	asl.b d0
	ldy.b d0
	lda.w .14,y
	adc.w Xpos+camobj
	sta.b d2
	ldx.w #camobj
	lda.w .14,y
	xba
	and.w #$FF00
	sta.w Xvel,x
	lda.w .14+2,y
	clc
	adc.w Ypos+camobj
	sta.b d3
	lda.w .14+2,y
	xba
	and.w #$FF00
	sta.w Yvel,x
	lda.b d2
	pha
	lda.b d3
	pha
	stx.b a3
	stz.w Wallcos,x
	stz.w Wallsin,x
	lda.w #$0001
	sta.w wcradiusx
	sta.w wcradiusy
	jsl.l checkwallcoll
	pla
	sta.b d3
	pla
	sta.b d2
	lda.w Wallsin,x
	ora.w Wallcos,x
	beq .4xxxx
.1xxxxxxxxx:						; xba, and #$00FF, if carry clear go to .2xxxxxxx, ...
	lda.w Wallsin,x
	asl a
	xba
	and.w #$00FF
	cmp.w #$0080
	bcc .2xxxxxxx
	ora.w #$FF00
.2xxxxxxx:							; adc Xpos+camobj, d2 = A, xba, ...
	clc
	adc.w Xpos+camobj
	sta.b d2
	lda.w Wallcos,x
	asl a
	xba
	and.w #$00FF
	cmp.w #$0080
	bcc .3xxxxx
	ora.w #$FF00
.3xxxxx:							; eor #$FFFF, increment a, adc Ypos+camobj, ...
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.w Ypos+camobj
	sta.b d3
.4xxxx:								; Xpos+camobj = d2, Hpos = d2, Ypos+camobj = d3, ...
	lda.b d2
	sta.w Xpos+camobj
	sta.w Hpos
	lda.b d3
	sta.w Ypos+camobj
	sta.w Vpos
	lda.w #$0010
	sta.w PadControlObj+$C
	jmp.w .10
.14:								; x and y steps (words) for eight directions
	dw $0000,$0002, $0002,$0002, $0002,$0000, $0002,$FFFE
	dw $0000,$FFFE, $FFFE,$FFFE, $FFFE,$0000, $FFFE,$0002
.16:								; if replaylock != $FFFF go to .9x, ...
	lda.w replaylock
	cmp.w #$FFFF
	bne .9x
	lda.w PadControlObj
	cmp.w #$000F
	beq .t1xxxxx
	asl a
	tax
	lda.w #$000F
	sta.w PadControlObj+$C
	lda.w Xpos,x
	sta.w Xpos+camobj
	lda.w Ypos,x
	sta.w Ypos+camobj
	bra .9x

.t1xxxxx:							; PadControlObj = $000F: PadControlObj+$C = $000F, if puckx - $FF78 >=...
	lda.w #$000F
	sta.w PadControlObj+$C
	lda.w puckx
	cmp.w #$FF78
	bpl .2xxxxxxxx
.1xxxxxxxxxx:						; falls through
	lda.w #$FF78
.2xxxxxxxx:							; if minus go to .4xxxxx
	cmp.w #sideline
	bmi .4xxxxx
.3xxxxxx:							; falls through
	lda.w #sideline
.4xxxxx:							; Xpos+camobj = A, if pucky - $FED4 >= 0 go to .6x
	sta.w Xpos+camobj
	lda.w pucky
	cmp.w #$FED4
	bpl .6x
.5x:								; falls through
	lda.w #$FED4
.6x:								; if minus go to .8x
	cmp.w #$012C
	bmi .8x
.7x:								; falls through
	lda.w #$012C
.8x:								; Ypos+camobj = A
	sta.w Ypos+camobj
.9x:								; if d1 bits $8000 clear go to .2xxxxxxxxx, ...
	lda.b d1
	bit.w #$8000
	beq .2xxxxxxxxx
	lda.l replaypanel
	beq .1xxxxxxxxxxx
	lda.l blankchar
	clc
	adc.l charofs
	ldx.w #$0180
	ldy.w #$0000
	jsl.l FillVRAMSplit
	jsl.l WaitFrame
	lda.w #$0000
	sta.l replaypanel
.1xxxxxxxxxxx:						; eor #$0002, sflags3 = A
	lda.w sflags3
	eor.w #$0002
	sta.w sflags3
.2xxxxxxxxx:						; if d3 bit $0020 set go to .t1xxxxxx, ...
	lda.b d3
	bit.w #$0020
	bne .t1xxxxxx
	bit.w #$0050
	bne .t5
	lda.b d1
	bit.w #$2000
	bne .t3
	bit.w #$1000
	bne .t2xxx
	lda.b d3
	bit.w #$0080
	bne .t4
	bit.w #$4000
	beq .12x
	jsl.l suba4
	jsl.l suba4
	bra .11x

.t1xxxxxx:							; d3 bit $0020 set: call suba4, go to .10x
	jsl.l suba4
	ldx.w #$0006
	bra .10x

.t2xxx:								; go to .15
	jmp.w .15

.t3:								; d1 bit $2000 set: replaylock = $FFFF, trb sflags, go to .13
	lda.w #$FFFF
	sta.w replaylock
	lda.w #$0020
	trb.w sflags
	jmp.w .13

.t4:								; d3 bit $0080 set: call adda4, call adda4, go to .11x
	jsl.l adda4
	jsl.l adda4
	bra .11x

.t5:								; call adda4, if d3 bit $0010 set go to .10x, ...
	jsl.l adda4
	ldx.w #$0006
	lda.b d3
	bit.w #$0010
	bne .10x
	ldx.w #$000C
.10x:								; call WaitFrames_Inc
	ldy.w #$0000
	jsl.l WaitFrames_Inc
.11x:								; call SoundVoicesOff, d7 = $0001, trb sflags3, ...
	jsl.l SoundVoicesOff
	lda.w #$0001
	sta.b d7
	lda.w #$0002
	trb.w sflags3
	jmp.w .10
.12x:								; if sflags3 bit $0002 set go to .t1xxxxxxx, ...
	lda.w sflags3
	bit.w #$0002
	bne .t1xxxxxxx
	jmp.w .13

.t1xxxxxxx:							; sflags3 bit $0002 set: call adda4, if d7 = 0 go to .11x, ...
	jsl.l adda4
	lda.b d7
	beq .11x
	lda.w recsfx2
	and.w #$00FF
	cmp.w #$00FF
	beq .13x
	cmp.w #$0016
	bcs .t2xxxx
	lda.w recsfxvol2
	sta.b SfxVelocity
	lda.w recsfx2
	and.w #$00FF
	jsl.l QueueSound
	tay
	sep #$20
	lda.w VoiceState,y
	cmp.b #$02
	bne .1xxxxxxxxxxxx
	lda.b #$03
	sta.w VoiceState,y
	rep #$20
	tya
	asl a
	tay
	lda.w recsfxpitch2
	sta.w VoicePitch,y
.1xxxxxxxxxxxx:						; go to .13x
	rep #$20
	bra .13x

.t2xxxx:							; sbc #$0015, call StreamSfx
	sec
	sbc.w #$0015
	jsl.l StreamSfx
.13x:								; if zero go to .14x, ...
	lda.w recsfx
	and.w #$00FF
	cmp.w #$00FF
	beq .14x
	cmp.w #$0016
	bcs .t1xxxxxxxx
	lda.w recsfxvol
	sta.b SfxVelocity
	lda.w recsfx
	and.w #$00FF
	jsl.l QueueSound
	tay
	sep #$20
	lda.w VoiceState,y
	cmp.b #$02
	bne .1xxxxxxxxxxxxx
org $9BB001
	lda.b #$03
	sta.w VoiceState,y
	rep #$20
	tya
	asl a
	tay
	lda.w recsfxpitch
	sta.w VoicePitch,y
.1xxxxxxxxxxxxx:					; go to .14x
	rep #$20
	bra .14x

.t1xxxxxxxx:						; sbc #$0015, call StreamSfx
	sec
	sbc.w #$0015
	jsl.l StreamSfx
.14x:								; go to .10
	jmp.w .10
.15:								; PadControlObj+$C = $000F, call SoundVoicesOff, Hpos = pulled value, ...
	lda.w #$000F
	sta.w PadControlObj+$C
	jsl.l SoundVoicesOff
	pla
	sta.w Hpos
	pla
	sta.w Vpos
	pla
	sta.w ReplayBufferPtr+2
	pla
	sta.w ReplayBufferPtr
	lda.w #$0020
	trb.w sflags
	lda.w ReplayBufferPtr+2
	sta.b a4+2
	lda.w ReplayBufferPtr
	sta.b a4
	jsl.l RestoreReplayFrame
	lda.w #$0800
	trb.w sflags
	jsl.l SetHor
	jsl.l SpriteFrameStart
	jsl.l setvideo
	jsl.l SpriteFrameEnd
	stz.w textdirtylo
	lda.w #$03FF
	sta.w textdirtyhi
	jsl.l FadeOut
	jsl.l FadeOutSound
.loopxx:							; loop: if brightness != 0 go to .loopxx, ...
	lda.w brightness
	bne .loopxx
	lda.w SoundFadeSpeed
	bne .loopxx
	jsl.l forceblack
	lda.w shootoutmode
	bne .1xxxxxxxxxxxxxx
	lda.w replaymusic
	beq .1xxxxxxxxxxxxxx
	jsl.l SPCMenuUpload
	lda.l OptPlayMode
	beq .t1xxxxxxxxx
	cmp.w #$0004
	beq .t1xxxxxxxxx
	lda.l playoffRoundIdx
	cmp.w #$0002
	bcc .t1xxxxxxxxx
	lda.w #PlayoffSong>>16
	sta.b p0+2
	lda.w #PlayoffSong
	sta.b p0
	jsl.l MusicStart
	jmp.w .1xxxxxxxxxxxxxx

.t1xxxxxxxxx:						; p0 = MenuSong, call MusicStart
	lda.w #MenuSong>>16
	sta.b p0+2
	lda.w #MenuSong
	sta.b p0
	jsl.l MusicStart
.1xxxxxxxxxxxxxx:					; return
	rtl
