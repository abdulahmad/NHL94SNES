; The playoff tree screen
PlayoffScreen:						; called from GameOver, StartGame
	lda.w #$FFFF					;no team photos yet
	sta.l phototeams
	sta.l phototeams+2
	lda.w #$0000
	sta.l charofs					;text sets from character 0
	sta.l charofs2
	lda.l OptPlayMode				;play mode
	bne .t3							;playoffs or shootout
	jmp.w .3						;exhibition: no song change

.t3:								; OptPlayMode != 0: if not zero go to .t1, ...
	cmp.w #$0004					;shootout?
	bne .t1
	jmp.w .3						;yes: no song change

.t1:								; if playoffRoundIdx < $0002 go to .t2, ...
	lda.l playoffRoundIdx			;playoff round
	cmp.w #$0002					;before the finals?
	bcc .t2							;yes: keep the music
	lda.w SongPtr					;current song
	cmp.w #$ED31					;the playoff song already?
	beq .t2							;yes: keep it
	jsl.l FadeOutSound				; start the sound fade out
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
.loop:								; loop: if MusicOn != 0 go to .loop, ...
	lda.w MusicOn					;wait for silence
	bne .loop
	lda.w #PlayoffSong>>16
	sta.b p0+2
	lda.w #PlayoffSong
	sta.b p0
	jsl.l MusicStart				; start the song at [p0]: tempo from its second byte
	jmp.w .2

.t2:								; call forceblack
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
.2:									; BGMODE = $09, BG1SC = $01, BG2SC = $08, ...
	sep #$20
	lda.b #$09						;mode 1, BG3 priority
	sta.w BGMODE
	lda.b #$01						;BG1 map $0400, 64 wide
	sta.w BG1SC
	lda.b #$08						;BG2 map $2000
	sta.w BG2SC
	lda.b #$39						;BG3 map $3800, 64x64
	sta.w BG3SC
	lda.b #$31						;BG1 chars $1000, BG2 $3000
	sta.w BG12NBA
	lda.b #$04						;BG3 chars $4000
	sta.w BG34NBA
	lda.b #$03						;sprite chars $6000
	sta.w OBSEL
	lda.b #$07						;main screen: BG1-BG3
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
	jsl.l Decompress				; unpack MenuBackTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$3000					;at VRAM $3000
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #MenuBackMap>>16
	sta.b p0+2
	lda.w #MenuBackMap
	sta.b p0
	jsl.l Decompress				; unpack MenuBackMap
	lda.w #(unpackbuf+$246)>>16		;skip the map header and top rows
	sta.b p0+2
	lda.w #unpackbuf+$246
	sta.b p0
	phx
	ldx.w #$0240					;$240 bytes
	ldy.w #$0800					;to the BG2 map
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	pla								;bytes unpacked
	sec
	sbc.w #$0240					;minus the first part
	tax
	ldy.w #$0920					;rest after a gap
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #MenuBackPalette>>16
	sta.b p0+2
	lda.w #MenuBackPalette
	sta.b p0
	jsl.l Decompress				; unpack MenuBackPalette
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0000					;colour 0
	ldx.w #$0010					;16 bytes
	jsl.l DMAToCGRAM				; DMA X bytes of colours from [p0] to CGRAM at colour Y
	lda.w #PlayoffTiles>>16
	sta.b p0+2
	lda.w #PlayoffTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack PlayoffTiles
	txa								;tile count
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a							;/32 bytes
	sta.l smallfontchars			;small font follows the tree tiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$1000					;at VRAM $1000
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #PlayoffPalette>>16
	sta.b p0+2
	lda.w #PlayoffPalette
	sta.b p0
	lda.w #palbuffer>>16
	sta.b p1+2
	lda.w #palbuffer
	sta.b p1
	jsl.l Decompress				; unpack PlayoffPalette
	lda.w #SmallFontTiles>>16
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack SmallFontTiles
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0						;font size
	adc.l smallfontchars			;plus its start
	sta.l BigFontChars				;big font follows
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #unpackbuf
	sta.b a0
	lda.w #PixelRemap8F>>16
	sta.b a1+2
	lda.w #PixelRemap8F
	sta.b a1
	jsl.l RemapTiles				;remap the font colours
	lda.w #SmallFontTiles>>16
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack SmallFontTiles
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l BigFontChars				;plus its start
	sta.l scorechars				;score characters follow
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF					;at the current VRAM address
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #$031A					;gold
	sta.l palbuffer+(4*$20)+(1*2)	;colour 1 of palettes 4-7
	sta.l palbuffer+(5*$20)+(1*2)
	sta.l palbuffer+(6*$20)+(1*2)
	sta.l palbuffer+(7*$20)+(1*2)
	lda.w #palbuffer>>16
	sta.b p1+2
	lda.w #palbuffer+$80			;palettes 4-7
	sta.b p1
	ldx.w #$001B					;28 teams
