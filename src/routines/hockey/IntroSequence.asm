; The power-on sequence before the title: its own sample set (SPCIntroUpload) and song, a mode 7 picture with
; its frame hook, until it ends or a button
IntroSequence:
	stz.w brightness
	jsl.l forceblack
	jsl.l CheckPAL
	jsl.l SPCIntroUpload
	sep #$20
	lda.b #$FF
	sta.w Mode7InUse
	rep #$30
	ldy.w #$01A0
	lda.w #$6000
	ldx.w #$0000
	jsl.l InitSprites
	stz.b DMAQueueHead
	stz.b DMAQueueTail
	lda.w #.1
	sta.b p0
	lda.w #$009F
	sta.b p0+2
	jsl.l .33
	jsr.w .2
	stz.b introHookFlags
	jsr.w .3
	stz.w fadestep
	stz.w brightness
	jsl.l SpriteFrameStart
	jsl.l SpriteFrameEnd
	ldx.w #.framehook>>16
	lda.w #.framehook
	jsl.l SetFrameHook
	jsl.l ScreenOn
	lda.w #$7000
	sta.b SfxVelocity
	ldx.w #$003C
.loop:
	jsl.l WaitFrame
	dex
	bpl .loop
	ldx.w #.framehook>>16
	lda.w #.framehook
	jsl.l SetFrameHook
.loop2:
	jsl.l RandomWord
	jsr.w .4
	bne .t1
	lda.b DMAQueueTail
	cmp.b DMAQueueHead
	beq .loop2
	bra .loop2

.t1:
	jsl.l forceblack
	rtl
.1:
	db $07,$C0,$11,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
.2:
	sep #$20
	stz.w CGADD
	lda.b #$FF
	sta.w CGDATA
	sta.w CGDATA
	rep #$20
	lda.w #EALogoEPalette
	sta.b p0
	lda.w #EALogoEPalette>>16
	sta.b p0+2
	ldy.w #$0030
	ldx.w #$0010
	jsl.l DMAToCGRAM
	ldy.w #$00B0
	ldx.w #$0010
	jsl.l DMAToCGRAM
	lda.w #EALogoAPalette
	sta.b p0
	lda.w #EALogoAPalette>>16
	sta.b p0+2
	ldy.w #$0040
	ldx.w #$0010
	jsl.l DMAToCGRAM
	ldy.w #$00C0
	ldx.w #$0010
	jsl.l DMAToCGRAM
	lda.w #$FFFF
	ldx.w #$000F
	ldy.w #$0020
	jsl.l .31
	lda.w #$FFFF
	ldx.w #$000F
	ldy.w #$0010
	jsl.l .31
	ldx.w #$0000
	lda.w #$0000
.loopx:
	sta.l introbuf,x
	inx
	inx
	cpx.w #$4000
	bcc .loopx
	lda.w #EALogoTiles
	sta.b p0
	lda.w #$0094
	sta.b p0+2
	lda.w #$8010
	sta.b p1
	lda.w #$007F
	sta.b p1+2
	jsl.l Decompress
	lda.w #EALogoMap
	sta.b p0
	lda.w #EALogoMap>>16
	sta.b p0+2
	lda.w #$4000
	sta.b p1
	lda.w #$007F
	sta.b p1+2
	jsl.l Decompress
	stz.w VMADDL
	sep #$20
	lda.b #$80
	sta.w VMAIN
	ldy.w #$4000
	ldx.w #$0000
.loop2x:
	lda.l introbuf+6,x
	sta.w VMDATAL
	lda.l introchars,x
	sta.w VMDATAH
	inx
	dey
	bne .loop2x
	rep #$20
	ldx.w #$1C00
	ldy.w #$0000
	sep #$20
.loop3:
	lda.l introbuf,x
	phx
	tyx
	sta.l introbuf+$40,x
	plx
	iny
	lda.l introchars,x
	phx
	tyx
	sta.l introbuf+$40,x
	plx
	inx
	iny
	cpy.w #$0A00
	bmi .loop3
	rep #$20
	lda.w #EALogoSprites
	sta.b p0
	lda.w #EALogoSprites>>16
	sta.b p0+2
	lda.w #$4A40
	sta.b p1
	lda.w #$007F
	sta.b p1+2
	jsl.l Decompress
	rts
.3:
	lda.w #$0180
	sta.b introBG1H
	sta.w BG1HScroll
	lda.w #$0190
	sta.b introBG1V
	sta.w BG1VScroll
	lda.w #$0010
	tsb.b introHookFlags
	lda.w #$0003
	sta.b d4+2
	stz.b d5+2
	lda.b vcount
	tax
	clc
	adc.w #$02D0
	sta.b d6
	txa
	clc
	adc.w #$00F0
	sta.b d7
	jsr.w .22
	rts
