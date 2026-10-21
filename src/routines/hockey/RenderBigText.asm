; Draw string [p0] in the big proportional font: letter tiles into bigtextbuf from tile bigtextchar, centred
; in $24 pixels from printx, with the jmlvector hook placing each letter on the map
RenderBigText:						; called from DrawSelectTeam, PlayoffScreen
	phb
	phk								; data bank = program bank
	plb
	lda.w #hlsavebuf>>16			;source of the letter graphics
	sta.b p1+2
	lda.w #hlsavebuf
	sta.b p1
	jsr.w .9						;string width in pixels
	lsr a							;half
	eor.w #$FFFF					; negate: two's complement
	inc a							;minus half
	clc
	adc.w #$0024					;plus 36 pixels: left edge of the text
	sta.b r3						;r3 = pixel position
	lsr a							;/8
	lsr a
	lsr a
	sta.b r3+2						;in tiles
	clc
	adc.w printx					;plus the start column
	sta.w printx					;first column
	lda.b r3+2						;tiles
	asl a							;x8
	asl a
	asl a
	eor.w #$FFFF					;minus
	inc a
	clc
	adc.b r3						;pixel position mod 8
	sta.b r3						;r3 = shift into the tile
	ldy.w #$0000
.1:									;next character
	lda.b r3
	asl a							;x2
	sta.b r0+2						;word shift index for the .8 masks
	lda.b [p0],y					;character
	and.w #$00FF
	bne .t2							;not the end
	lda.w #$FFFF					;end marker
	sta.b r2						;r2 = -1
	jmp.w .4						;flush the last tile

.t2:								;map the character to a letter index
	cmp.w #$0020					;space?
	beq .2							;yes: kept as $20
	cmp.w #$002E					;period?
	bne .t1
	lda.w #$001A					;letter $1A
	bra .2

.t1:								; and #$00DF, sbc #$0041
	and.w #$00DF					;upper case
	sec
	sbc.w #$0041					;A = 0
.2:									; r2 = A, if not zero go to .t1x, ...
	phy								;save the string index
	sta.b r2						;r2 = letter index
	cmp.w #$0020					;space?
	bne .t1x						;no: draw it
	lda.w #$0005					;5 pixels wide
	bra .3

.t1x:								;OR the letter's top and bottom tiles into the current tile pair
	lda.b r2						;letter
	asl a							;x2
	tax
	lda.l BigLetterMap+6,x			;top tile of the letter
	asl a							;x32
	asl a
	asl a
	asl a
	asl a							;bytes
	sta.b r1						;source offset
	sta.b r1+2						;also kept for the spill
	lda.l bigtextchar				;current tile
	jsr.w .10						;shift it in
	lda.b r2						;letter
	asl a							;x2
	clc
	adc.w #$0036					;plus 27 letters: bottom tile
	tax
	lda.l BigLetterMap+6,x			;bottom tile of the letter
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b r1						;source offset
	lda.l bigtextchar				;current tile
	inc a							;+1: bottom tile
	jsr.w .10						;shift it in
	ldx.b r2
	lda.l LetterWidths,x			;pixel width
	and.w #$00FF
.3:									;advance the pixel position
	clc
	adc.b r3						;plus the shift
	cmp.w #$0008					;past the tile?
	bcc .5							;no: next char
.4:									; call jmlvector, increment printx, r1 = r1+2, ...
	jsl.l jmlvector					;place the tile pair on the map (hook)
	inc.w printx					;next column
	lda.b r1+2						;top spill source
	sta.b r1
	lda.l bigtextchar				;tile pair
	inc a
	inc a							;next pair
	sta.l bigtextchar
	lda.b r2						;letter
	bmi .7							;end: done
	cmp.w #$0020					;space?
	beq .5							;nothing spills
	lda.b r3						;shift
	eor.w #$0007					;7 - shift
	sta.b r3+2						;left shift count
	asl a							;x2
	sta.b r2+2						;word mask index
	lda.l bigtextchar				;new top tile
	jsr.w .11						;spill the rest of the letter into it
	lda.b r2						;letter
	asl a							;x2
	clc
	adc.w #$0036					;bottom tile
	tax
	lda.l BigLetterMap+6,x			;bottom tile of the letter
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b r1						;source offset
	lda.l bigtextchar
	inc a							;new bottom tile
	jsr.w .11						;spill
.5:									; if r2 != $0020 go to .t1xx, ...
	ldx.b r2						;letter
	cmp.w #$0020					;space?
	bne .t1xx
	lda.w #$0005					;5 pixels
	bra .6

.t1xx:								; r2 != $0020: falls through
	lda.l LetterWidths,x			;pixel width
	and.w #$00FF
.6:									; adc r3, and #$0007, r3 = A, ...
	clc
	adc.b r3						;plus the shift
	and.w #$0007					;mod 8
	sta.b r3						;new shift
	ply								;string index
	iny
	jmp.w .1
.7:									; r2 negative: return
	plb								;end of string
	rtl