.loopx:								; loop: p0+2 = TeamBlockPalettes+2,x, p0 = TeamBlockPalettes,x, [p1],y...
	phx								; 1,s = x (the team slot); 3,s while the palette word is pushed
	txa								;team slot
	asl a
	asl a							;4 bytes per pointer
	tax
	lda.l TeamBlockPalettes+2,x
	sta.b p0+2
	lda.l TeamBlockPalettes,x
	sta.b p0						;team block palette
	ldy.w #$0008					;colour 4
	lda.b [p0],y					;first team colour
	pha								; 1,s = this palette word
	lda.b 3,s						;team slot
	asl a
	tax								;byte index
	lda.l .8,x						;its palette entry
	and.w #$00FF
	tay
	pla
	sta.b [p1],y					;into the palette buffer
	lda.b 1,s
	asl a
	asl a
	asl a							;8 bytes per team
	tax
	jsr.w .9						;copy the rest
	ldy.w #$0012					;colour 9
	lda.b [p0],y					;second team colour
	pha
	lda.b 3,s
	asl a
	tax
	inx
	lda.l .8,x						;second entry
	and.w #$00FF
	tay
	pla
	sta.b [p1],y
	lda.b 1,s
	asl a							;into the palette buffer
	inc a
	asl a
	asl a
	tax
	jsr.w .9						;copy the rest
	plx
	dex
	bpl .loopx						;all teams
	lda.l scorechars				;score characters
	clc
	adc.w #$0070					;plus $70
	sta.l cupchars					;Stanley Cup characters
	lda.w #brackettiles>>16
	sta.b p0+2
	lda.w #brackettiles
	sta.b p0
	ldx.w #$0E00					;$E00 bytes
	ldy.w #$FFFF					;at the current VRAM address
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #StanleyCupPalette>>16
	sta.b p0+2
	lda.w #StanleyCupPalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack StanleyCupPalette
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #(palbuffer+(3*$20))>>16
	sta.b p1+2
	lda.w #palbuffer+(3*$20)		; palette 3
	sta.b p1
	ldx.w #$0020					;16 colours
	jsl.l MemCopy					;into palette 3
	lda.w #StanleyCupTiles>>16
	sta.b p0+2
	lda.w #StanleyCupTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack StanleyCupTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF					;at the current VRAM address
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #BigLetterTiles>>16
	sta.b p0+2
	lda.w #BigLetterTiles
	sta.b p0
	lda.w #bigtextbuf>>16
	sta.b p1+2
	lda.w #bigtextbuf
	sta.b p1
	jsl.l Decompress				; unpack BigLetterTiles
	lda.w #bigtextbuf>>16
	sta.b p0+2
	lda.w #bigtextbuf
	sta.b p0
	lda.w #hlsavebuf>>16
	sta.b p1+2
	lda.w #hlsavebuf
	sta.b p1
	stx.b r0						;size
	jsl.l LinearToPlanar			;to planar in hlsavebuf
	lda.w #bigtextbuf>>16
	sta.b p1+2
	lda.w #bigtextbuf
	sta.b p1
	lda.w #$0000
	ldx.w #$8000					;32K bytes
	jsl.l MemFill					;clear the big text buffer
	lda.w #screenmap>>16
	sta.b p1+2
	lda.w #screenmap+6				;past the header
	sta.b p1
	lda.w #$0000
	ldx.w #$4002					;whole map
	jsl.l MemFill					;clear the screen map
	lda.w #potree>>16
	sta.b a1+2						;tree layout
	lda.w #potree
	sta.b a1
	lda.w #.10>>16					;team slot positions
	sta.b a0+2
	lda.w #.10
	sta.b a0
	lda.l playoffRoundIdx			;playoff round
	asl a							;word index
	tay
	lda.b [a0],y					;offset of this round's data
	adc.b a0						;from the table start
	sta.b a0
	lda.b [a0]						;team count
	inc.b a0						;next byte
	and.w #$00FF
	sta.b d4						;d4 = teams to show
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayoffScreenPos>>16
	sta.b a1+2
	lda.w #PlayoffScreenPos
	sta.b a1
	jsl.l print						; print PlayoffScreenPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0001
	sta.l bigtextchar				;big text starts at character 1
