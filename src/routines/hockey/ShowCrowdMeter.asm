; Crowd meter screen
ShowCrowdMeter:
	lda.w VisTeam
	sta.l setupvis
	lda.w HomeTeam
	sta.l setuphome
	jsl.l SetupScreen
	lda.w #CrowdMeterFramePalette>>16
	sta.b p0+2
	lda.w #CrowdMeterFramePalette
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	ldy.w #$0050
	ldx.w #$0010
	jsl.l SetColours
	jsl.l SendColours
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowCrowdMeterPos>>16
	sta.b a1+2
	lda.w #ShowCrowdMeterPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0800
	sta.w printa
	lda.w #$0014
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l FramerNineTile
	lda.w #CrowdMeterTiles>>16
	sta.b p0+2
	lda.w #CrowdMeterTiles
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	stx.b p1
	stx.b r0
	jsl.l LinearToPlanar
	lda.b p1
	sta.b p0
	tax
	lda.l nextfreechar
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$1000
	tay
	jsl.l DMAToVRAM
	lda.w #CrowdMeterPalette>>16
	sta.b p0+2
	lda.w #CrowdMeterPalette
	sta.b p0
	ldy.w #$0070
	ldx.w #$0010
	jsl.l SetColours
	lda.w #$6F7B
	sta.l colourbuf+$C2
	jsl.l SendColours
	stz.w curitem
	jsl.l ScreenOn
.1:
	jsl.l SpriteFrameStart
	ldx.w #$0048
	ldy.w #$0018
	lda.w #CrowdMeter>>16
	sta.b a1+2
	lda.w #CrowdMeter
	sta.b a1
	jsl.l PrintLetterSprites
	jsl.l DrawMatchupPictures
	jsl.l .6
	jsl.l SpriteFrameEnd
.2:
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads
	jsl.l ReadPausePad
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$1000
	bne .t1
	bit.w #$0800
	bne .t2
	bit.w #$0400
	bne .t3
	bra .2

.t1:
	rtl

.t2:
	lda.w curitem
	dec a
	bmi .2
	sta.w curitem
	bra .1

.t3:
	lda.w curitem
	inc a
	cmp.w #$0003
	bcs .2
	sta.w curitem
	bra .1
.6:
	lda.w curitem
	beq .t1x
.1x:
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #CurrentTxt>>16
	sta.b a1+2
	lda.w #CurrentTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DbTxt>>16
	sta.b a1+2
	lda.w #DbTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .2x

.t1x:
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #CurrentTxt2>>16
	sta.b a1+2
	lda.w #CurrentTxt2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DbTxt2>>16
	sta.b a1+2
	lda.w #DbTxt2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
.2x:
	lda.w #$0014
	sta.w printx
	lda.w #$0011
	sta.w printy
	lda.w CurCrowdMeter
	sta.b d0
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l print
	lda.w curitem
	cmp.w #$0001
	beq .t1xx
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PeakTxt>>16
	sta.b a1+2
	lda.w #PeakTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DbTxt3>>16
	sta.b a1+2
	lda.w #DbTxt3
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .3

.t1xx:
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PeakTxt2>>16
	sta.b a1+2
	lda.w #PeakTxt2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DbTxt4>>16
	sta.b a1+2
	lda.w #DbTxt4
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
.3:
	lda.w #$0014
	sta.w printx
	lda.w #$0013
	sta.w printy
	lda.w CrowdPeak
	sta.b d0
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l print
	lda.w curitem
	cmp.w #$0002
	beq .t1xxx
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #AverageTxt>>16
	sta.b a1+2
	lda.w #AverageTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DbTxt5>>16
	sta.b a1+2
	lda.w #DbTxt5
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .4

.t1xxx:
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #AverageTxt2>>16
	sta.b a1+2
	lda.w #AverageTxt2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DbTxt6>>16
	sta.b a1+2
	lda.w #DbTxt6
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
.4:
	lda.w #$0014
	sta.w printx
	lda.w #$0015
	sta.w printy
	lda.w CrowdAvg
	sta.b d0
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l print
	lda.w curitem
	beq .t2x
