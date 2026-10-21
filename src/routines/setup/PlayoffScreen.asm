; The playoff tree screen
PlayoffScreen:						; called from GameOver, StartGame
	lda.w #$FFFF
	sta.l phototeams
	sta.l phototeams+2
	lda.w #$0000
	sta.l charofs
	sta.l charofs2
	lda.l OptPlayMode
	bne .t3
	jmp.w .3

.t3:								; OptPlayMode != 0: if not zero go to .t1, ...
	cmp.w #$0004
	bne .t1
	jmp.w .3

.t1:								; if playoffRoundIdx < $0002 go to .t2, ...
	lda.l playoffRoundIdx
	cmp.w #$0002
	bcc .t2
	lda.w SongPtr
	cmp.w #$ED31
	beq .t2
	jsl.l FadeOutSound
	jsl.l forceblack
.loop:								; loop: if MusicOn != 0 go to .loop, ...
	lda.w MusicOn
	bne .loop
	lda.w #PlayoffSong>>16
	sta.b p0+2
	lda.w #PlayoffSong
	sta.b p0
	jsl.l MusicStart
	jmp.w .2

.t2:								; call forceblack
	jsl.l forceblack
.2:									; BGMODE = $09, BG1SC = $01, BG2SC = $08, ...
	sep #$20
	lda.b #$09
	sta.w BGMODE
	lda.b #$01
	sta.w BG1SC
	lda.b #$08
	sta.w BG2SC
	lda.b #$39
	sta.w BG3SC
	lda.b #$31
	sta.w BG12NBA
	lda.b #$04
	sta.w BG34NBA
	lda.b #$03
	sta.w OBSEL
	lda.b #$07
	sta.w TM
	rep #$30
	lda.w #MenuBackTiles>>16
	sta.b p0+2
	lda.w #MenuBackTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$3000
	jsl.l DMAToVRAM
	lda.w #MenuBackMap>>16
	sta.b p0+2
	lda.w #MenuBackMap
	sta.b p0
	jsl.l Decompress
	lda.w #(unpackbuf+$246)>>16
	sta.b p0+2
	lda.w #unpackbuf+$246
	sta.b p0
	phx
	ldx.w #$0240
	ldy.w #$0800
	jsl.l DMAToVRAM
	pla
	sec
	sbc.w #$0240
	tax
	ldy.w #$0920
	jsl.l DMAToVRAM
	lda.w #MenuBackPalette>>16
	sta.b p0+2
	lda.w #MenuBackPalette
	sta.b p0
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0000
	ldx.w #$0010
	jsl.l DMAToCGRAM
	lda.w #PlayoffTiles>>16
	sta.b p0+2
	lda.w #PlayoffTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.l smallfontchars
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$1000
	jsl.l DMAToVRAM
	lda.w #PlayoffPalette>>16
	sta.b p0+2
	lda.w #PlayoffPalette
	sta.b p0
	lda.w #palbuffer>>16
	sta.b p1+2
	lda.w #palbuffer
	sta.b p1
	jsl.l Decompress
	lda.w #SmallFontTiles>>16
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	adc.l smallfontchars
	sta.l BigFontChars
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #unpackbuf
	sta.b a0
	lda.w #PixelRemap8F>>16
	sta.b a1+2
	lda.w #PixelRemap8F
	sta.b a1
	jsl.l RemapTiles
	lda.w #SmallFontTiles>>16
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l BigFontChars
	sta.l scorechars
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM
	lda.w #$031A
	sta.l palbuffer+(4*$20)+(1*2)
	sta.l palbuffer+(5*$20)+(1*2)
	sta.l palbuffer+(6*$20)+(1*2)
	sta.l palbuffer+(7*$20)+(1*2)
	lda.w #palbuffer>>16
	sta.b p1+2
	lda.w #palbuffer+$80
	sta.b p1
	ldx.w #$001B