.loop2:								; loop: increment a0, printx = [a0] & $00FF, printa = $3000, ...
	lda.b [a0]						;slot column
	inc.b a0
	and.w #$00FF
	sta.w printx					;printx
	lda.w #$3000					;palette 4
	sta.w printa
	lda.b [a0]						;slot row
	inc.b a0
	and.w #$00FF
	sta.w printy					;printy
	lda.b [a1]						;team in the slot
	inc.b a1
	and.w #$00FF
	sta.b tmp4						;tmp4 = team
	tay
	lda.l potreeteam				;the user's team slot
	tax
	tya
	eor.l potree,x					;same team?
	and.w #$00FF
	bne .1							;no: palette 4
	lda.w #$3400					;user's team: palette 5
	sta.w printa
.1:									; p0 = long TeamPlaceNames,x, jmlvector = $005C, ...
	lda.b tmp4
	asl a							;word index
	tax
	lda.l TeamPlaceNames,x			;team place name
	sta.b p0
	lda.w #TeamPlaceNames>>16
	sta.b p0+2
	lda.w printx
	pha								;keep the column
	lda.w #$005C
	sta.w jmlvector
	lda.w #BigLetterPlayoff
	sta.w jmlvector+1
	lda.w #BigLetterPlayoff>>16
	sta.w jmlvector+3
	jsl.l RenderBigText				;draw the name
	pla
	sta.w printx					;column back
	lda.b tmp4						;team
	asl a
	asl a
	asl a							;8 bytes per team
	clc
	adc.w #colourbuf				;its block colours
	sta.b a2
	lda.w #$0000
	adc.w #colourbuf>>16
	sta.b a2+2
	lda.w printy					;row
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a							;x 128: 64-column map rows
	adc.w printx					;plus the column
	asl a							;word index
	tax
	lda.w #$0007					;8 wide
	sta.b tmp0						;tmp0 = middle
	sta.b tmp1						;tmp1 = bottom middle
	lda.b [a2]						;top-left block
	clc
	adc.l scorechars				;plus the score chars
	sta.l screenmap+6,x				;top left
	ora.w #$4000					;h flip
	sta.l screenmap+$16,x			;top right
	inx
	inx
	inc.b a2						;next block word
	inc.b a2
	lda.b [a2]						;top edge
	clc
	adc.l scorechars				;plus the score chars
.loop3:								; loop: screenmap+6,x = A, X + 1, X + 1, ...
	sta.l screenmap+6,x				;top edge
	inx
	inx
	dec.b tmp0						;along
	bne .loop3						;the whole width
	inc.b a2
	inc.b a2
	lda.b [a2]						;bottom-left block
	clc
	adc.l scorechars				;plus the score chars
	ora.w #$8000					;v flip
	sta.l screenmap+$F6,x			;bottom left
	ora.w #$C000					;h and v flip
	sta.l screenmap+$106,x			;bottom right
	inx
	inx
	inc.b a2
	inc.b a2
	lda.b [a2]						;bottom edge
	clc
	adc.l scorechars				;plus the score chars
	ora.w #$8000					;v flip
