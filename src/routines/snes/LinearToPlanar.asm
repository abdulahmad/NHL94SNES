; convert $00 bytes of linear 4bpp tiles at [p0] to SNES planar, in place
LinearToPlanar:						; called from DrawPlayerPicture, LoadCenterIce, LoadMatchupPhotos, Load...
	ldx.b r0
	phb
	sep #$20
	lda.b p0+2
	pha
	rep #$20
	plb
	stz.b r1
	lda.w #$FFFE
	sta.b r1+2
	lda.b r0
	lsr a
	lsr a
	sta.b r0
	bra .2
.1:									; (p0),y = 0: if zero go to .6, ...
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	beq .6
	tax
	iny
	iny
	bra .5
.2:									; r3 = 0, r3+2 = 0
	ldx.w #$0080
	stz.b r3
	stz.b r3+2
	lda.b r1
	asl a
	asl a
	tay
.5:									; loop: if (p0),y = 0 go to .1, ...
	lda.b (p0),y
	beq .1
	xba
	tay
.loop:								; loop: if carry clear go to .1x, ...
	tya
	asl a
	bcc .1x
	tay
	txa
	tsb.b r3+1
	tya
.1x:								; asl a, if carry clear go to .2x, ...
	asl a
	bcc .2x
	tay
	txa
	tsb.b r3
	tya
.2x:								; asl a, if carry clear go to .3, ...
	asl a
	bcc .3
	tay
	txa
	tsb.b r3+3
	tya
.3:									; asl a, if carry clear go to .4, ...
	asl a
	bcc .4
	tay
	txa
	tsb.b r3+2
	tya
.4:									; if carry set go to .loop, ...
	tay
	txa
	lsr a
	tax
	cpx.w #$0010
	bcs .loop
	cpx.w #$0000
	beq .6
	cpx.w #$0008
	bcc .loop
	lda.b r1
	asl a
	asl a
	tay
	iny
	iny
	bra .5
.6:									; if zero go to .1xx, ...
	lda.b r1+2
	inc a
	inc a
	tay
	and.w #$0010
	beq .1xx
	tya
	clc
	adc.w #$0010
	tay
.1xx:								; r1+2 = Y, (p1),y = r3+2, (p1),y = r3, ...
	sty.b r1+2
	lda.b r3+2
	sta.b (p1),y
	tya
	clc
	adc.w #$0010
	tay
	lda.b r3
	sta.b (p1),y
	inc.b r1
	dec.b r0
	bpl .2
	plb
	rtl