.loopx:								; loop: p0+2 = TeamBlockPalettes+2,x, p0 = TeamBlockPalettes,x, [p1],y...
	phx
	txa
	asl a
	asl a
	tax
	lda.l TeamBlockPalettes+2,x
	sta.b p0+2
	lda.l TeamBlockPalettes,x
	sta.b p0
	ldy.w #$0008
	lda.b [p0],y
	pha
	lda.b 3,s
	asl a
	tax
	lda.l .8,x
	and.w #$00FF
	tay
	pla
	sta.b [p1],y
	lda.b 1,s
	asl a
	asl a
	asl a
	tax
	jsr.w .9
	ldy.w #$0012
	lda.b [p0],y
	pha
	lda.b 3,s
	asl a
	tax
	inx
	lda.l .8,x
	and.w #$00FF
	tay
	pla
	sta.b [p1],y
	lda.b 1,s
	asl a
	inc a
	asl a
	asl a
	tax
	jsr.w .9
	plx
	dex
	bpl .loopx
	lda.l scorechars
	clc
	adc.w #$0070
	sta.l cupchars
	lda.w #brackettiles>>16
	sta.b p0+2
	lda.w #brackettiles
	sta.b p0
	ldx.w #$0E00
	ldy.w #$FFFF
	jsl.l DMAToVRAM
	lda.w #StanleyCupPalette>>16
	sta.b p0+2
	lda.w #StanleyCupPalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #(palbuffer+(3*$20))>>16
	sta.b p1+2
	lda.w #palbuffer+(3*$20)		; palette 3
	sta.b p1
	ldx.w #$0020
	jsl.l MemCopy
	lda.w #StanleyCupTiles>>16
	sta.b p0+2
	lda.w #StanleyCupTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM
	lda.w #BigLetterTiles>>16
	sta.b p0+2
	lda.w #BigLetterTiles
	sta.b p0
	lda.w #bigtextbuf>>16
	sta.b p1+2
	lda.w #bigtextbuf
	sta.b p1
	jsl.l Decompress
	lda.w #bigtextbuf>>16
	sta.b p0+2
	lda.w #bigtextbuf
	sta.b p0
	lda.w #hlsavebuf>>16
	sta.b p1+2
	lda.w #hlsavebuf
	sta.b p1
	stx.b r0
	jsl.l LinearToPlanar
	lda.w #bigtextbuf>>16
	sta.b p1+2
	lda.w #bigtextbuf
	sta.b p1
	lda.w #$0000
	ldx.w #$8000
	jsl.l MemFill
	lda.w #screenmap>>16
	sta.b p1+2
	lda.w #screenmap+6
	sta.b p1
	lda.w #$0000
	ldx.w #$4002
	jsl.l MemFill
	lda.w #potree>>16
	sta.b a1+2
	lda.w #potree
	sta.b a1
	lda.w #.10>>16
	sta.b a0+2
	lda.w #.10
	sta.b a0
	lda.l playoffRoundIdx
	asl a
	tay
	lda.b [a0],y
	adc.b a0
	sta.b a0
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d4
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayoffScreenPos>>16
	sta.b a1+2
	lda.w #PlayoffScreenPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0001
	sta.l bigtextchar
.loop2:								; loop: increment a0, printx = [a0] & $00FF, printa = $3000, ...
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w printx
	lda.w #$3000
	sta.w printa
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w printy
	lda.b [a1]
	inc.b a1
	and.w #$00FF
	sta.b tmp4
	tay
	lda.l potreeteam
	tax
	tya
	eor.l potree,x
	and.w #$00FF
	bne .1
	lda.w #$3400
	sta.w printa
.1:									; p0 = long TeamPlaceNames,x, jmlvector = $005C, ...
	lda.b tmp4
	asl a
	tax
	lda.l TeamPlaceNames,x
	sta.b p0
	lda.w #TeamPlaceNames>>16
	sta.b p0+2
	lda.w printx
	pha
	lda.w #$005C
	sta.w jmlvector
	lda.w #BigLetterPlayoff
	sta.w jmlvector+1
	lda.w #BigLetterPlayoff>>16
	sta.w jmlvector+3
	jsl.l RenderBigText
	pla
	sta.w printx
	lda.b tmp4
	asl a
	asl a
	asl a
	clc
	adc.w #colourbuf
	sta.b a2
	lda.w #$0000
	adc.w #colourbuf>>16
	sta.b a2+2
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	tax
	lda.w #$0007
	sta.b tmp0
	sta.b tmp1
	lda.b [a2]
	clc
	adc.l scorechars
	sta.l screenmap+6,x
	ora.w #$4000
	sta.l screenmap+$16,x
	inx
	inx
	inc.b a2
	inc.b a2
	lda.b [a2]
	clc
	adc.l scorechars