.loop4:								; loop: screenmap+$F6,x = A, X + 1, X + 1, ...
	sta.l screenmap+$F6,x			;bottom edge
	inx
	inx
	dec.b tmp1						;along
	bne .loop4						;the whole width
org $9D9000
	dec.b d4						;team done
	beq .t1x						;all teams?
	jmp.w .loop2					;no: next

.t1x:								; d4 counted to 0: p0 = bigtextbuf, call DMAToVRAM
	lda.w #bigtextbuf>>16
	sta.b p0+2
	lda.w #bigtextbuf
	sta.b p0
	ldy.w #$4000					;at VRAM $4000
	lda.l bigtextchar				;big text characters used
	inc a							;plus one
	asl a
	asl a
	asl a
	asl a							;x16 bytes
	tax								;size
	jsl.l DMAToVRAM					;send the names
.loopxx:							; loop: increment a0, if zero go to .7, ...
	lda.b [a0]						;bracket piece
	inc.b a0
	and.w #$00FF
	cmp.w #$00FF					;end?
	beq .7							;yes: series scores
	asl a							;word index
	adc.w #$B72C					;plus the bracket map
	sta.b tmp0						;piece address
	lda.w #$0099					;bank $99
	sta.b tmp1
	lda.b [a0]						;position
	inc.b a0
	and.w #$00FF
	asl a							;word index
	tax
	lda.l PlayoffBracketMap+2		;rows
	tay								;count
.loop2x:							; loop: screenmap+$206,x = [tmp0], tmp0 = tmp0 + PlayoffBracketMap + Pl...
	lda.b [tmp0]					;map word
	sta.l screenmap+$206,x			;into the screen map
	lda.b tmp0						;next row of the piece
	clc
	adc.l PlayoffBracketMap
	adc.l PlayoffBracketMap			;piece width x2
	sta.b tmp0
	txa
	adc.w #$0100					;next screen row
	tax
	dey
	bne .loop2x						;all rows
	bra .loopxx						;next piece
.3:									;shootout / exhibition: nothing to draw
	stz.w textdirtyhi
	lda.w #$FFFF					;whole text map
	sta.w textdirtylo
	rtl
.7:									; increment a0, d2+2 = [a0] & $00FF * 2 * 2 * 2, increment a0, ...
	lda.b [a0]						;cup x
	inc.b a0
	and.w #$00FF
	asl a
	asl a
	asl a							;x8 pixels
	sta.b d2+2						;d2+2 = cup x
	lda.b [a0]						;cup y
	inc.b a0
	and.w #$00FF
	asl a
	asl a
	asl a							;x8 pixels
	sta.b d0+2						;d0+2 = cup y
	stz.b d3+2						;frame 0
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayoffScreenPos2>>16
	sta.b a1+2
	lda.w #PlayoffScreenPos2
	sta.b a1
	jsl.l print						; print PlayoffScreenPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w bosgames					;best of
	cmp.w #$0007					;single games?
	beq .1x							;yes: no series scores
	lda.b [a0]						;series count
	inc.b a0
	and.w #$00FF
	sta.b d4						;d4
	beq .1x							;none
	stz.b a2						;first series
.loopxxx:							; loop: increment a0, printx = [a0] & $00FF, increment a0, ...
	lda.b [a0]						;column
	inc.b a0
	and.w #$00FF
	sta.w printx
	lda.b [a0]						;row
	inc.b a0
	and.w #$00FF
	asl a							;x4
	asl a
	sta.w printy
	lda.w #mesarea>>16				;message
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$0005					;length 5
	sta.w mesarea
	ldx.b a2						;series
	lda.l gspotwins,x				;top team wins
	adc.w #$0030					;to a digit
	sta.w mesarea+2					;"N"
	lda.w #$002D					;"-"
	sta.w mesarea+3
	lda.l gspobwins,x				;bottom team wins
	adc.w #$0030					;to a digit
	sta.w mesarea+4					;"N"
	lda.w #$6E82					;palette
	sta.w printm
	jsl.l print						;print the series score
	inc.b a2
	inc.b a2						;next series
	dec.b d4
	bne .loopxxx					;all