.4:
	lda.b d4+2
	sta.b d4
	lda.b d4
	cmp.w #$000D
	beq .1x
	lda.w JoyPad
	beq .1x
.1x:
	lda.b introHookFlags
	beq .t1x
	jmp.w .20

.t1x:
	lda.b d4
	asl a
	tax
	jmp (.5,x)
.5:									; jump table for jmp (.5,x)
	dw .6,.7,.8,.9,.10,.11,.12
	dw .13,.14,.15,.16,.17,.18,.19
.6:
	ldx.b d5+2
	bne .t1xx
	lda.b introM7A
	clc
	adc.w #$000C
	sta.b introM7A
	sta.b introM7D
	cmp.w #$0100
	bpl .t1xx
	lda.w #$0040
	tsb.b introHookFlags
	bra .1xx

.t1xx:
	jsr.w .23
	lda.w #$0040
	tsb.b introHookFlags
	lda.b d5
	sta.b d4+2
.1xx:
	jmp.w .20
.7:
	ldx.b d5+2
	bne .t1xxx
	jsr.w .30
	bne .t1xxx
	jsr.w .30
	bne .t1xxx
	jsr.w .30
	bne .t1xxx
	lda.w #$0008
	tsb.b introHookFlags
	bra .1xxx

.t1xxx:
	lda.w #$4000
	sta.b p1
	lda.w #$007F
	sta.b p1+2
	jsr.w .32
	lda.w #$0008
	tsb.b introHookFlags
	lda.b d5
	sta.b d4+2
.1xxx:
	jmp.w .20
.8:
	ldx.b d5+2
	bne .1xxxx
	lda.b vcount
	cmp.b d6+2
	bmi .2x
.1xxxx:
	lda.b d5
	sta.b d4+2
.2x:
	jmp.w .20
.9:
	lda.b d5+2
	bne .t1xxxx
	lda.w #$0000
	jsl.l PlaySound
	jsr.w .24
	bra .2xx

.t1xxxx:
	jsr.w .23
.2xx:
	lda.w #EALogoEMap
	sta.b p0
	lda.w #EALogoEMap>>16
	sta.b p0+2
	jsl.l .26
	lda.w #$00C0
	tsb.b introHookFlags
	lda.w #$0004
	ldx.b d5+2
	bne .1xxxxx
	sta.b d5
	lda.w #$0000
.1xxxxx:
	sta.b d4+2
	jmp.w .20
.10:
	jsl.l SpriteFrameStart
	lda.w #$4A40
	sta.b p1
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b r0
	lda.w #$0000
	ldx.w #$0038
	ldy.w #$002F
	jsl.l DrawSprite
	jsl.l SpriteFrameEnd
	lda.w #$0009
	sta.b d4+2
	jmp.w .20
.11:
	lda.b d5+2
	bne .t1xxxxx
	jsr.w .24
	bra .2xxx

.t1xxxxx:
	jsr.w .23
.2xxx:
	lda.w #EALogoAMap
	sta.b p0
	lda.w #EALogoAMap>>16
	sta.b p0+2
	jsl.l .26
	lda.w #$00C0
	tsb.b introHookFlags
	lda.w #$0006
	ldx.b d5+2
	bne .1xxxxxx
	sta.b d5
	lda.w #$0000
.1xxxxxx:
	sta.b d4+2
	jmp.w .20
.12:
	jsl.l SpriteFrameStart
	lda.w #$4A40
	sta.b p1
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b r0
	lda.w #$0000
	ldx.w #$0038
	ldy.w #$002F
	jsl.l DrawSprite
	lda.w #$0001
	sta.b r0
	lda.w #$0000
	ldx.w #$0038
	ldy.w #$002F
	jsl.l DrawSprite
	jsl.l SpriteFrameEnd
	lda.w #$000A
	sta.b d4+2
	jmp.w .20
.13:
	lda.b d5+2
	bne .t1xxxxxx
	jsr.w .24
	bra .2xxxx

.t1xxxxxx:
	jsr.w .23
.2xxxx:
	jsl.l .25
	lda.w #EALogoSportsPalette
	sta.b tmp2
	lda.w #$009A
	sta.b tmp3
	lda.w #$0020
	sta.b tmp0
	lda.w #$0010
	sta.b tmp1
	lda.w #$00C8
	tsb.b introHookFlags
	lda.w #$000B
	ldx.b d5+2
	bne .1xxxxxxx
	sta.b d5
	lda.w #$0000
.1xxxxxxx:
	sta.b d4+2
	jmp.w .20
.14:
	lda.w #EALogoTextPalette
	sta.b tmp2
	lda.w #$009A
	sta.b tmp3
	lda.w #$0010
	sta.b tmp0
	lda.w #$0010
	sta.b tmp1
	lda.w #$0008
	tsb.b introHookFlags
	lda.w #$000D
	sta.b d4+2
	jmp.w .20