.loop3:								; loop: screenmap+6,x = A, X + 1, X + 1, ...
	sta.l screenmap+6,x
	inx
	inx
	dec.b tmp0
	bne .loop3
	inc.b a2
	inc.b a2
	lda.b [a2]
	clc
	adc.l scorechars
	ora.w #$8000
	sta.l screenmap+$F6,x
	ora.w #$C000
	sta.l screenmap+$106,x
	inx
	inx
	inc.b a2
	inc.b a2
	lda.b [a2]
	clc
	adc.l scorechars
	ora.w #$8000
.loop4:								; loop: screenmap+$F6,x = A, X + 1, X + 1, ...
	sta.l screenmap+$F6,x
	inx
	inx
	dec.b tmp1
	bne .loop4
org $9D9000
	dec.b d4
	beq .t1x
	jmp.w .loop2

.t1x:								; d4 counted to 0: p0 = bigtextbuf, call DMAToVRAM
	lda.w #bigtextbuf>>16
	sta.b p0+2
	lda.w #bigtextbuf
	sta.b p0
	ldy.w #$4000
	lda.l bigtextchar
	inc a
	asl a
	asl a
	asl a
	asl a
	tax
	jsl.l DMAToVRAM
.loopxx:							; loop: increment a0, if zero go to .7, ...
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	cmp.w #$00FF
	beq .7
	asl a
	adc.w #$B72C
	sta.b tmp0
	lda.w #$0099
	sta.b tmp1
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	asl a
	tax
	lda.l PlayoffBracketMap+2
	tay
.loop2x:							; loop: screenmap+$206,x = [tmp0], tmp0 = tmp0 + PlayoffBracketMap + Pl...
	lda.b [tmp0]
	sta.l screenmap+$206,x
	lda.b tmp0
	clc
	adc.l PlayoffBracketMap
	adc.l PlayoffBracketMap
	sta.b tmp0
	txa
	adc.w #$0100
	tax
	dey
	bne .loop2x
	bra .loopxx
.3:									; textdirtyhi = 0, textdirtylo = $FFFF, return
	stz.w textdirtyhi
	lda.w #$FFFF
	sta.w textdirtylo
	rtl
.7:									; increment a0, d2+2 = [a0] & $00FF * 2 * 2 * 2, increment a0, ...
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	asl a
	asl a
	asl a
	sta.b d2+2
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	asl a
	asl a
	asl a
	sta.b d0+2
	stz.b d3+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayoffScreenPos2>>16
	sta.b a1+2
	lda.w #PlayoffScreenPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w bosgames
	cmp.w #$0007
	beq .1x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d4
	beq .1x
	stz.b a2
.loopxxx:							; loop: increment a0, printx = [a0] & $00FF, increment a0, ...
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w printx
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	asl a
	asl a
	sta.w printy
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$0005
	sta.w mesarea
	ldx.b a2
	lda.l gspotwins,x
	adc.w #$0030
	sta.w mesarea+2
	lda.w #$002D
	sta.w mesarea+3
	lda.l gspobwins,x
	adc.w #$0030
	sta.w mesarea+4
	lda.w #$6E82
	sta.w printm
	jsl.l print
	inc.b a2
	inc.b a2
	dec.b d4
	bne .loopxxx