.1x:								; p0 = StanleyCupMap, p1+2 = $007F, p1 = $0000, ...
	lda.w #StanleyCupMap>>16
	sta.b p0+2
	lda.w #StanleyCupMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack StanleyCupMap
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #screenmap>>16
	sta.b p1+2
	lda.w #screenmap+6
	sta.b p1
	lda.w #$0080					;128 wide
	sta.b r7
	ldx.w #$003D					;column 61
	ldy.w #$0008					;row 8
	lda.l cupchars
	ora.w #$0C00					;palette 3
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #N8hTxt>>16
	sta.b a1+2
	lda.w #N8hTxt
	sta.b a1
	jsl.l print						; print N8hTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$6E82
	sta.w printm					;palette
	jsl.l PWprint					; print the password, unless it is hidden
	lda.w #$0080					;128 columns
	sta.l screenmap
	sta.l screenmap2
	lda.w #$0020					;32 rows
	sta.l screenmap+2
	sta.l screenmap2+2
	lda.w #screenmap2>>16
	sta.b p0+2
	lda.w #screenmap2
	sta.b p0
	lda.w #$3800
	sta.w MapVRAM					;BG3 map at $3800
	lda.w #$0020
	sta.b r7						;32 wide
	stz.b r7+2
	lda.w #$0040					;64 columns
	sta.b r4
	lda.w #$0020					;32 rows
	sta.b r4+2
	ldx.w #$0000
	ldy.w #$0000
	jsl.l MapPartToVRAM				;send the BG3 map
	lda.w #screenmap>>16
	sta.b p0+2
	lda.w #screenmap
	sta.b p0
	stz.w MapVRAM					;BG1 map at 0
	lda.w #$0020
	sta.b r7
	stz.b r7+2
	lda.w #$0040
	sta.b r4						;64 columns
	lda.w #$001C
	sta.b r4+2						;28 rows
	ldx.w #$0000
	ldy.w #$0000
	jsl.l MapPartToVRAM				; copy part of map [p0] into the screen map in video memory at column X
	lda.w #$0180					;scroll to x $180
	sta.w Hscroll
	sec
	sbc.w #$0100
	sta.w BG1HScroll				;BG1 at $80
	sta.w BG3HScroll				;BG3 the same
	sec
	sbc.w #$0080					;BG2 at 0
	sta.w BG2HScroll
	lda.w #$FFFC
	sta.w BG3VScroll				;BG3 down 4
	lda.w #$1D47					;blue
	sta.l palbuffer+(1*$20)+(1*2)	;text colours
	sta.l palbuffer+(1*$20)+(5*2)
	lda.w #$FFFF					;white
	sta.l palbuffer+(1*$20)+(3*2)
	lda.w #palbuffer>>16
	sta.b p0+2
	lda.w #palbuffer+$20
	sta.b p0
	ldy.w #$0010					;colour 16
	ldx.w #$0070					;$70 bytes
	jsl.l DMAToCGRAM				;send palettes 1-4
	jsl.l ScreenOn
.2x:								; call WaitFrame, call ReadPads, ora padnew+2, ...
	jsl.l WaitFrame					;next frame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	lda.w padnew					;new presses
	ora.w padnew+2					;either pad
	cmp.w #$1000					;start alone?
	bne .t2x
	jmp.w .3						;yes: leave

