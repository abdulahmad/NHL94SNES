; While $7E3448 is set (not in horizontal mode or a replay): launch and move the ten hat trick sprites on
; random arcs and draw them
UpdateHatTrick:
	lda.w sfhormode
	bne .rtl
	lda.w sflags
	and.w #$0800
	bne .rtl
	lda.l hattrick
	bne .t1
.rtl:
	rtl

.t1:
	ldx.w #$0012
.1:
	stx.b d4
	lda.l hatstep,x
	beq .t3
	jmp.w .7

.t3:
	jsl.l RandomWord
	and.w #$07C0
	beq .t1x
	jmp.w .6

.t1x:
	jsl.l RandomWord
	and.w #$003F
	sta.b d0
	lsr a
	adc.b d0
	clc
	adc.w #$0050
	asl a
	asl a
	asl a
	asl a
	sta.b d0
	jsl.l RandomWord
	and.w #$003F
	clc
	adc.w #$0060
	asl a
	asl a
	asl a
	asl a
	sta.b d1
	jsl.l RandomWord
	and.w #$00FF
	asl a
	asl a
	asl a
	asl a
	sta.l haty,x
	jsl.l RandomWord
	and.w #$003F
	clc
	adc.w #$0078
	sta.b d2
	lda.b d1
	sec
	sbc.l haty,x
	tax
	lda.b d2
	jsl.l DivX8S
	ldx.b d4
	sta.l hatvy,x
	lda.b d0
	and.w #$0100
	beq .t2
	lda.w #$1100
	sta.l hatx,x
	lda.b d0
	sec
	sbc.w #$1100
	bra .2

.t2:
	lda.w #$FF00
	sta.l hatx,x
	lda.b d0
	sec
	sbc.w #$FF00
.2:
	tax
	lda.b d2
	jsl.l DivX8S
	ldx.b d4
	sta.l hatvx,x
	lda.b d2
	lsr a
	lsr a
	tax
	jsl.l Mul8U
	ldx.b d4
	sta.b d2
	asl a
	adc.b d2
	sta.l hatz,x
	jsl.l RandomWord
	lsr a
	lsr a
	and.w #$0003
	beq .1x
	dec a
.1x:
	sta.b d2
	asl a
	adc.b d2
	sta.l hatkind,x
	lda.w #$0000
	sta.l hatvz
	inc a
	sta.l hatstep,x
	lda.l .9,x
	sta.l hattimer,x
.5:
	lda.l hatkind,x
	clc
	adc.l hatstep,x
	clc
	adc.w #SPFhat-1-1				; DrawSprite index (frame - 1); the step counts from 1
	sta.b r0
	lda.w #SpriteFrames>>16
	sta.b p1+2
	lda.w #SpriteFrames
	sta.b p1
	lda.l hatz,x
	lsr a
	lsr a
	lsr a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.l haty,x
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .1xx
	ora.w #$F000
.1xx:
	tay
	lda.l hatx,x
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .2x
	ora.w #$F000
.2x:
	tax
	lda.w #$2000
	jsl.l DrawSprite
	ldx.b d4
	lda.w #SPFhatshadow-1
	sta.b r0
	lda.l haty,x
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .3
	ora.w #$F000
.3:
	tay
	lda.l hatx,x
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .4
	ora.w #$F000
.4:
	tax
	lda.w #$2000
	jsl.l DrawSprite
.6:
	ldx.b d4
	dex
	dex
	bmi .t1xx
	jmp.w .1

.t1xx:
	rtl
.7:
	lda.l hattimer,x
	sec
	sbc.w timestep
	bpl .t1xxx
	clc
	adc.l .9,x
	sta.l hattimer,x
	lda.l hatstep,x
	inc a
	cmp.w #$0004
	bne .1xxx
	lda.w #$0001
.1xxx:
	sta.l hatstep,x
	bra .8

.t1xxx:
	sta.l hattimer,x
.8:
	ldy.w timestep
	beq .1xxxx
.loop:
	jsl.l .t3x
	dey
	bne .loop
.1xxxx:
	jmp.w .5

.t3x:
	lda.l hatvx,x
	ora.l hatvy,x
	beq .rtlx
	lda.l hatx,x
	clc
	adc.l hatvx,x
	sta.l hatx,x
	lda.l haty,x
	clc
	adc.l hatvy,x
	sta.l haty,x
	lda.l hatz,x
	beq .t2x
	lda.l hatvz,x
	lsr a
	lsr a
	bit.w #$2000
	beq .1xxxxx
	ora.w #$C000
.1xxxxx:
	eor.w #$FFFF
	inc a
	clc
	adc.l hatz,x
	bmi .t1xxxx
	sta.l hatz,x
	lda.l hatvz,x
	clc
	adc.w #$0006
	sta.l hatvz,x
.rtlx:
	rtl

.t1xxxx:
	lda.w #$0000
	sta.l hatz,x
	rtl

.t2x:
	lda.w #$0000
	sta.l hatvz,x
	sta.l hatz,x
	lda.w #$03E8
	sta.l hattimer,x
	lda.l hatvx,x
	cmp.w #$0010
	bcc .t1xxxxx
	cmp.w #$FFF0
	bcs .t1xxxxx
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .1xxxxxx
	ora.w #$F000
.1xxxxxx:
	eor.w #$FFFF
	inc a
	clc
	adc.l hatvx,x
	sta.l hatvx,x
	lda.l hatvy,x
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .2xx
	ora.w #$F000
.2xx:
	eor.w #$FFFF
	inc a
	clc
	adc.l hatvy,x
	sta.l hatvy,x
	rtl

.t1xxxxx:
	lda.w #$0000
	sta.l hatvx,x
	sta.l hatvy,x
	rtl
.9:
	dw $0004,$0008,$0009,$000F,$000C,$000D,$000A,$0007,$000B,$000E