.1x:								; p0 = StanleyCupMap, p1+2 = $007F, p1 = $0000, ...
	lda.w #StanleyCupMap>>16
	sta.b p0+2
	lda.w #StanleyCupMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #screenmap>>16
	sta.b p1+2
	lda.w #screenmap+6
	sta.b p1
	lda.w #$0080
	sta.b r7
	ldx.w #$003D
	ldy.w #$0008
	lda.l cupchars
	ora.w #$0C00
	jsl.l PasteMap
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #N8hTxt>>16
	sta.b a1+2
	lda.w #N8hTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$6E82
	sta.w printm
	jsl.l PWprint
	lda.w #$0080
	sta.l screenmap
	sta.l screenmap2
	lda.w #$0020
	sta.l screenmap+2
	sta.l screenmap2+2
	lda.w #screenmap2>>16
	sta.b p0+2
	lda.w #screenmap2
	sta.b p0
	lda.w #$3800
	sta.w MapVRAM
	lda.w #$0020
	sta.b r7
	stz.b r7+2
	lda.w #$0040
	sta.b r4
	lda.w #$0020
	sta.b r4+2
	ldx.w #$0000
	ldy.w #$0000
	jsl.l MapPartToVRAM
	lda.w #screenmap>>16
	sta.b p0+2
	lda.w #screenmap
	sta.b p0
	stz.w MapVRAM
	lda.w #$0020
	sta.b r7
	stz.b r7+2
	lda.w #$0040
	sta.b r4
	lda.w #$001C
	sta.b r4+2
	ldx.w #$0000
	ldy.w #$0000
	jsl.l MapPartToVRAM
	lda.w #$0180
	sta.w Hscroll
	sec
	sbc.w #$0100
	sta.w BG1HScroll
	sta.w BG3HScroll
	sec
	sbc.w #$0080
	sta.w BG2HScroll
	lda.w #$FFFC
	sta.w BG3VScroll
	lda.w #$1D47
	sta.l palbuffer+(1*$20)+(1*2)
	sta.l palbuffer+(1*$20)+(5*2)
	lda.w #$FFFF
	sta.l palbuffer+(1*$20)+(3*2)
	lda.w #palbuffer>>16
	sta.b p0+2
	lda.w #palbuffer+$20
	sta.b p0
	ldy.w #$0010
	ldx.w #$0070
	jsl.l DMAToCGRAM
	jsl.l ScreenOn
.2x:								; call WaitFrame, call ReadPads, ora padnew+2, ...
	jsl.l WaitFrame
	jsl.l ReadPads
	lda.w padnew
	ora.w padnew+2
	cmp.w #$1000
	bne .t2x
	jmp.w .3

.t2x:								; if vcount = d7 go to .2x, ...
	lda.b vcount
	cmp.b d7
	beq .2x
	sta.b d7
	ldx.w #palbuffer+$2E
	ldy.w #palbuffer>>16
	jsl.l PulseColour
	lda.w #palbuffer>>16
	sta.b p0+2
	lda.w #palbuffer+$20
	sta.b p0
	ldy.w #$0010
	ldx.w #$0010
	jsl.l DMAToCGRAM
	lda.w JoyPad
	ora.w JoyPad+2
	bit.w #$0200
	bne .t1xx
	bit.w #$0100
	bne .t3x
	lda.b d3+2
	bne .3x
	jmp.w .2x

.t1xx:								; d3+2 = $FFFE, go to .3x
	lda.w #$FFFE
	sta.b d3+2
	jmp.w .3x

.t3x:								; d3+2 = $0002
	lda.w #$0002
	sta.b d3+2
.3x:								; if carry set go to .t2xx, ...
	lda.w Hscroll
	clc
	adc.b d3+2
	cmp.b d2+2
	bcs .t2xx
	jmp.w .5

.t2xx:								; if carry clear go to .t1xxx, ...
	cmp.b d0+2
	bcc .t1xxx
	jmp.w .5

.t1xxx:								; Hscroll = A, and #$0007, if zero go to .t3xx, ...
	sta.w Hscroll
	and.w #$0007
	beq .t3xx
	jmp.w .4

.t3xx:								; if d3+2 negative go to .t2xxx, ...
	lda.b d3+2
	bmi .t2xxx
	lda.w Hscroll
	lsr a
	lsr a
	lsr a
	clc
	adc.w #$002F
	cmp.w #$0080
	bcc .t1xxxx
	jmp.w .4