.t2x:								; if vcount = d7 go to .2x, ...
	lda.b vcount					;frame counter
	cmp.b d7						;same frame?
	beq .2x							;yes: wait
	sta.b d7						;new frame
	ldx.w #palbuffer+$2E			;colour to pulse
	ldy.w #palbuffer>>16
	jsl.l PulseColour				;pulse the user's team colour
	lda.w #palbuffer>>16
	sta.b p0+2
	lda.w #palbuffer+$20
	sta.b p0
	ldy.w #$0010					;colour 16
	ldx.w #$0010					;16 bytes
	jsl.l DMAToCGRAM				; DMA X bytes of colours from [p0] to CGRAM at colour Y
	lda.w JoyPad					;held buttons
	ora.w JoyPad+2					;either pad
	bit.w #$0200					;left?
	bne .t1xx						;yes: scroll left
	bit.w #$0100					;right?
	bne .t3x						;yes: scroll right
	lda.b d3+2						;scrolling?
	bne .3x							;yes: keep going
	jmp.w .2x

.t1xx:								; d3+2 = $FFFE, go to .3x
	lda.w #$FFFE					;-2 per frame
	sta.b d3+2
	jmp.w .3x

.t3x:								; d3+2 = $0002
	lda.w #$0002					;+2 per frame
	sta.b d3+2
.3x:								; if carry set go to .t2xx, ...
	lda.w Hscroll					;scroll
	clc
	adc.b d3+2						;plus the step
	cmp.b d2+2						;past the left limit?
	bcs .t2xx						;no
	jmp.w .5						;stop

.t2xx:								; if carry clear go to .t1xxx, ...
	cmp.b d0+2						;before the right limit?
	bcc .t1xxx
	jmp.w .5						;no: stop

.t1xxx:								; Hscroll = A, and #$0007, if zero go to .t3xx, ...
	sta.w Hscroll					;new scroll
	and.w #$0007					;on a tile edge?
	beq .t3xx						;yes: send a column
	jmp.w .4						;no: just scroll

.t3xx:								; if d3+2 negative go to .t2xxx, ...
	lda.b d3+2						;direction
	bmi .t2xxx						;left: column on the left
	lda.w Hscroll
	lsr a							;scroll
	lsr a
	lsr a
	clc
	adc.w #$002F					;plus the screen width
	cmp.w #$0080					;inside the 128-column map?
	bcc .t1xxxx
	jmp.w .4						;no

.t1xxxx:							; r7 = A, p0 = screenmap, MapVRAM = 0, ...
	sta.b r7						;map column
	pha
	lda.w #screenmap>>16
	sta.b p0+2
	lda.w #screenmap
	sta.b p0
	stz.w MapVRAM					;BG1 map at 0
	stz.b r7+2
	lda.w #$0001
	sta.b r4						;1 column
	lda.w #$001C
	sta.b r4+2						;28 rows
	lda.b r7
	sec
	sbc.w #$0020					;minus 32
	and.w #$003F					;VRAM column mod 64
	tax
	phx
	ldy.w #$0000					;row 0
	jsl.l MapPartToVRAM				;send the BG1 column
	lda.w #screenmap2>>16
	sta.b p0+2
	lda.w #screenmap2
	sta.b p0
	lda.w #$3800
	sta.w MapVRAM					;BG3 map at $3800
	plx
	pla
	sta.b r7						;map column
	stz.b r7+2
	lda.w #$0001
	sta.b r4						;1 column
	lda.w #$0020
	sta.b r4+2						;32 rows
	ldy.w #$0000
	jsl.l MapPartToVRAM				;send the BG3 column
	bra .4