.1xx:
	cmp.w #$0001
	beq .t1xxxx
	lda.w CrowdAvg
	bra .5

.t1xxxx:
	lda.w CrowdPeak
	bra .5

.t2x:
	lda.w CurCrowdMeter
.5:
	jsl.l .8
	rtl
.7:
	sta.b r7+2
	stx.b r5
	tya
	asl a
	ldx.b r7
	jsl.l Mul16U
	lda.b r5
	asl a
	clc
	adc.b r2
	adc.b p1
	sta.b p1
	ldy.w #$0000
	lda.b [p0],y
	sta.b r4
	iny
	iny
	lda.b [p0],y
	sta.b r4+2
	lda.b p0
	clc
	adc.w #$0006
	sta.b p0
.loop:
	ldx.w crowdmeterlit
	ldy.w #$0000
.loop2:
	lda.b [p0],y
	clc
	adc.b r7+2
	sta.b [p1],y
	iny
	iny
	dex
	bne .loop2
	lda.b r7
	asl a
	adc.b p1
	sta.b p1
	lda.b r4
	asl a
	adc.b p0
	sta.b p0
	dec.b r4+2
	bne .loop
	rtl
.8:
	sec
	sbc.w #$0032
	bpl .1xxx
	lda.w #$0000
.1xxx:
	lsr a
	lsr a
	sta.b r1
	cmp.w #$0013
	bmi .t1xxxxx
.2xx:
	lda.w #$0000
	sta.b r1
	lda.w #CrowdMeterBrokenMap>>16
	sta.b p0+2
	lda.w #CrowdMeterBrokenMap
	sta.b p0
	bra .3x

.t1xxxxx:
	lda.w #CrowdMeterMap>>16
	sta.b p0+2
	lda.w #CrowdMeterMap
	sta.b p0
.3x:
	lda.b r1
	pha
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.w #$0020
	sta.b r7
	lda.w #$001C
	sta.b r7+2
	ldx.w #$0007
	ldy.w #$000B
	lda.l charofs
	clc
	adc.l nextfreechar
	clc
	adc.w #$1C00
	jsl.l PasteMap
	jsl.l WaitFrame
	pla
	sta.b r1
	sta.w crowdmeterlit
	beq .rtl
.1xxxx:
	lda.w #CrowdMeterLitMap>>16
	sta.b p0+2
	lda.w #CrowdMeterLitMap
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.w #$0020
	sta.b r7
	lda.w #$001C
	sta.b r7+2
	ldx.w #$0007
	ldy.w #$000B
	lda.l charofs
	clc
	adc.l nextfreechar
	clc
	adc.w #$1C00
	jsl.l .7
.rtl:
	rtl
.9:
	db $EF,$E7,$E3,$E0
.10:								; records of a byte and a pointer into .9; $00 ends them
	db $0C : dw .9+3
	db $06 : dw .9+2
	db $1C : dw .9+1
	db $08 : dw .9
	db $22 : dw .9+3
	db $18 : dw .9+1
	db $14 : dw .9+3
	db $00
.11:
	lda.w HotColdRaised
	bne .rtlx
	ldy.w #$0033
	ldx.w #$0000
.loopx:
	sep #$20
	lda.w HotColdTable+1,x
	inc a
	inc a
	sta.w HotColdTable+1,x
	lda.w HotColdTable,x
	inc a
	inc a
	sta.w HotColdTable,x
	lda.w HotColdTable+3,x
	inc a
	inc a
	sta.w HotColdTable+3,x
	lda.w HotColdTable+2,x
	inc a
	inc a
	sta.w HotColdTable+2,x
	rep #$20
	txa
	clc
	adc.w #$000C
	tax
	dey
	bpl .loopx
	inc.w HotColdRaised
.rtlx:
	rtl