.t1xxxx:							; r7 = A, p0 = screenmap, MapVRAM = 0, ...
	sta.b r7
	pha
	lda.w #screenmap>>16
	sta.b p0+2
	lda.w #screenmap
	sta.b p0
	stz.w MapVRAM
	stz.b r7+2
	lda.w #$0001
	sta.b r4
	lda.w #$001C
	sta.b r4+2
	lda.b r7
	sec
	sbc.w #$0020
	and.w #$003F
	tax
	phx
	ldy.w #$0000
	jsl.l MapPartToVRAM
	lda.w #screenmap2>>16
	sta.b p0+2
	lda.w #screenmap2
	sta.b p0
	lda.w #$3800
	sta.w MapVRAM
	plx
	pla
	sta.b r7
	stz.b r7+2
	lda.w #$0001
	sta.b r4
	lda.w #$0020
	sta.b r4+2
	ldy.w #$0000
	jsl.l MapPartToVRAM
	bra .4

.t2xxx:								; d3+2 negative: if carry clear go to .4, ...
	lda.w Hscroll
	lsr a
	lsr a
	lsr a
	sec
	sbc.w #$0010
	bcc .4
	sta.b r7
	pha
	lda.w #screenmap>>16
	sta.b p0+2
	lda.w #screenmap
	sta.b p0
	stz.w MapVRAM
	stz.b r7+2
	lda.w #$0001
	sta.b r4
	lda.w #$001C
	sta.b r4+2
	lda.b r7
	sec
	sbc.w #$0020
	and.w #$003F
	tax
	phx
	ldy.w #$0000
	jsl.l MapPartToVRAM
	lda.w #screenmap2>>16
	sta.b p0+2
	lda.w #screenmap2
	sta.b p0
	lda.w #$3800
	sta.w MapVRAM
	plx
	pla
	sta.b r7
	stz.b r7+2
	lda.w #$0001
	sta.b r4
	lda.w #$0020
	sta.b r4+2
	ldy.w #$0000
	jsl.l MapPartToVRAM
.4:									; if Hscroll = $0058 go to .5, ...
	lda.w Hscroll
	cmp.w #$0058
	beq .5
	cmp.w #$00B0
	beq .5
	cmp.w #$0108
	beq .5
	cmp.w #$0180
	beq .5
	cmp.w #$01F8
	beq .5
	cmp.w #$0250
	beq .5
	cmp.w #$02A8
	bne .6
.5:									; d3+2 = 0
	stz.b d3+2
.6:									; BG1HScroll = Hscroll - $0100, BG3HScroll = Hscroll - $0100, ...
	lda.w Hscroll
	sec
	sbc.w #$0100
	sta.w BG1HScroll
	sta.w BG3HScroll
	sec
	sbc.w #$0080
	sta.w BG2HScroll
	jmp.w .2x
.8:									; db $04,$06,$08,$0A,$0C,$0E,$10,$12,$14,$16,$18,$1A,$1C,$1E,$24,$26, ...
	db $04,$06,$08,$0A,$0C,$0E,$10,$12,$14,$16,$18,$1A,$1C,$1E,$24,$26
	db $28,$2A,$2C,$2E,$30,$32,$34,$36,$38,$3A,$3C,$3E,$44,$46,$48,$4A
	db $4C,$4E,$50,$52,$54,$56,$58,$5A,$5C,$5E,$64,$66,$68,$6A,$6C,$6E
	db $70,$72,$74,$76,$78,$7A
.9:									; subroutine: colourbuf,x = X / 2, colourbuf+2,x = X / 2 + 1, if carry...
	txa
	asl a
	asl a
	asl a
	asl a
	pha
	sep #$20
	txa
	lsr a
	sta.l colourbuf,x
	inc a
	sta.l colourbuf+2,x
	tya
	lsr a
	lsr a
	lsr a
	and.b #$1C
	clc
	adc.b #$30
	cpx.w #$0200
	bcc .1xx
	ora.b #$01
