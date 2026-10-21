; Draw string [p0] in the big proportional font: letter tiles into bigtextbuf from tile bigtextchar, centred
; in $24 pixels from printx, with the jmlvector hook placing each letter on the map
RenderBigText:						; called from DrawSelectTeam, PlayoffScreen
	phb
	phk								; data bank = program bank
	plb
	lda.w #hlsavebuf>>16
	sta.b p1+2
	lda.w #hlsavebuf
	sta.b p1
	jsr.w .9
	lsr a
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.w #$0024
	sta.b r3
	lsr a
	lsr a
	lsr a
	sta.b r3+2
	clc
	adc.w printx
	sta.w printx
	lda.b r3+2
	asl a
	asl a
	asl a
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.b r3
	sta.b r3
	ldy.w #$0000
.1:									; r0+2 = r3 * 2, if [p0],y & $00FF != 0 go to .t2, ...
	lda.b r3
	asl a
	sta.b r0+2
	lda.b [p0],y
	and.w #$00FF
	bne .t2
	lda.w #$FFFF
	sta.b r2
	jmp.w .4

.t2:								; [p0],y & $00FF != 0: if zero go to .2, ...
	cmp.w #$0020
	beq .2
	cmp.w #$002E
	bne .t1
	lda.w #$001A
	bra .2

.t1:								; and #$00DF, sbc #$0041
	and.w #$00DF
	sec
	sbc.w #$0041
.2:									; r2 = A, if not zero go to .t1x, ...
	phy
	sta.b r2
	cmp.w #$0020
	bne .t1x
	lda.w #$0005
	bra .3

.t1x:								; r1 = BigLetterMap+6,x * 2 * 2 * 2 * 2 * 2, r1+2 = BigLetterMap+6,x *...
	lda.b r2
	asl a
	tax
	lda.l BigLetterMap+6,x
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b r1
	sta.b r1+2
	lda.l bigtextchar
	jsr.w .10
	lda.b r2
	asl a
	clc
	adc.w #$0036
	tax
	lda.l BigLetterMap+6,x
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b r1
	lda.l bigtextchar
	inc a
	jsr.w .10
	ldx.b r2
	lda.l LetterWidths,x
	and.w #$00FF
.3:									; adc r3, if carry clear go to .5
	clc
	adc.b r3
	cmp.w #$0008
	bcc .5
.4:									; call jmlvector, increment printx, r1 = r1+2, ...
	jsl.l jmlvector
	inc.w printx
	lda.b r1+2
	sta.b r1
	lda.l bigtextchar
	inc a
	inc a
	sta.l bigtextchar
	lda.b r2
	bmi .7
	cmp.w #$0020
	beq .5
	lda.b r3
	eor.w #$0007
	sta.b r3+2
	asl a
	sta.b r2+2
	lda.l bigtextchar
	jsr.w .11
	lda.b r2
	asl a
	clc
	adc.w #$0036
	tax
	lda.l BigLetterMap+6,x
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b r1
	lda.l bigtextchar
	inc a
	jsr.w .11
.5:									; if r2 != $0020 go to .t1xx, ...
	ldx.b r2
	cmp.w #$0020
	bne .t1xx
	lda.w #$0005
	bra .6

.t1xx:								; r2 != $0020: falls through
	lda.l LetterWidths,x
	and.w #$00FF
.6:									; adc r3, and #$0007, r3 = A, ...
	clc
	adc.b r3
	and.w #$0007
	sta.b r3
	ply
	iny
	jmp.w .1
.7:									; r2 negative: return
	plb
	rtl
.8:									; db $FE,$FE,$FC,$FC,$F8,$F8,$F0,$F0,$E0,$E0,$C0,$C0,$80,$80,$00,$00, ...
	db $FE,$FE,$FC,$FC,$F8,$F8,$F0,$F0,$E0,$E0,$C0,$C0,$80,$80,$00,$00
	db $FF,$FF,$7F,$7F,$3F,$3F,$1F,$1F,$0F,$0F,$07,$07,$03,$03,$01,$01
.9:									; subroutine: r3 = 0
	stz.b r3
	ldy.w #$0000
.1x:								; if [p0],y & $00FF = 0 go to .5x, ...
	lda.b [p0],y
	and.w #$00FF
	beq .5x
	cmp.w #$0020
	bne .t3
	cpy.w #$0000
	beq .4x
	lda.w #$0005
	bra .3x

.t3:								; if not zero go to .t1xxx, ...
	cmp.w #$002E
	bne .t1xxx
	lda.w #$0003
	bra .3x

.t1xxx:								; if not zero go to .t2x, ...
	cmp.w #$0040
	bne .t2x
	lda.l LetterWidths+$1B
	and.w #$00FF
	bra .3x

.t2x:								; if carry clear go to .t1xxxx, ...
	cmp.w #$0030
	bcc .t1xxxx
	cmp.w #$003A
	bcs .t1xxxx
	sec
	sbc.w #$0030
	clc
	adc.w #$001C
	bra .2x

.t1xxxx:							; and #$00DF, sbc #$0041
	and.w #$00DF
	sec
	sbc.w #$0041
.2x:								; falls through
	tax
	lda.l LetterWidths,x
	and.w #$00FF
.3x:								; adc r3, r3 = A
	clc
	adc.b r3
	sta.b r3
.4x:								; Y + 1, go to .1x
	iny
	bra .1x
.5x:								; [p0],y & $00FF = 0: return
	lda.b r3
	rts
.10:								; subroutine: asl a, asl a, asl a, ...
	asl a
	asl a
	asl a
	asl a
	tax
	lda.w #$0008
	sta.b r0
.loop:								; loop: if r3 = 0 go to .1xx
	ldy.b r1
	lda.b [p1],y
	ldy.b r3
	beq .1xx
.loop2:								; loop: lsr a, Y - 1, if Y not yet 0 go to .loop2
	lsr a
	dey
	bne .loop2
.1xx:								; and .8+16,y, ora bigtextbuf,x, bigtextbuf,x = A, ...
	ldy.b r0+2
	and.w .8+16,y
	ora.l bigtextbuf,x
	sta.l bigtextbuf,x
	inx
	inx
	inc.b r1
	inc.b r1
	dec.b r0
	bne .loop
	rts
.11:								; subroutine: asl a, asl a, asl a, ...
	asl a
	asl a
	asl a
	asl a
	tax
	lda.w #$0008
	sta.b r0
.loopx:								; loop: Y + 1
	ldy.b r1
	lda.b [p1],y
	ldy.b r3+2
	iny
.loop2x:							; loop: asl a, Y - 1, if Y not yet 0 go to .loop2x, ...
	asl a
	dey
	bne .loop2x
	ldy.b r2+2
	and.w .8,y
	sta.l bigtextbuf,x
	inx
	inx
	inc.b r1
	inc.b r1
	dec.b r0
	bne .loopx
	rts
; jmlvector letter hook of PlayoffScreen: put letter tile bigtextchar (two rows) at printx / printy of the
; $7EC67C map
BigLetterPlayoff:					; called from PlayoffScreen
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
	lda.l bigtextchar
	ora.w #$2000
	ora.w printa
	sta.l screenmap2+6,x
	inc a
	sta.l screenmap2+$106,x
	rtl
; jmlvector letter hook of DrawSelectTeam: put letter tile bigtextchar (two rows) at printx / printy of the
; $7EA67C map
BigLetterSelect:					; called from DrawSelectTeam
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	tax
	lda.l bigtextchar
	ora.w #$2000
	ora.w #$0400
	sta.l screenmap+$C,x
	inc a
	sta.l screenmap+$4C,x
	rtl
