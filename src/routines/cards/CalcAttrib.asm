; The overall rating of player d0 of team a2 from the attribute mask $B7, with the hot / cold table when
; $7E35F2 is set
CalcAttrib:
	lda.b d0
	asl a
	adc.b d0
	asl a
	asl a
	sta.b r0
	stz.b d0+2
	ldy.b a2
	beq .1
	lda.b r0
	clc
	adc.w #$0138
	sta.b r0
.1:
	lda.w #$009C
	sta.b a0+2
	lda.w tmdata,y
	sta.b a0
	clc
	ldy.w #$0000
	adc.b [a0],y
	sta.b a0
	dec.b d0
	bmi .2
.loop:
	lda.b a0
	clc
	adc.b [a0]
	adc.w #$0008
	sta.b a0
	dec.b d0
	bpl .loop
.2:
	lda.b [a0]
	clc
	adc.b a0
	sta.b a0
	stz.b d0
	stz.b d1
	phx
	lda.w #$0000
.11:
	sta.b d2
	asl a
	tax
	lda.l BitMaskTable,x
	bit.b d4+2
	bne .t2
	jmp.w .12

.t2:
	cpx.w #$000C
	beq .1x
	cpx.w #$001A
	bne .2x
.1x:
	inc.b d0+2
.2x:
	lda.w #$000F
	sec
	sbc.b d2
	sta.b p1
	lsr a
	clc
	adc.b a0
	sta.b p0
	lda.b a0+2
	sta.b p0+2
	lda.b [p0]
	sta.b d3
	lda.b d2
	lsr a
	bcc .3
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d3
.3:
	lda.b d3
	and.w #$000F
	sta.b d3
	lda.b p1
	dec a
	dec a
	dec a
	cmp.w #$0006
	bcc .4
	dec a
.4:
	clc
	adc.b r0
	tax
	lda.l usehotcold
	beq .5
	lda.w HotColdTable,x
	and.w #$00FF
.5:
	sta.b r3+2
	cmp.w #$0080
	bcc .6
	lda.w #$0100
	sbc.b r3+2
.6:
	sta.b r3
	asl a
	clc
	adc.b r3
	lsr a
	lsr a
	bit.w #$2000
	beq .7
	ora.w #$C000
.7:
	sta.b r3
	lda.b r3+2
	bit.w #$0080
	beq .8
	lda.w #$0000
	sec
	sbc.b r3
	sta.b r3
.8:
	lda.b d4+2
	bmi .t3
	ldx.b p1
	lda.l .19,x
	and.w #$00FF
	beq .t1
	lda.w #$0012
	ldx.b d3
	jsl.l Mul8U
	clc
	adc.b r3
	bpl .9
	lda.w #$0000
.9:
	cmp.w #$0064
	bcc .10
	lda.w #$0064
.10:
	sta.b d0
	plx
	jmp.w .17

.t1:
	lda.b d3
	sta.b d0
	plx
	jmp.w .17

.t3:
	lda.b p1
	clc
	adc.b r2
	tax
	lda.l .18,x
	ldx.b d3
	jsl.l Mul8U
	clc
	adc.b d0
	sta.b d0
	lda.b r3
	ldy.b r2
	beq .1xx
	asl a
.1xx:
	clc
	adc.b d1
	sta.b d1
.12:
	lda.b d2
	inc a
	cmp.w #$000F
	bpl .t2x
	jmp.w .11

.t2x:
	lda.b d1
	bpl .14
	eor.w #$FFFF
	inc a
	ldx.b r2
	bne .t1x
	tax
	lda.w #$000A
	bra .13

.t1x:
	tax
	lda.w #$0007
.13:
	jsl.l DivX8U
	sec
	eor.w #$FFFF
	adc.b d0
	sta.b d0
	lda.b d0
	bpl .16
	stz.b d0
	lda.w #$0000
	bra .16
.14:
	ldx.b r2
	bne .t1xx
	tax
	lda.w #$000A
	bra .15

.t1xx:
	tax
	lda.w #$0007
.15:
	jsl.l DivX8U
	clc
	adc.b d0
	sta.b d0
	lda.b d0
	bpl .16
	stz.b d0
	lda.w #$0000
.16:
	sta.b d0
	plx
	lda.b r2
	beq .17
	lsr.b d0
.17:
	lda.b d0+2
	bne .rtl
	lda.b d0
	cmp.w #$0064
	bcc .1xxx
	lda.w #$0064
.1xxx:
	cmp.w #$0032
	bcs .2xx
	lsr a
	clc
	adc.w #$0019
.2xx:
	sta.b d0
.rtl:
	rtl
.18:
	db $00,$00,$01,$02,$03,$03,$02,$01,$02,$01,$03,$02,$01,$01,$01,$01
	db $00,$00,$00,$09,$02,$02,$09,$09,$02,$02,$02,$02,$02,$02,$02,$02
.19:
	db $00,$00,$00,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01,$01,$01,$01