.1xx:								; colourbuf+1,x = A, colourbuf+3,x = A, r0 = Y / 2 & $0F, ...
	sta.l colourbuf+1,x
	sta.l colourbuf+3,x
	lda.b 1,s
	tax
	tya
	lsr a
	and.b #$0F
	sta.b r0
	jsr.w .t1xxxxx
	rep #$20
	pla
	clc
	adc.w #$0020
	tax
	sep #$20
	jsr.w .7x
	rep #$20
	rts

.t1xxxxx:							; subroutine: falls through
	lda.b #$01
	pha
	ldy.w #$0007
.2xx:								; if 3,s & $01 = 0 go to .t1xxxxxx, ...
	phx
	lda.b 3,s
	and.b #$01
	beq .t1xxxxxx
	lda.b #$FF
	sta.l brackettiles,x
	bra .3xx

.t1xxxxxx:							; 3,s & $01 = 0: brackettiles,x = $80
	lda.b #$80
	sta.l brackettiles,x
.3xx:								; X + 1, if 3,s & $02 = 0 go to .t1xxxxxxx, ...
	inx
	lda.b 3,s
	and.b #$02
	beq .t1xxxxxxx
	lda.b #$7F
	sta.l brackettiles,x
	bra .4x

.t1xxxxxxx:							; 3,s & $02 = 0: brackettiles,x = $00
	lda.b #$00
	sta.l brackettiles,x
.4x:								; if 3,s & $04 = 0 go to .t1xxxxxxxx, ...
	txa
	clc
	adc.b #$0F
	tax
	lda.b 3,s
	and.b #$04
	beq .t1xxxxxxxx
	lda.b #$7F
	sta.l brackettiles,x
	bra .5x

.t1xxxxxxxx:						; 3,s & $04 = 0: brackettiles,x = $00
	lda.b #$00
	sta.l brackettiles,x
.5x:								; X + 1, if 3,s & $08 = 0 go to .t1xxxxxxxxx, ...
	inx
	lda.b 3,s
	and.b #$08
	beq .t1xxxxxxxxx
	lda.b #$7F
	sta.l brackettiles,x
	bra .6x

.t1xxxxxxxxx:						; 3,s & $08 = 0: brackettiles,x = $00
	lda.b #$00
	sta.l brackettiles,x
.6x:								; 3,s = r0, X + 1, X + 1, ...
	lda.b r0
	sta.b 3,s
	plx
	inx
	inx
	dey
	bpl .2xx
	pla
	rts
.7x:								; subroutine: falls through
	lda.b #$01
	pha
	ldy.w #$0007
.1xxx:								; if 3,s & $01 = 0 go to .t1xxxxxxxxxx, ...
	phx
	lda.b 3,s
	and.b #$01
	beq .t1xxxxxxxxxx
	lda.b #$FF
	sta.l brackettiles,x
	bra .2xxx

.t1xxxxxxxxxx:						; 3,s & $01 = 0: brackettiles,x = $00
	lda.b #$00
	sta.l brackettiles,x
.2xxx:								; X + 1, if 3,s & $02 = 0 go to .t1xxxxxxxxxxx, ...
	inx
	lda.b 3,s
	and.b #$02
	beq .t1xxxxxxxxxxx
	lda.b #$FF
	sta.l brackettiles,x
	bra .3xxx

.t1xxxxxxxxxxx:						; 3,s & $02 = 0: brackettiles,x = $00
	lda.b #$00
	sta.l brackettiles,x
.3xxx:								; if 3,s & $04 = 0 go to .t1xxxxxxxxxxxx, ...
	txa
	clc
	adc.b #$0F
	tax
	lda.b 3,s
	and.b #$04
	beq .t1xxxxxxxxxxxx
	lda.b #$FF
	sta.l brackettiles,x
	bra .4xx

.t1xxxxxxxxxxxx:					; 3,s & $04 = 0: brackettiles,x = $00
	lda.b #$00
	sta.l brackettiles,x
.4xx:								; X + 1, if 3,s & $08 = 0 go to .t1xxxxxxxxxxxxx, ...
	inx
	lda.b 3,s
	and.b #$08
	beq .t1xxxxxxxxxxxxx
	lda.b #$FF
	sta.l brackettiles,x
	bra .5xx

.t1xxxxxxxxxxxxx:					; 3,s & $08 = 0: brackettiles,x = $00
	lda.b #$00
	sta.l brackettiles,x
