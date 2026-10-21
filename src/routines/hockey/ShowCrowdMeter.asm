; Crowd meter screen
ShowCrowdMeter:						; called from PauseCrowdLevel
	lda.w VisTeam
	sta.l setupvis
	lda.w HomeTeam
	sta.l setuphome
	jsl.l SetupScreen				; common setup of the stats screens
	lda.w #CrowdMeterFramePalette>>16
	sta.b p0+2
	lda.w #CrowdMeterFramePalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack CrowdMeterFramePalette
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0050
	ldx.w #$0010
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowCrowdMeterPos>>16
	sta.b a1+2
	lda.w #ShowCrowdMeterPos
	sta.b a1
	jsl.l print						; print ShowCrowdMeterPos
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
	jsl.l FramerNineTile			; framer with a nine-tile box from tile
	lda.w #CrowdMeterTiles>>16
	sta.b p0+2
	lda.w #CrowdMeterTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack CrowdMeterTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
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
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #CrowdMeterPalette>>16
	sta.b p0+2
	lda.w #CrowdMeterPalette
	sta.b p0
	ldy.w #$0070
	ldx.w #$0010
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #$6F7B
	sta.l colourbuf+$C2
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	stz.w curitem
	jsl.l ScreenOn
.1:									; call SpriteFrameStart, a1 = CrowdMeter, call PrintLetterSprites, ...
	jsl.l SpriteFrameStart
	ldx.w #$0048
	ldy.w #$0018
	lda.w #CrowdMeter>>16
	sta.b a1+2
	lda.w #CrowdMeter
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites CrowdMeter
	jsl.l DrawMatchupPictures
	jsl.l .6
	jsl.l SpriteFrameEnd
.2:									; loop: call SendTextMap, call WaitFrame, call ReadPads, ...
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l ReadPausePad				; ReadjoyA for the controller that owns the pause menu
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
	lda.b d1
	bit.w #$1000
	bne .t1
	bit.w #$0800
	bne .t2
	bit.w #$0400
	bne .t3
	bra .2

.t1:								; d1 bit $1000 set: return
	rtl

.t2:								; if a counted below 0 go to .2, ...
	lda.w curitem
	dec a
	bmi .2
	sta.w curitem
	bra .1

.t3:								; if carry set go to .2, ...
	lda.w curitem
	inc a
	cmp.w #$0003
	bcs .2
	sta.w curitem
	bra .1
.6:									; subroutine: if curitem = 0 go to .t1x
	lda.w curitem
	beq .t1x
.1x:								; a1 = CurrentTxt, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #CurrentTxt>>16
	sta.b a1+2
	lda.w #CurrentTxt
	sta.b a1
	jsl.l print						; print CurrentTxt
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
	jsl.l print						; print DbTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .2x

.t1x:								; curitem = 0: a1 = CurrentTxt2, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #CurrentTxt2>>16
	sta.b a1+2
	lda.w #CurrentTxt2
	sta.b a1
	jsl.l print						; print CurrentTxt2
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
	jsl.l print						; print DbTxt2
	pla
	sta.b a1
	pla
	sta.b a1+2
.2x:								; printx = $0014, printy = $0011, d0 = CurCrowdMeter, ...
	lda.w #$0014
	sta.w printx
	lda.w #$0011
	sta.w printy
	lda.w CurCrowdMeter
	sta.b d0
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
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
	jsl.l print						; print PeakTxt
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
	jsl.l print						; print DbTxt3
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .3

.t1xx:								; curitem = $0001: a1 = PeakTxt2, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PeakTxt2>>16
	sta.b a1+2
	lda.w #PeakTxt2
	sta.b a1
	jsl.l print						; print PeakTxt2
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
	jsl.l print						; print DbTxt4
	pla
	sta.b a1
	pla
	sta.b a1+2
.3:									; printx = $0014, printy = $0013, d0 = CrowdPeak, ...
	lda.w #$0014
	sta.w printx
	lda.w #$0013
	sta.w printy
	lda.w CrowdPeak
	sta.b d0
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
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
	jsl.l print						; print AverageTxt
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
	jsl.l print						; print DbTxt5
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .4

.t1xxx:								; curitem = $0002: a1 = AverageTxt2, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #AverageTxt2>>16
	sta.b a1+2
	lda.w #AverageTxt2
	sta.b a1
	jsl.l print						; print AverageTxt2
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
	jsl.l print						; print DbTxt6
	pla
	sta.b a1
	pla
	sta.b a1+2
.4:									; printx = $0014, printy = $0015, d0 = CrowdAvg, ...
	lda.w #$0014
	sta.w printx
	lda.w #$0015
	sta.w printy
	lda.w CrowdAvg
	sta.b d0
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l print
	lda.w curitem
	beq .t2x
.1xx:								; if zero go to .t1xxxx, ...
	cmp.w #$0001
	beq .t1xxxx
	lda.w CrowdAvg
	bra .5

.t1xxxx:							; go to .5
	lda.w CrowdPeak
	bra .5

.t2x:								; curitem = 0: falls through
	lda.w CurCrowdMeter
.5:									; call .8, return
	jsl.l .8
	rtl
.7:									; subroutine: r7+2 = A, r5 = X, call Mul16U, ...
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
.loop:								; loop: falls through
	ldx.w crowdmeterlit
	ldy.w #$0000
.loop2:								; loop: [p1],y = [p0],y + r7+2, Y + 1, Y + 1, ...
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
.8:									; subroutine: sbc #$0032, if plus go to .1xxx, ...
	sec
	sbc.w #$0032
	bpl .1xxx
	lda.w #$0000
.1xxx:								; lsr a, lsr a, r1 = A, ...
	lsr a
	lsr a
	sta.b r1
	cmp.w #$0013
	bmi .t1xxxxx
.2xx:								; r1 = $0000, p0 = CrowdMeterBrokenMap, go to .3x
	lda.w #$0000
	sta.b r1
	lda.w #CrowdMeterBrokenMap>>16
	sta.b p0+2
	lda.w #CrowdMeterBrokenMap
	sta.b p0
	bra .3x

.t1xxxxx:							; p0 = CrowdMeterMap
	lda.w #CrowdMeterMap>>16
	sta.b p0+2
	lda.w #CrowdMeterMap
	sta.b p0
.3x:								; p1+2 = $007F, p1 = $0000, call Decompress, ...
	lda.b r1
	pha
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
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
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
	jsl.l WaitFrame
	pla
	sta.b r1
	sta.w crowdmeterlit
	beq .rtl
.1xxxx:								; p0 = CrowdMeterLitMap, p1+2 = $007F, p1 = $0000, ...
	lda.w #CrowdMeterLitMap>>16
	sta.b p0+2
	lda.w #CrowdMeterLitMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack CrowdMeterLitMap
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
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
.rtl:								; return
	rtl
.9:									; loop: db $EF,$E7,$E3,$E0
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
.11:								; if HotColdRaised != 0 go to .rtlx, ...
	lda.w HotColdRaised
	bne .rtlx
	ldy.w #$0033
	ldx.w #$0000
.loopx:								; loop: HotColdTable+1,x = HotColdTable+1,x + 1 + 1, HotColdTable,x = H...
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
.rtlx:								; return
	rtl
