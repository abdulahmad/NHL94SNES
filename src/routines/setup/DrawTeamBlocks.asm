; Draw team d1's block at printx / printy: its name as letter sprites (PrintTeamSprites) and its logo map (2
; rows of 9 words) in its palette
;
; Takes d1 = team number, printx / printy = position in tiles. Returns nothing, X and a2 are kept. Called
; from TeamRoster, setoptions, ShowMatchups and ShowGameStats.
DrawTeamBlocks:						; entry: the block of team d1
	lda.b a2						; keep a2
	pha								; save a2 and X
	phx								; keep X
	lda.w printx					; X = printx * 8 + $24: pixel X of the name
	asl a
	asl a
	asl a
	clc
	adc.w #$0024
	tax
	lda.l cardblock
	beq .1							; card block (player card) draws 8 pixels further left
	txa
	sec
	sbc.w #$0008
	tax
.1:									; name X is final
	lda.w printy					; Y = printy * 8 + 3: pixel Y of the name
	asl a
	asl a
	asl a
	inc a
	inc a
	inc a
	tay
	lda.l pausesubmenu				; pause sub menu or card block: move the name 4 pixels right and down
	bne .t1
	lda.l cardblock
	bne .t1
	bra .2

.t1:								; shift the name for the pause menu / card
	inx								; name moved 4 right
	inx
	inx
	inx
	iny								; and 4 down
	iny
	iny
	iny
.2:									; name position is final
	jsl.l PrintTeamSprites			; draw the team name as letter sprites
	lda.l horblocks					; horizontal block mode and no redraw:
	beq .t2
	lda.l redrawblocks
	bne .t2
	jmp.w .3						; skip the palette and the map

.t2:								; palette and map: write the block colours
	lda.w #$1800					; r3 = $1800: tile attribute of palette 6 (the visiting team)
	sta.b r3
	ldy.w #$0060					; Y = first colour of palette 6
	lda.b d1
	cmp.w HomeTeam
	bne .1x							; not the home team: keep these
	ldx.w #$1C00					; home team: tile attribute $1C00, palette 7
	stx.b r3
	ldy.w #$0070					; first colour of palette 7
.1x:								; palette index is set: load the colours for the team in A
	asl a							; A = team * 4: index into the palette pointers
	asl a
	tax
	lda.l TeamBlockPalettes+2,x		; p0 = pointer to the team block colours
	sta.b p0+2
	lda.l TeamBlockPalettes,x
	sta.b p0
	ldx.w #$0010					; 16 colours
	jsl.l SetColours				; write them into the colour buffer
	lda.w HomeTeam					; both teams the same?
	cmp.w VisTeam
	bne .t1x
	lda.b r3
	cmp.w #$1800					; and the home palette was just written:
	beq .t1x
	lda.w #$1800					; also write the visiting palette for it
	sta.b r3
	ldy.w #$0060
	lda.b d1
	bra .1x							; same team again, with palette 6

.t1x:								; write the logo map into the text map
	ldy.w #$0000					; Y = offset into the logo map
	lda.w #TeamBlocksmap>>16		; a2 = TeamBlocksmap, past its 6 byte header
	sta.b a2+2
	lda.w #TeamBlocksmap+6
	sta.b a2
	lda.w printy					; X = (printy * 32 + printx) * 2 + printm: byte offset in the text map
	asl a							; times 32
	asl a
	asl a
	asl a
	asl a
	adc.w printx					; plus print x
	asl a							; word offset
	adc.w printm
	tax
	lda.w #$0009					; 9 tiles per row, 2 rows
	sta.b tmp0
	sta.b tmp1
.loop:								; first row of the logo
	lda.b [a2],y					; map tile
	clc								; plus the scoreboard tile base
	adc.l scorechars
	clc								; plus the print font base
	adc.l printfontset
	clc								; plus the palette attribute
	adc.b r3
	sta.l textmap,x					; store in the text map
	iny								; next tile
	iny
	inx								; next text word
	inx
	dec.b tmp0						; next tile
	bne .loop
.loop2:								; second row of the logo (one text map row of $40 bytes below)
	lda.b [a2],y
	clc
	adc.l scorechars
	clc
	adc.l printfontset
	clc
	adc.b r3
	sta.l textmap+(23*2),x			; second row sits $2E bytes on (past the 9 words just stored)
	iny
	iny
	inx
	inx
	dec.b tmp1						; row done?
	bne .loop2
.3:									; restore X and a2
	plx								; restore X
	pla								; restore a2
	sta.b a2
	rtl