.5xx:								; 3,s = r0, X + 1, X + 1, ...
	lda.b r0
	sta.b 3,s
	plx
	inx
	inx
	dey
	bpl .1xxx
	pla
	rts
.10:								; db $0A,$00,$47,$00,$94,$00,$ED,$00,$4C,$01,$10,$31,$02,$31,$05,$31, ...
	db $0A,$00,$47,$00,$94,$00,$ED,$00,$4C,$01,$10,$31,$02,$31,$05,$31
	db $08,$31,$0B,$31,$0E,$31,$11,$31,$14,$31,$17,$46,$02,$46,$05,$46
	db $08,$46,$0B,$46,$0E,$46,$11,$46,$14,$46,$17,$00,$3A,$01,$3B,$0A
	db $44,$0B,$45,$FF,$30,$30,$08,$34,$04,$34,$0A,$34,$10,$34,$16,$49
	db $04,$49,$0A,$49,$10,$49,$16,$18,$26,$02,$26,$05,$26,$08,$26,$0B
	db $26,$0E,$26,$11,$26,$14,$26,$17,$51,$02,$51,$05,$51,$08,$51,$0B
	db $51,$0E,$51,$11,$51,$14,$51,$17,$31,$04,$31,$0A,$31,$0F,$31,$15
	db $46,$04,$46,$0A,$46,$0F,$46,$15,$00,$2F,$01,$30,$02,$3A,$03,$3B
	db $08,$44,$09,$45,$0A,$4F,$0B,$50,$FF,$21,$3F,$04,$34,$08,$34,$12
	db $49,$08,$49,$12,$1C,$1B,$02,$1B,$05,$1B,$08,$1B,$0B,$1B,$0E,$1B
	db $11,$1B,$14,$1B,$17,$5C,$02,$5C,$05,$5C,$08,$5C,$0B,$5C,$0E,$5C
	db $11,$5C,$14,$5C,$17,$26,$04,$26,$0A,$26,$0F,$26,$15,$51,$04,$51
	db $0A,$51,$0F,$51,$15,$31,$07,$31,$12,$46,$07,$46,$12,$00,$24,$01
	db $25,$02,$2F,$03,$30,$04,$3A,$05,$3B,$06,$44,$07,$45,$08,$4F,$09
	db $50,$0A,$5A,$0B,$5B,$FF,$16,$4A,$02,$34,$0D,$49,$0D,$1E,$10,$02
	db $10,$05,$10,$08,$10,$0B,$10,$0E,$10,$11,$10,$14,$10,$17,$67,$02
	db $67,$05,$67,$08,$67,$0B,$67,$0E,$67,$11,$67,$14,$67,$17,$1B,$04
	db $1B,$0A,$1B,$0F,$1B,$15,$5C,$04,$5C,$0A,$5C,$0F,$5C,$15,$26,$07
	db $26,$12,$51,$07,$51,$12,$31,$0C,$46,$0C,$00,$19,$01,$1A,$02,$24
	db $03,$25,$04,$2F,$05,$30,$05,$3A,$06,$45,$06,$4F,$07,$50,$08,$5A
	db $09,$5B,$0A,$65,$0B,$66,$FF,$0B,$55,$01,$3E,$17,$1F,$10,$02,$10
	db $05,$10,$08,$10,$0B,$10,$0E,$10,$11,$10,$14,$10,$17,$67,$02,$67
	db $05,$67,$08,$67,$0B,$67,$0E,$67,$11,$67,$14,$67,$17,$1B,$04,$1B
	db $0A,$1B,$0F,$1B,$15,$5C,$04,$5C,$0A,$5C,$0F,$5C,$15,$26,$07,$26
	db $12,$51,$07,$51,$12,$31,$0C,$46,$0C,$3B,$17,$00,$19,$01,$1A,$02
	db $24,$03,$25,$04,$2F,$05,$30,$05,$3A,$06,$45,$06,$4F,$07,$50,$08
	db $5A,$09,$5B,$0A,$65,$0B,$66,$FF,$0B,$55,$00