.t2xxx:								; d3+2 negative: if carry clear go to .4, ...
	lda.w Hscroll
	lsr a							;scroll
	lsr a
	lsr a
	sec
	sbc.w #$0010					;minus 16
	bcc .4							;off the left: nothing
	sta.b r7						;map column
	pha
	lda.w #screenmap>>16
	sta.b p0+2
	lda.w #screenmap
	sta.b p0
	stz.w MapVRAM					;BG1 map at 0
	stz.b r7+2
	lda.w #$0001
	sta.b r4						;1 column
	lda.w #$001C
	sta.b r4+2						;28 rows
	lda.b r7
	sec
	sbc.w #$0020					;minus 32
	and.w #$003F					;VRAM column mod 64
	tax
	phx
	ldy.w #$0000					;row 0
	jsl.l MapPartToVRAM				;send the BG1 column
	lda.w #screenmap2>>16
	sta.b p0+2
	lda.w #screenmap2
	sta.b p0
	lda.w #$3800
	sta.w MapVRAM					;BG3 map at $3800
	plx
	pla
	sta.b r7						;map column
	stz.b r7+2
	lda.w #$0001
	sta.b r4						;1 column
	lda.w #$0020
	sta.b r4+2						;32 rows
	ldy.w #$0000
	jsl.l MapPartToVRAM				;send the BG3 column
.4:									; if Hscroll = $0058 go to .5, ...
	lda.w Hscroll					;scroll
	cmp.w #$0058					;a stop point?
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
	stz.b d3+2						;stop scrolling
.6:									; BG1HScroll = Hscroll - $0100, BG3HScroll = Hscroll - $0100, ...
	lda.w Hscroll					;scroll
	sec
	sbc.w #$0100					;BG1 at -$100
	sta.w BG1HScroll
	sta.w BG3HScroll
	sec
	sbc.w #$0080
	sta.w BG2HScroll
	jmp.w .2x
.8:									;palette offset of each team block colour
	db $04,$06,$08,$0A,$0C,$0E,$10,$12,$14,$16,$18,$1A,$1C,$1E,$24,$26
	db $28,$2A,$2C,$2E,$30,$32,$34,$36,$38,$3A,$3C,$3E,$44,$46,$48,$4A
	db $4C,$4E,$50,$52,$54,$56,$58,$5A,$5C,$5E,$64,$66,$68,$6A,$6C,$6E
	db $70,$72,$74,$76,$78,$7A
.9:									;build the bracket tiles of team X with palette bits Y
	txa
	asl a							;x16
	asl a
	asl a
	asl a							;tile address
	pha								; 1,s = A * 4
	sep #$20						;8-bit A
	txa
	lsr a
	sta.l colourbuf,x				;tile number
	inc a
	sta.l colourbuf+2,x				;next tile
	tya
	lsr a							;palette bits
	lsr a
	lsr a
	and.b #$1C						;palette number
	clc
	adc.b #$30						;plus priority
	cpx.w #$0200					;second half of the teams?
	bcc .1xx
	ora.b #$01						;high tile bit
.1xx:								; colourbuf+1,x = A, colourbuf+3,x = A, r0 = Y / 2 & $0F, ...
	sta.l colourbuf+1,x				;attribute of both tiles
	sta.l colourbuf+3,x
	lda.b 1,s
	tax								;tile address
	tya
	lsr a
	and.b #$0F						;low nibble
	sta.b r0						;r0 = pattern bits
	jsr.w .t1xxxxx					;first tile
	rep #$20
	pla
	clc
	adc.w #$0020
	tax
	sep #$20						;8-bit A
	jsr.w .7x						;second tile
	rep #$20
	rts

.t1xxxxx:							;draw a tile's 8 rows from the bit mask
	lda.b #$01						;bit 0 first
	pha								; 3,s = the bit mask byte (above the pushed x)
	ldy.w #$0007					;8 rows
.2xx:								; if 3,s & $01 = 0 go to .t1xxxxxx, ...
	phx
	lda.b 3,s						;pattern bits
	and.b #$01						;bit 0?
	beq .t1xxxxxx
	lda.b #$FF						;solid
	sta.l brackettiles,x			;plane 0
	bra .3xx

.t1xxxxxx:							; 3,s & $01 = 0: brackettiles,x = $80
	lda.b #$80						;edge only
	sta.l brackettiles,x			;plane 0
.3xx:								; X + 1, if 3,s & $02 = 0 go to .t1xxxxxxx, ...
	inx
	lda.b 3,s
	and.b #$02						;bit 1?
	beq .t1xxxxxxx
	lda.b #$7F						;solid
	sta.l brackettiles,x
	bra .4x