.15:
	lda.b d5+2
	beq .t1xxxxxxx
.1xxxxxxxx:
	lda.w #$0005
	sta.b d4+2
	jmp.w .20

.t1xxxxxxx:
	lda.w #EALogoEPalette
	sta.b p0
	lda.w #EALogoEPalette>>16
	sta.b p0+2
	lda.w #$0030
	sta.b tmp0
	jsr.w .29
	lda.w #$0005
	sta.b d5
	lda.w #$0001
	sta.b d4+2
	jmp.w .20
.16:
	lda.b d5+2
	beq .t1xxxxxxxx
.1xxxxxxxxx:
	lda.w #$0007
	sta.b d4+2
	jmp.w .20

.t1xxxxxxxx:
	lda.w #EALogoAPalette
	sta.b p0
	lda.w #EALogoAPalette>>16
	sta.b p0+2
	lda.w #$0040
	sta.b tmp0
	jsr.w .29
	lda.w #$0007
	sta.b d5
	lda.w #$0001
	sta.b d4+2
	jmp.w .20
.17:
	lda.w #$0008
	sta.b d4+2
	jmp.w .20

.t1xxxxxxxxx:
	lda.w #EALogoSportsPalette
	sta.b p0
	lda.w #EALogoSportsPalette>>16
	sta.b p0+2
	lda.w #$0020
	sta.b tmp0
	jsr.w .29
	lda.w #$000C
	sta.b d5
	lda.w #$0001
	sta.b d4+2
	jmp.w .20
.18:
	lda.b vcount
	clc
	adc.w #$001E
	sta.b d6+2
	lda.w #$0002
	sta.b d4+2
	lda.w #$0008
	sta.b d5
	jmp.w .20
.19:
	lda.w brightness
	cmp.w #$000F
	bne .20
	lda.b vcount
	cmp.b d7
	bmi .20
	lda.w JoyPad
	bne .t1xxxxxxxxxx
	lda.b vcount
	cmp.b d6
	bmi .20
	bra .t1xxxxxxxxxx

.t1xxxxxxxxxx:
	lda.w #$0001
	bra .21
.20:
	lda.w #$0000
.21:
	rts
.22:
	sep #$20
	lda.b #$00
	sta.w M7X
	lda.b #$02
	sta.w M7X
	lda.b #$00
	sta.w M7Y
	lda.b #$02
	sta.w M7Y
	stz.w M7A
	lda.b #$01
	sta.w M7A
	stz.w M7B
	stz.w M7B
	stz.w M7C
	stz.w M7C
	stz.w M7D
	lda.b #$01
	sta.w M7D
	rep #$20
	jsr.w .23
	rts
.23:
	lda.w #$0100
	sta.b introM7A
	sta.b introM7D
	rts
.24:
	lda.w #$0001
	sta.b introM7A
	sta.b introM7D
	rts
.25:
	stz.b d1
	jsr.w .27
	rtl
.26:
	lda.w #$0001
	sta.b d1
	jsr.w .27
	rtl
.27:
	ldy.w #$0006
	stz.b d0+2
.loopxx:
	lda.b d0+2
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$0037
	asl a
	tax
	stz.b d0
	sep #$20
.loop2xx:
	lda.b d1
	beq .1xxxxxxxxxx
	lda.b [p0],y
.1xxxxxxxxxx:
	sta.l introbuf+$40,x
	iny
	inx
	inx
	inc.b d0
	lda.b d0
	cmp.b #$12
	bmi .loop2xx
	rep #$20
	inc.b d0+2
	lda.b d0+2
	cmp.w #$000A
	bmi .loopxx
	rts

.t1xxxxxxxxxxx:
	rep #$30
.28:
	lda.b p0
	pha
	lda.b p0+2
	pha
	lda.w #$4040
	sta.b p0
	lda.w #$007F
	sta.b p0+2
	ldx.w #$1C00
	lda.w #$0A00
	jsl.l .t1xxxxxxxxxxxx
	pla
	sta.b p0+2
	pla
	sta.b p0
	rtl

.t1xxxxxxxxxxxx:
	php
	sta.w DAS0L
	lda.b p0
	sta.w A1T0L
	stx.w VMADDL
	sep #$20
	lda.b p0+2
	sta.w A1B0
	lda.b #$01
	sta.w DMAP0
	lda.b #$18
	sta.w BBAD0
	lda.b #$01
	sta.w MDMAEN
	rep #$30
	plp
	rtl
.29:
	lda.w #$4000
	sta.b p1
	lda.w #$007F
	sta.b p1+2
	jsr.w .32
	lda.w #$0010
	sta.b tmp1
	lda.w #$4000
	sta.b tmp2
	lda.w #$007F
	sta.b tmp3
	rts
