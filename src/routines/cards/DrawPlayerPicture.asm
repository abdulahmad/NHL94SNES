; Draw the picture of player A of team a2 (PlayerPhotoTable) at x, y
; Takes: A = roster index of the player, a2 = team, X/Y = map position (column, row) of the picture.
; Decompresses the photo (PlayerPhotoTable, 26 players per team), converts it to planar tiles in the
; buffer of the card side (homepicaddr / vispicaddr), pastes the photo map into the text map (mirrored for
; some players) and sets the palette. With matchupphotos set the photos come from LoadMatchupPhotos instead.
; Called from DrawPlayerCard.
DrawPlayerPicture:					; draw the picture of a player
	sta.b d0						; d0 = roster index
	lda.l matchupphotos				; matchup photo mode?
	beq .t1
	jmp.w .10						; yes: use the matchup photos

.t1:								; player photo from the table
	phy								; save Y (row)
	phx								; save X (column)
	lda.b a2						; which team?
	beq .t2
	lda.w #$2400					; visitors: tile attribute $2400
	sta.w picattr
	bra .1

.t2:								; home team: tile attribute $3400
	lda.w #$3400
	sta.w picattr
.1:									; picture attribute chosen
	lda.b d0						; roster index
	ldy.b a2						; team
	sta.b d0
	lda.w HomeTeam,y				; home team number
	ldx.w #$001A					; 26 players per team
	jsl.l Mul8U						; team * 26
	clc
	adc.b d0						; plus the player: photo number
	asl a							; four bytes per entry
	asl a
	tax
	lda.l PlayerPhotoTable,x		; pointer to the compressed photo
	sta.b p0
	lda.l PlayerPhotoTable+2,x
	sta.b p0+2
	lda.w #unpackbuf>>16			; decompress to the work buffer
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; decompress it
	stx.b r0						; keep X returned by Decompress
	lda.b a2						; picture slot: visitors $6900, home $6F00
	beq .t1x
	lda.w #$6900					; visitors picture buffer
	sta.b p1
	sta.l vispicaddr
	bra .2

.t1x:								; home team
	lda.w #$6F00
	sta.b p1
	sta.l homepicaddr
.2:									; convert the photo to planar tiles
	lda.w #unpackbuf>>16			; from the work buffer
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	jsl.l LinearToPlanar			; convert
	jsl.l .6						; mirrored or not?
	bne .t1xx						; nonzero: mirrored paste
	lda.w #PhotoMap>>16				; plain paste of the photo map into the text map
	sta.b p0+2
	lda.w #PhotoMap
	sta.b p0
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.w #$0020					; map width 32
	sta.b r7
	lda.l picchars					; first picture tile plus the attribute
	clc
	adc.w picattr
	ldy.b a2
	beq .1x							; home team: no tile offset
	clc
	adc.w #$0030					; visitors tiles are $30 further on
.1x:								; tile base set
	plx								; restore column
	ply								; restore row
	jsl.l PasteMap					; paste the map
	bra .3							; go set the colours

.t1xx:								; mirrored paste
	lda.w #PhotoMap>>16
	sta.b p0+2
	lda.w #PhotoMap
	sta.b p0
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.w #$0020					; map width 32
	sta.b r7
	lda.l picchars					; first picture tile plus the attribute
	clc
	adc.w picattr
	ldy.b a2
	beq .1xx						; home team: no tile offset
	clc
	adc.w #$0030					; visitors tiles are $30 further on
.1xx:								; tile base set
	plx								; restore column
	ply								; restore row
	jsl.l .5						; paste the map mirrored
.3:									; palette of the team
	ldy.b a2
	lda.w HomeTeam,y				; home team number
	asl a							; four bytes per entry
	asl a
	clc
	adc.w #PhotoPaletteTable		; palette pointer table
	sta.b a1
	lda.w #PhotoPaletteTable>>16
	sta.b a1+2
	lda.b [a1]						; pointer to the palette
	sta.b p0
	inc.b a1
	inc.b a1
	lda.b [a1]
	sta.b p0+2
	lda.b a2						; visitors?
	beq .t1xxx
	ldy.w #$0010					; visitors: palette slot $10
	bra .4

.t1xxx:								; home team palette
	ldy.w #$0050					; home: palette slot $50
.4:									; palette slot chosen
	ldx.w #$0010					; 16 colours
	jsl.l SetColours				; set the colours
	rtl								; return
.5:									; mirrored paste: A tile base, X column, Y row
	sta.b r7+2						; keep the base tile
	lda.b p1+2
	sta.b r3+2						; text map bank
	stx.b r5						; column
	tya								; row
	asl a							; row * 2
	ldx.b r7						; map width
	jsl.l Mul16U					; row * width
	lda.b r5						; column
	asl a							; *2 bytes
	clc
	adc.b r2
	adc.b p1						; text map address of the first tile
	sta.b p1
	ldy.w #$0000
	lda.b [p0],y					; map size: width
	sta.b r4
	iny								; and height
	iny
	lda.b [p0],y
	sta.b r4+2
	lda.b p0						; skip the map header
	clc
	adc.w #$0006
	sta.b p0
.loop:								; each row of the map
	ldx.b r4						; width
	ldy.w #$0000