.t1xxxxxxx:							; 3,s & $02 = 0: brackettiles,x = $00
	lda.b #$00						;clear
	sta.l brackettiles,x			;plane 1
.4x:								; if 3,s & $04 = 0 go to .t1xxxxxxxx, ...
	txa
	clc
	adc.b #$0F						;plane 2 of the row
	tax
	lda.b 3,s
	and.b #$04						;bit 2?
	beq .t1xxxxxxxx
	lda.b #$7F						;solid
	sta.l brackettiles,x
	bra .5x

.t1xxxxxxxx:						; 3,s & $04 = 0: brackettiles,x = $00
	lda.b #$00						;clear
	sta.l brackettiles,x			;plane 2
.5x:								; X + 1, if 3,s & $08 = 0 go to .t1xxxxxxxxx, ...
	inx
	lda.b 3,s
	and.b #$08						;bit 3?
	beq .t1xxxxxxxxx
	lda.b #$7F						;solid
	sta.l brackettiles,x
	bra .6x

.t1xxxxxxxxx:						; 3,s & $08 = 0: brackettiles,x = $00
	lda.b #$00						;clear
	sta.l brackettiles,x			;plane 3
.6x:								; 3,s = r0, X + 1, X + 1, ...
	lda.b r0						;the pattern
	sta.b 3,s						;for the other rows
	plx
	inx
	inx
	dey
	bpl .2xx						;all 8
	pla
	rts
.7x:								;same, but solid in every plane
	lda.b #$01
	pha								; 3,s = the bit mask byte (above the pushed x)
	ldy.w #$0007
.1xxx:								; if 3,s & $01 = 0 go to .t1xxxxxxxxxx, ...
	phx
	lda.b 3,s
	and.b #$01
	beq .t1xxxxxxxxxx
	lda.b #$FF						;solid
	sta.l brackettiles,x			;plane 0
	bra .2xxx

.t1xxxxxxxxxx:						; 3,s & $01 = 0: brackettiles,x = $00
	lda.b #$00						;clear
	sta.l brackettiles,x			;plane 0
.2xxx:								; X + 1, if 3,s & $02 = 0 go to .t1xxxxxxxxxxx, ...
	inx
	lda.b 3,s
	and.b #$02
	beq .t1xxxxxxxxxxx
	lda.b #$FF						;solid
	sta.l brackettiles,x			;plane 1
	bra .3xxx

.t1xxxxxxxxxxx:						; 3,s & $02 = 0: brackettiles,x = $00
	lda.b #$00
	sta.l brackettiles,x			;plane 1
.3xxx:								; if 3,s & $04 = 0 go to .t1xxxxxxxxxxxx, ...
	txa								;plus 15
	clc
	adc.b #$0F
	tax
	lda.b 3,s
	and.b #$04
	beq .t1xxxxxxxxxxxx
	lda.b #$FF						;solid
	sta.l brackettiles,x
	bra .4xx

.t1xxxxxxxxxxxx:					; 3,s & $04 = 0: brackettiles,x = $00
	lda.b #$00
	sta.l brackettiles,x			;plane 2
.4xx:								; X + 1, if 3,s & $08 = 0 go to .t1xxxxxxxxxxxxx, ...
	inx
	lda.b 3,s
	and.b #$08
	beq .t1xxxxxxxxxxxxx
	lda.b #$FF						;solid
	sta.l brackettiles,x
	bra .5xx

.t1xxxxxxxxxxxxx:					; 3,s & $08 = 0: brackettiles,x = $00
	lda.b #$00
	sta.l brackettiles,x			;plane 3
.5xx:								; 3,s = r0, X + 1, X + 1, ...
	lda.b r0						;the pattern
	sta.b 3,s						;for the other rows
	plx
	inx
	inx
	dey
	bpl .1xxx						;all 8
	pla
	rts
.10:								;per round: offsets, then team slots (column, row), bracket pieces and the
									;cup position
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