.30:
	ldx.w #$0000
	ldy.w #$0001
.loopxxx:
	lda.l introbuf,x
	pha
	and.w #$001F
	cmp.w #$001F
	beq .1xxxxxxxxxxx
	clc
	adc.w #$0001
	and.w #$001F
.1xxxxxxxxxxx:
	sta.l introbuf,x
	pla
	pha
	and.w #$03E0
	cmp.w #$03E0
	beq .2xxxxx
	clc
	adc.w #$0020
	and.w #$03E0
.2xxxxx:
	ora.l introbuf,x
	sta.l introbuf,x
	pla
	and.w #$7C00
	cmp.w #$7C00
	beq .3x
	clc
	adc.w #$0400
	and.w #$7C00
.3x:
	ora.l introbuf,x
	sta.l introbuf,x
	and.w #$7FFF
	cmp.w #$7FFF
	beq .4x
	ldy.w #$0000
.4x:
	inx
	inx
	cpx.w #$0020
	bmi .loopxxx
	tya
	rts
.31:
	sep #$30
	sty.w CGADD
.loopxxxx:
	sta.w CGDATA
	xba
	sta.w CGDATA
	xba
	dex
	bpl .loopxxxx
	rep #$30
	rtl
.32:
	ldy.w #$0000
.loopxxxxx:
	lda.b [p0],y
	sta.b [p1],y
	iny
	iny
	cpy.w #$0020
	bmi .loopxxxxx
	rts
.framehook:							; the frame hook of this sequence
	rep #$30
	lda.b introHookFlags
	bit.w #$0080
	beq .t1xxxxxxxxxxxxx
	jsl.l .28
	lda.w #$0080
	trb.b introHookFlags
	jmp.w .3xx

.t1xxxxxxxxxxxxx:
	lda.b introHookFlags
	bit.w #$0008
	beq .3xx
	lda.b p0
	pha
	lda.b p0+2
	pha
	lda.b tmp2
	sta.b p0
	lda.b tmp3
	sta.b p0+2
	ldy.b tmp0
	ldx.b tmp1
	jsl.l DMAToCGRAM
	lda.b introHookFlags
	bit.w #$0200
	beq .2xxxxxx
.1xxxxxxxxxxxx:
	lda.b introPal2Src
	sta.b p0
	lda.b introPal2Src+2
	sta.b p0+2
	ldy.b tmp4
	ldx.b tmp5
	jsl.l DMAToCGRAM
.2xxxxxx:
	pla
	sta.b p0+2
	pla
	sta.b p0
	lda.w #$0208
	trb.b introHookFlags
.3xx:
	lda.b introHookFlags
	bit.w #$0010
	beq .1xxxxxxxxxxxxx
	sep #$20
	lda.b introBG1H
	sta.w BG1HOFS
	lda.b introBG1H+1
	sta.w BG1HOFS
	lda.b introBG1V
	sta.w BG1VOFS
	lda.b introBG1V+1
	sta.w BG1VOFS
	rep #$20
	lda.w #$0010
	trb.b introHookFlags
.1xxxxxxxxxxxxx:
	lda.b introHookFlags
	bit.w #$0040
	beq .rtl
	sep #$20
	lda.b introM7A
	sta.w M7A
	lda.b introM7A+1
	sta.w M7A
	lda.b introM7D
	sta.w M7D
	lda.b introM7D+1
	sta.w M7D
	rep #$20
	lda.w #$0040
	trb.b introHookFlags
.rtl:
	rtl
.33:
	sep #$20
	lda.b #$03
	sta.w OBSEL
	lda.b #$80
	sta.w VMAIN
	ldy.w #$0000
	lda.b [p0],y
	sta.w BGMODE
	iny
	lda.b [p0],y
	sta.w M7SEL
	iny
	lda.b [p0],y
	sta.w TM
	iny
	lda.b [p0],y
	sta.w TS
	iny
	iny
	lda.b [p0],y
	iny
	ora.b [p0],y
	sta.w BG1SC
	iny
	iny
	lda.b [p0],y
	iny
	ora.b [p0],y
	sta.w BG2SC
	iny
	iny
	lda.b [p0],y
	iny
	ora.b [p0],y
	sta.w BG3SC
	iny
	iny
	lda.b [p0],y
	iny
	ora.b [p0],y
	sta.w BG4SC
	iny
	iny
	lda.b [p0],y
	lsr a
	lsr a
	lsr a
	lsr a
	iny
	iny
	ora.b [p0],y
	sta.w BG12NBA
	iny
	iny
	lda.b [p0],y
	lsr a
	lsr a
	lsr a
	lsr a
	iny
	iny
	ora.b [p0],y
	sta.w BG34NBA
	rep #$20
	rtl
	db $00
	padbyte $FF
	pad $A08000
