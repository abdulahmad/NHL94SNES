; Crowd meter screen
CrowdMeterScreen:					; called from PauseCrowdLevel
	lda.w VisTeam					;visitors' logo
	sta.l setupvis
	lda.w HomeTeam					;home logo
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
	ldy.w #$0050					;colour $50
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #CrowdMeterScreenPos>>16
	sta.b a1+2
	lda.w #CrowdMeterScreenPos
	sta.b a1
	jsl.l print						; print CrowdMeterScreenPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0800					;palette 2
	sta.w printa
	lda.w #$0014					;20 wide
	sta.b d0
	lda.w #$0005					;5 high
	sta.b d1
	jsl.l FramerNineTile			;draw the frame
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
	stx.b r0						;size
	jsl.l LinearToPlanar			;to planar
	lda.b p1
	sta.b p0
	tax								;X = bytes
	lda.l nextfreechar				;free characters
	asl a
	asl a
	asl a
	asl a							;x16
	clc
	adc.w #$1000					;plus the BG char base
	tay								;VRAM address
	jsl.l DMAToVRAM					;send the meter tiles
	lda.w #CrowdMeterPalette>>16
	sta.b p0+2
	lda.w #CrowdMeterPalette
	sta.b p0
	ldy.w #$0070					;colour $70
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #$6F7B					;light grey
	sta.l colourbuf+$C2				;text colour
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	stz.w curitem					;start on the current level
	jsl.l ScreenOn
.1:									; call SpriteFrameStart, a1 = CrowdMeter, call PrintLetterSprites, ...
	jsl.l SpriteFrameStart
	ldx.w #$0048					;x 72
	ldy.w #$0018					;y 24
	lda.w #CrowdMeter>>16
	sta.b a1+2
	lda.w #CrowdMeter
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites CrowdMeter
	jsl.l DrawMatchupPictures		;pictures or logos
	jsl.l .6						;readings and the meter
	jsl.l SpriteFrameEnd
.2:									; loop: call SendTextMap, call WaitFrame, call ReadPads, ...
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l getpzjoy					; ReadjoyA for the controller that owns the pause menu
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
	lda.b d1						;new presses
	bit.w #$1000					;start?
	bne .t1							;yes: leave
	bit.w #$0800					;up?
	bne .t2							;yes
	bit.w #$0400					;down?
	bne .t3							;yes
	bra .2							;no: wait

.t1:								; d1 bit $1000 set: return
	rtl

.t2:								; if a counted below 0 go to .2, ...
	lda.w curitem					;item
	dec a							;up one
	bmi .2							;at the top: stay
	sta.w curitem					;new item
	bra .1							;redraw

.t3:								; if carry set go to .2, ...
	lda.w curitem					;item
	inc a							;down one
	cmp.w #$0003					;past the 3 items?
	bcs .2							;yes: stay
	sta.w curitem					;new item
	bra .1							;redraw
.6:									; subroutine: if curitem = 0 go to .t1x
	lda.w curitem					;item
	beq .t1x						;current highlighted?
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
	sta.w printx					;column 20
	lda.w #$0011
	sta.w printy					;row 17
	lda.w CurCrowdMeter
	sta.b d0						;current level
	lda.w #$0004
	sta.b d1						;4 digits
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l print						;print it
	lda.w curitem					;item
	cmp.w #$0001					;peak?
	beq .t1xx						;yes: highlight
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
	sta.w printx					;column 20
	lda.w #$0013
	sta.w printy					;row 19
	lda.w CrowdPeak
	sta.b d0						;peak level
	lda.w #$0004
	sta.b d1						;4 digits
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l print						;print it
	lda.w curitem					;item
	cmp.w #$0002					;average?
	beq .t1xxx						;yes: highlight
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
	sta.w printx					;column 20
	lda.w #$0015
	sta.w printy					;row 21
	lda.w CrowdAvg
	sta.b d0						;average level
	lda.w #$0004
	sta.b d1						;4 digits
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l print						;print it
	lda.w curitem					;item
	beq .t2x						;current
