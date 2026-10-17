; Draw string [p0] in the big proportional font: letter tiles into $7E4EF4 from tile $7E3466, centred in $24
; pixels from printx, with the jmlvector hook placing each letter on the map
RenderBigText:
	phb
	phk
	plb
	lda.w #hlsavebuf>>16
	sta.b p1+2
	lda.w #hlsavebuf
	sta.b p1
	jsr.w .9
	lsr a
	eor.w #$FFFF
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
	eor.w #$FFFF
	inc a
	clc
	adc.b r3
	sta.b r3
	ldy.w #$0000
.1:
	lda.b r3
	asl a
	sta.b r0+2
	lda.b [p0],y
	and.w #$00FF
	bne .t2
	lda.w #$FFFF
	sta.b r2
	jmp.w .4

.t2:
	cmp.w #$0020
	beq .2
	cmp.w #$002E
	bne .t1
	lda.w #$001A
	bra .2

.t1:
	and.w #$00DF
	sec
	sbc.w #$0041
.2:
	phy
	sta.b r2
	cmp.w #$0020
	bne .t1x
	lda.w #$0005
	bra .3

.t1x:
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
.3:
	clc
	adc.b r3
	cmp.w #$0008
	bcc .5
.4:
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
.5:
	ldx.b r2
	cmp.w #$0020
	bne .t1xx
	lda.w #$0005
	bra .6

.t1xx:
	lda.l LetterWidths,x
	and.w #$00FF
.6:
	clc
	adc.b r3
	and.w #$0007
	sta.b r3
	ply
	iny
	jmp.w .1
.7:
	plb
	rtl
.8:
	db $FE,$FE,$FC,$FC,$F8,$F8,$F0,$F0,$E0,$E0,$C0,$C0,$80,$80,$00,$00
	db $FF,$FF,$7F,$7F,$3F,$3F,$1F,$1F,$0F,$0F,$07,$07,$03,$03,$01,$01
.9:
	stz.b r3
	ldy.w #$0000
.1x:
	lda.b [p0],y
	and.w #$00FF
	beq .5x
	cmp.w #$0020
	bne .t3
	cpy.w #$0000
	beq .4x
	lda.w #$0005
	bra .3x

.t3:
	cmp.w #$002E
	bne .t1xxx
	lda.w #$0003
	bra .3x

.t1xxx:
	cmp.w #$0040
	bne .t2x
	lda.l LetterWidths+$1B
	and.w #$00FF
	bra .3x

.t2x:
	cmp.w #$0030
	bcc .t1xxxx
	cmp.w #$003A
	bcs .t1xxxx
	sec
	sbc.w #$0030
	clc
	adc.w #$001C
	bra .2x

.t1xxxx:
	and.w #$00DF
	sec
	sbc.w #$0041
.2x:
	tax
	lda.l LetterWidths,x
	and.w #$00FF
.3x:
	clc
	adc.b r3
	sta.b r3
.4x:
	iny
	bra .1x
.5x:
	lda.b r3
	rts
.10:
	asl a
	asl a
	asl a
	asl a
	tax
	lda.w #$0008
	sta.b r0
.loop:
	ldy.b r1
	lda.b [p1],y
	ldy.b r3
	beq .1xx
.loop2:
	lsr a
	dey
	bne .loop2
.1xx:
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
.11:
	asl a
	asl a
	asl a
	asl a
	tax
	lda.w #$0008
	sta.b r0
.loopx:
	ldy.b r1
	lda.b [p1],y
	ldy.b r3+2
	iny
.loop2x:
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
; jmlvector letter hook of PlayoffScreen: put letter tile $7E3466 (two rows) at printx / printy of the $7EC67C
; map
BigLetterPlayoff:
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
; jmlvector letter hook of DrawSelectTeam: put letter tile $7E3466 (two rows) at printx / printy of the
; $7EA67C map
BigLetterSelect:
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