.loop2:								; each tile of the row, filled from the right
	tya								; write position from the right edge
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.b r4
	dec a							; width - 1 - tile
	asl a							; *2 bytes
	adc.b p1
	sta.b r3						; address in the text map
	lda.b [p0],y
	clc								; map entry
	adc.b r7+2						; plus the base tile
	ora.w #$4000					; set the horizontal flip bit
	sta.b [r3]						; store it
	iny
	iny
	dex
	bne .loop2						; next tile
	lda.b r7						; next row
	asl a
	adc.b p1
	sta.b p1
	lda.b r4						; step to the next map row
	asl a
	adc.b p0
	sta.b p0
	dec.b r4+2						; height
	bne .loop						; next row
	rtl								; return
.6:									; decide whether the picture is mirrored (A nonzero = mirrored)
	jsl.l .9						; is the player one of the six line slots?
	beq .1xxx						; yes: not mirrored
	jsl.l .7						; rating parity of the player
	sta.b r3
	jsl.l .8						; goalie or skater
	bne .t1xxxx						; goalie: flip the parity
	lda.b r3						; skater: parity as it is
	rtl								; return

.t1xxxx:							; goalie: invert it
	lda.b r3
	eor.w #$0001					; invert it
.1xxx:								; return
	rtl								; return
.7:									; parity of the player rating (bit 0)
	jsl.l .8						; goalie or skater?
	bne .t1xxxxx					; skater
	lda.w #$0005					; rating column 5 for skaters
	sta.b d1
	bra .1xxxx						; go

.t1xxxxx:							; goalies
	lda.w #$0004					; rating column 4 for goalies
	sta.b d1
.1xxxx:								; rating column chosen
	jsl.l GetPlayerRating			; rating of the player
	lda.b d0
	and.w #$0001					; bit 0 only
	rtl								; return
.8:									; goalie (1) or skater (0)?
	lda.w #AttribMenuSkater>>16		; attribute menu of the skaters
	sta.b a1+2
	lda.w #AttribMenuSkater
	sta.b a1
	stz.b r2
	jsl.l GoalieCount				; number of goalies
	lda.w curplayer					; current player
	cmp.b d0
	bpl .t1xxxxxx					; not a goalie: 0
	lda.w #$0001					; goalie
	rtl

.t1xxxxxx:							; skater
	lda.w #$0000
	rtl								; return
.9:									; is the player one of the six line slots? (A = 0 yes, 1 no)
	ldy.b a2						; team
	lda.w #TeamList>>16				; team data bank
	sta.b a3+2
	lda.w tmdata,y
	sta.b a3
	ldy.w #$000C					; offset 12: the six line slots
	clc
	adc.b [a3],y
	sta.b a3
	ldy.w #$0005					; check 6 slots
.loopx:								; each slot in turn
	lda.b [a3],y					; slot entry
	and.w #$00FF
	dec a							; roster index - 1
	cmp.w curplayer
	beq .t1xxxxxxx					; found: A = 0
	dey								; next slot
	bpl .loopx
	lda.w #$0001					; not found: A = 1
	rtl

.t1xxxxxxx:							; found
	lda.w #$0000
	rtl
.10:								; matchup photos
	phy								; save Y (row)
	phx								; save X (column)
	ldx.b a2						; team
	jsl.l LoadMatchupPhotos			; load the matchup photos
	lda.b d0						; matchup photo number
	asl a							; two bytes per entry
	tax
	lda.b a2						; which team?
	beq .t1xxxxxxxx
	lda.w #$2400					; visitors: attribute $2400
	sta.w picattr
	lda.w #$2D00
	clc								; visitors buffer $2D00 plus the photo offset
	adc.l MatchupPhotoOffsets,x
	sta.l vispicaddr				; store as the visitors address
	bra .2x

.t1xxxxxxxx:						; home team
	lda.w #$3400					; home team: attribute $3400
	sta.w picattr
	lda.w #$5100					; home buffer $5100 plus the photo offset
	clc
	adc.l MatchupPhotoOffsets,x
	sta.l homepicaddr				; store as the home address
.2x:								; paste the photo map
	lda.w #PhotoMap>>16
	sta.b p0+2
	lda.w #PhotoMap
	sta.b p0
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.w #$0020					; map width 32
	sta.b r7
	lda.l picchars					; first picture tile plus the attribute
	clc
	adc.w picattr
	ldy.b a2
	beq .1xxxxx						; home team: no tile offset
	clc
	adc.w #$0030					; visitors tiles are $30 further on
.1xxxxx:							; tile base set
	plx								; restore column
	ply								; restore row
	jsl.l PasteMap					; paste the map
	ldy.b a2						; palette of the team
	lda.w HomeTeam,y				; home team number
	asl a							; four bytes per entry
	asl a
	clc
	adc.w #PhotoPaletteTable		; palette pointer table
	sta.b a1
	lda.w #PhotoPaletteTable>>16
	sta.b a1+2
	lda.b [a1]						; pointer to the palette
	sta.b p0
	inc.b a1
	inc.b a1
	lda.b [a1]
	sta.b p0+2
	lda.b a2						; visitors?
	beq .t1xxxxxxxxx
	ldy.w #$0010					; visitors: palette slot $10
	bra .3x

.t1xxxxxxxxx:						; home team palette
	ldy.w #$0050					; home: palette slot $50
.3x:								; palette slot chosen
	ldx.w #$0010					; 16 colours
	jsl.l SetColours				; set the colours
	rtl								; return