.1xx:								; if zero go to .t1xxxx, ...
	cmp.w #$0001					;peak?
	beq .t1xxxx						;yes
	lda.w CrowdAvg					;average
	bra .5

.t1xxxx:							; go to .5
	lda.w CrowdPeak					;peak
	bra .5

.t2x:								; curitem = 0: falls through
	lda.w CurCrowdMeter				;current
.5:									; call .8, return
	jsl.l .8						;draw the meter at A
	rtl
.7:									; subroutine: r7+2 = A, r5 = X, call Mul16U, ...
	sta.b r7+2						;tile offset
	stx.b r5						;column
	tya								;row
	asl a							;x2
	ldx.b r7						;map width
	jsl.l Mul16U					;row offset
	lda.b r5						;column
	asl a							;x2
	clc
	adc.b r2						;plus the row offset
	adc.b p1						;plus the map
	sta.b p1						;destination
	ldy.w #$0000
	lda.b [p0],y					;map width
	sta.b r4						;r4
	iny
	iny
	lda.b [p0],y					;map rows
	sta.b r4+2						;r4+2
	lda.b p0
	clc
	adc.w #$0006					;skip the header
	sta.b p0						;map data
.loop:								; loop: falls through
	ldx.w crowdmeterlit				;lit columns
	ldy.w #$0000					;from the left
.loop2:								; loop: [p1],y = [p0],y + r7+2, Y + 1, Y + 1, ...
	lda.b [p0],y					;map word
	clc
	adc.b r7+2						;plus the tile offset
	sta.b [p1],y					;into the text map
	iny
	iny
	dex
	bne .loop2						;all lit columns
	lda.b r7
	asl a							;text map width
	adc.b p1						;x2
	sta.b p1						;next row
	lda.b r4
	asl a							;source width
	adc.b p0						;x2
	sta.b p0						;next source row
	dec.b r4+2						;one row
	bne .loop						;all rows
	rtl
.8:									; subroutine: sbc #$0032, if plus go to .1xxx, ...
	sec
	sbc.w #$0032					;minus 50 dB
	bpl .1xxx						;above it?
	lda.w #$0000					;below: none lit
.1xxx:								; lsr a, lsr a, r1 = A, ...
	lsr a
	lsr a							;/4
	sta.b r1						;lit segments
	cmp.w #$0013					;19 or more?
	bmi .t1xxxxx					;no: normal meter
.2xx:								;off the scale:
	lda.w #$0000					;no segments lit
	sta.b r1
	lda.w #CrowdMeterBrokenMap>>16	;the broken meter
	sta.b p0+2
	lda.w #CrowdMeterBrokenMap
	sta.b p0
	bra .3x

.t1xxxxx:							; p0 = CrowdMeterMap
	lda.w #CrowdMeterMap>>16		;normal meter
	sta.b p0+2
	lda.w #CrowdMeterMap
	sta.b p0
.3x:								; p1+2 = $007F, p1 = $0000, call Decompress, ...
	lda.b r1						;keep the segments
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
	sta.b r7						;32 wide
	lda.w #$001C
	sta.b r7+2						;28 high
	ldx.w #$0007					;column 7
	ldy.w #$000B					;row 11
	lda.l charofs					;text set
	clc
	adc.l nextfreechar				;plus the meter tiles
	clc
	adc.w #$1C00					;palette 7
	jsl.l PasteMap					;paste the meter
	jsl.l WaitFrame
	pla
	sta.b r1						;segments
	sta.w crowdmeterlit				;lit columns
	beq .rtl						;none: done
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
	sta.b r7						;32 wide
	lda.w #$001C
	sta.b r7+2						;28 high
	ldx.w #$0007					;column 7
	ldy.w #$000B					;row 11
	lda.l charofs					;text set
	clc
	adc.l nextfreechar				;plus the meter tiles
	clc
	adc.w #$1C00					;palette 7
	jsl.l .7						;paste the lit part
.rtl:								; return
	rtl
.9:									;(unreferenced) table
	db $EF,$E7,$E3,$E0
.10:								;(unreferenced) records: a byte and a pointer into .9, $00 ends them
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
