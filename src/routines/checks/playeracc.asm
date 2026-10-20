; Accelerate player X in direction d2, up to his top speed
playeracc:
	asl.b d2						; 4 bytes per direction entry
	asl.b d2
	ldx.b d2
	lda.l .8+2,x
	sta.b d1
	lda.l .8,x
	sta.b d0
	ldx.b curobj
	lda.w Wallsin,x
	beq .1
	eor.b d0
	bpl .1
	stz.b d0
.1:
	lda.w Wallcos,x
	beq .2
	eor.b d1
	bmi .2
	stz.b d1
.2:
	lda.w weight,x
	lsr a
	lsr a
	lsr a
	eor.w #$FFFF					; negate
	inc a
	clc
	adc.w #$0020
	clc
	adc.w legstr,x					; plus leg strength
	sta.b d2
	lda.w legstr,x
	lsr a
	adc.b d2
	sta.b d2
	lda.w position,x
	bne .7
	lda.w playerpad,x
	bmi .t1
	cpx.w puckc
	beq .t1
	lda.w legstr,x
	asl a
	adc.b d2
	adc.w #$0008
	sta.b d2
	bra .7

.t1:
	lda.b d2
	ldy.w passReceiverPlayerNum
	bmi .1x
	sec
	sbc.w legstr,x
.1x:
	clc
	adc.w #$0008
	sta.b d2
.7:
	lda.b d2
	pha
	ldx.b d0
	jsl.l Mul8XS
	tax
	lda.b d7
	jsl.l Mul16x8XS
	ldx.b curobj
	lda.b r2
	adc.w Xvel,x
	sta.b d0
	xba
	and.w #$00FF
	cmp.w #$0080
	bcc .1xx
	ora.w #$FF00
.1xx:
	tax
	jsl.l Mul8S
	sta.b d3
	pla
	ldx.b d1
	jsl.l Mul8XS
	tax
	lda.b d7
	jsl.l Mul16x8XS
	ldx.b curobj
	lda.b r2
	adc.w Yvel,x
	sta.b d1
	xba
	and.w #$00FF
	cmp.w #$0080
	bcc .2x
	ora.w #$FF00
.2x:
	tax
	jsl.l Mul8S
	clc
	adc.b d3
	sta.b d3
	lda.b d1
	pha
	lda.b d0
	pha
	ldx.b curobj
	jsl.l getpde
	lda.w legspd,x
	pha
	lda.l OptLine
	cmp.w #$0002
	bne .3
	lda.w #$1000
	sta.b d0
.3:
	lda.b d0
	lsr a
	clc
	adc.w #$0800
	tax
	pla
	asl a
	asl a
	asl a
	asl a
	jsl.l Mul16x8U
	lda.b r2+2
	asl a
	asl a
	tax
	lda.l MaxSpeed,x				; max speed squared for the rating level
	sta.b d2
	lda.l MaxSpeed+2,x
	sta.b d2+2
	ldx.b curobj
	lda.w position,x
	bne .4
	lda.w playerpad,x
	bmi .4
	lda.w goalieflags,x
	bit.w #$0004
	bne .4
	lda.b d2+2
	lsr a
	lsr a
	eor.w #$FFFF
	inc a
	adc.b d2+2
	sta.b d2+2
.4:
	pla
	sta.b d0
	pla
	sta.b d1
	lda.b d2+2
	cmp.b d3
	bcc .5
	lda.b d0
	sta.w Xvel,x					; store the new velocity
	lda.b d1
	sta.w Yvel,x
.5:
	lda.l OptLine
	beq .t1x
	lda.w seed
	and.w #$003F
	bne .t1x
	jsl.l getpde
	lda.b d0
	sec
	sbc.w #$0021					; lower the energy by 33
	sta.b d0
	cmp.w #$0C00
	bmi .6
	lda.w endurance,x				; above $C00: also add the endurance byte
	sta.b d2
	clc
	adc.b d0
	sta.b d0
.6:
	jml.l setpde

.t1x:
	rtl
.8:									; x and y steps (words) for eight directions
	dw $0000,$0006,$0004,$0004,$0006,$0000,$0004,$FFFC
	dw $0000,$FFFA,$FFFC,$FFFC,$FFFA,$0000,$FFFC,$0004