.8:									;.8: right-shift masks per shift (pairs), then .8+16 left-shift masks
	db $FE,$FE,$FC,$FC,$F8,$F8,$F0,$F0,$E0,$E0,$C0,$C0,$80,$80,$00,$00
	db $FF,$FF,$7F,$7F,$3F,$3F,$1F,$1F,$0F,$0F,$07,$07,$03,$03,$01,$01
.9:									;.9: return A = width of string [p0] in pixels
	stz.b r3						;width 0
	ldy.w #$0000
.1x:								; if [p0],y & $00FF = 0 go to .5x, ...
	lda.b [p0],y					;character
	and.w #$00FF
	beq .5x							;end
	cmp.w #$0020					;space?
	bne .t3							;no
	cpy.w #$0000					;first character?
	beq .4x							;yes: leading space has no width
	lda.w #$0005					;5 pixels
	bra .3x

.t3:								; if not zero go to .t1xxx, ...
	cmp.w #$002E					;period?
	bne .t1xxx
	lda.w #$0003					;3 pixels
	bra .3x

.t1xxx:								; if not zero go to .t2x, ...
	cmp.w #$0040					;char $40?
	bne .t2x
	lda.l LetterWidths+$1B			;width of letter $1B
	and.w #$00FF
	bra .3x

.t2x:								; if carry clear go to .t1xxxx, ...
	cmp.w #$0030					;digit?
	bcc .t1xxxx
	cmp.w #$003A
	bcs .t1xxxx
	sec
	sbc.w #$0030
	clc
	adc.w #$001C
	bra .2x

.t1xxxx:							; and #$00DF, sbc #$0041
	and.w #$00DF					;upper case
	sec
	sbc.w #$0041					;A = 0
.2x:								; falls through
	tax
	lda.l LetterWidths,x			;width of the letter
	and.w #$00FF
.3x:								; adc r3, r3 = A
	clc
	adc.b r3
	sta.b r3
.4x:								;next character
	iny
	bra .1x
.5x:								; [p0],y & $00FF = 0: return
	lda.b r3						;width
	rts
.10:								;.10: OR source r1 (8 words) shifted right r3 pixels into tile A of
									;bigtextbuf
	asl a
	asl a							;x16: tile offset
	asl a
	asl a
	tax
	lda.w #$0008					;8 rows
	sta.b r0
.loop:								;each row
	ldy.b r1						;source row
	lda.b [p1],y					;its 2 bitplanes
	ldy.b r3						;shift
	beq .1xx						;none
.loop2:								; loop: lsr a, Y - 1, if Y not yet 0 go to .loop2
	lsr a							;right one pixel
	dey
	bne .loop2
.1xx:								; and .8+16,y, ora bigtextbuf,x, bigtextbuf,x = A, ...
	ldy.b r0+2						;mask index
	and.w .8+16,y					;keep the visible part
	ora.l bigtextbuf,x				;merge into the tile
	sta.l bigtextbuf,x
	inx
	inx
	inc.b r1						;next source row
	inc.b r1
	dec.b r0						;rows left
	bne .loop
	rts
.11:								;.11: store source r1 shifted left (8 - r3) pixels into tile A (spill
									;part)
	asl a
	asl a							;x16: tile offset
	asl a
	asl a
	tax
	lda.w #$0008					;8 rows
	sta.b r0
.loopx:								; loop: Y + 1
	ldy.b r1						;source row
	lda.b [p1],y					;its 2 bitplanes
	ldy.b r3+2						;left shift count
	iny
.loop2x:							; loop: asl a, Y - 1, if Y not yet 0 go to .loop2x, ...
	asl a							;left one pixel
	dey
	bne .loop2x
	ldy.b r2+2						;mask index
	and.w .8,y						;keep the spill part
	sta.l bigtextbuf,x				;new tile
	inx
	inx
	inc.b r1
	inc.b r1						;next source row
	dec.b r0
	bne .loopx						;rows left
	rts
; jmlvector letter hook of PlayoffScreen: put letter tile bigtextchar (two rows) at printx / printy of the
; screenmap2 map
BigLetterPlayoff:					; called from PlayoffScreen
	lda.w printy
	asl a							;row
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx					;plus column
	asl a							;word offset
	tax
	lda.l bigtextchar				;top tile
	ora.w #$2000					;priority
	ora.w printa					;plus the palette
	sta.l screenmap2+6,x			;top
	inc a							;bottom tile
	sta.l screenmap2+$106,x			;below
	rtl
; jmlvector letter hook of DrawSelectTeam: put letter tile bigtextchar (two rows) at printx / printy of the
; screenmap map
BigLetterSelect:					; called from DrawSelectTeam
	lda.w printy					;row
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx					;plus column
	asl a							;word offset
	tax
	lda.l bigtextchar				;top tile
	ora.w #$2000					;priority
	ora.w #$0400					;palette 1
	sta.l screenmap+$C,x			;top
	inc a							;bottom tile
	sta.l screenmap+$4C,x			;below
	rtl
