; Animation, speed, position, input and assignment for every object
updateplayers:
	lda.w #$FFFF
	sta.w topgoalie
	sta.w botgoalie
	sta.w tmnear
	sta.w tmnear+2
	sta.w tmnearpl
	sta.w tmnearpl+2
	lda.w puckz
	sta.w puckoldz
	ldx.w #$001E
.2:
	stx.b curobj
	lda.w Xpos,x
	sta.w OldXpos,x
	lda.w Xfrac,x
	sta.w OldXfrac,x
	lda.w Ypos,x
	sta.w OldYpos,x
	lda.w Yfrac,x
	sta.w OldYfrac,x
	cpx.w #$0018
	beq .1
	cpx.w #$001A
	bne .t2
.1:
	jmp.w .9

.t2:
	lda.w position,x
	bpl .t1
	jmp.w .11

.t1:
	bne .8
	lda.w Ypos,x
	bpl .t3
	stx.w botgoalie
	bra .8

.t3:
	stx.w topgoalie
.8:
	jsl.l updateanim
	lda.w nopuck,x
	sec
	sbc.w timestep
	bpl .1x
	lda.w #$0000
.1x:
	sta.w nopuck,x
	lda.w nopuckb,x
	sec
	sbc.w timestep
	bpl .2x
	lda.w #$0000
.2x:
	sta.w nopuckb,x
	lda.w sflags3
	bit.w #$0020
	beq .4
	lda.w pnum,x
	and.w #$00FF
	cmp.w #$0080
	bcc .3
	ora.w #$FF00
.3:
	sta.b d0
	cmp.w #$0000
	bmi .4
	asl.b d0
	jsl.l loadTeamStruct
.4:
	lda.w goaliedivewait,x
	beq .6
	sec
	sbc.w timestep
	bpl .5
	lda.w #$0000
.5:
	sta.w goaliedivewait,x
.6:
	cpx.w passReceiverPlayerNum
	bne .7
	lda.w onetimer
	bne .10
.7:
	lda.w SPA,x
	cmp.w #SPAinjury1
	bne .t1x
	jmp.w .11

.t1x:
	cmp.w #SPAboardfront
	bcc .t2x
	jmp.w .11

.t2x:
	cpx.w #$001C
	bne .9
	lda.w puckz
	bne .10
.9:
	txy
	ldx.w timestep
	lda.l .20,x
	and.w #$00FF
	sta.b d2
	lda.w pflags,y
	bit.w #$0001
	beq .1xx
	lda.l .22-1,x
	and.w #$00FF
	sta.b d2
.1xx:
	ldx.w Xvel,y
	lda.b d2
	jsl.l Mul16x8HiXS
	sta.w Xvel,y
	ldx.w Yvel,y
	lda.b d2
	jsl.l Mul16x8HiXS
	sta.w Yvel,y
	tyx
.10:
	lda.w velstep
	sta.b p0
	lda.w Xvel,x
	beq .1xxx
	tax
	lda.b p0
	jsl.l Mul16x8XS
	ldx.b curobj
	lda.b r2
	clc
	adc.w Xfrac,x
	sta.w Xfrac,x
	lda.b r2+2
	adc.w Xpos,x
	sta.w Xpos,x
.1xxx:
	lda.w Yvel,x
	beq .2xx
	tax
	lda.b p0
	jsl.l Mul16x8XS
	ldx.b curobj
	lda.b r2
	clc
	adc.w Yfrac,x
	sta.w Yfrac,x
	lda.b r2+2
	adc.w Ypos,x
	sta.w Ypos,x
.2xx:
	cpx.w #$001C
	bne .11
	lda.w puckz
	bmi .11
	bne .3x
	lda.w puckvz
	beq .11
.3x:
	lda.w puckvz
	sec
	sbc.w gravstep
	sta.w puckvz
	tax
	lda.w velstep
	jsl.l Mul16x8XS
	ldx.b curobj
	lda.b r2
	clc
	adc.w puckzfrac
	sta.w puckzfrac
	lda.b r2+2
	adc.w puckz
	sta.w puckz
	bpl .11
	stz.w puckz
	stz.w puckzfrac
	lda.w puckvz
	eor.w #$FFFF
	inc a
	lsr a
	sta.w puckvz
	cmp.w #$0200
	bmi .11
	asl a
	asl a
	sta.b p0
	stz.b p0+2
	lda.w #$0007
	jsl.l sfx
.11:
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	bpl .1xxxx
	eor.w #$FFFF
	inc a
.1xxxx:
	pha
	lsr a
	lsr a
	tax
	jsl.l Mul8U
	ldx.b curobj
	sta.w puckdist2,x
	lda.w pucky
	sec
	sbc.w Ypos,x
	sta.b d1
	bpl .2xxx
	eor.w #$FFFF
	inc a
.2xxx:
	pha
	lsr a
	lsr a
	tax
	jsl.l Mul8U
	ldx.b curobj
	clc
	adc.w puckdist2,x
	sta.w puckdist2,x
	cpx.w #$0018
	bcs .12
	sta.b r3
	lda.w position,x
	bmi .12
	beq .12
	lda.w pflags,x
	and.w #$1000
	ora.w pfalock,x
	bne .12
	lda.b r3
	cpx.w #$000C
	bcs .t1xx
	cmp.w tmnear
	bcs .12
	sta.w tmnear
	stx.w tmnearpl
	bra .12

.t1xx:
	cmp.w tmnear+2
	bcs .12
	sta.w tmnear+2
	stx.w tmnearpl+2
.12:
	ply
	pla
	jsl.l ApproxLength_abs
	ldx.b curobj
	sta.w puckdist,x
	cpx.w #$0018
	bcs .14
	cmp.w #$001E
	bcs .14
	lda.w iflags
	bit.w #$0004
	beq .14
	bit.w #$0001
	bne .14
	and.w #$0002
	beq .t1xxx
	lda.w pfgoal,x
	bne .14
	bra .13

.t1xxx:
	lda.w pfgoal,x
	beq .14
.13:
	lda.w puckz
	cmp.w #$000D
	bcs .14
	lda.w puckvy
	cmp.w #$2400
	bcs .14
	cmp.w #$DC00
	bmi .14
	lda.w #$0005
	trb.w iflags
.14:
	jsl.l vtoa
	sta.w puckdir,x
	dex
	dex
	bmi .t1xxxx
	jmp.w .2

.t1xxxx:
	lda.w Ypos+$18
	cmp.w #$011F
	bmi .1xxxxx
	lda.w #$011F
.1xxxxx:
	sta.w Ypos+$18
	lda.w Ypos+$1A
	cmp.w #$FED2
	bpl .2xxxx
	lda.w #$FED2
.2xxxx:
	sta.w Ypos+$1A
	ldy.w #$000C
	lda.w #$000F
.loop:
	sta.w PadControlObj,y
	dey
	dey
	bpl .loop
	ldx.w #$0008
	lda.w #$0000
.loop2:
	sta.w padinputdone,x
	dex
	dex
	bpl .loop2
	lda.w #$0000
	sta.b curobjteam
	lda.w #$0002
	sta.b curobjopp
	ldx.w #$0000
.15:
	stx.b a3
	stx.b curobj
	cpx.w #$000C
	bne .1xxxxxx
	lda.w #$0002
	sta.b curobjteam
	lda.w #$0000
	sta.b curobjopp
.1xxxxxx:
	lda.w #$FFFF
	sta.b PlayersUnused
	lda.w position,x
	bpl .t2xx
	jmp.w .19

.t2xx:
	txa
	lsr a
	sta.b d6
	cpx.w puckc
	bne .1xxxxxxx
	lda.w sfhormode
	bne .1xxxxxxx
	lda.w #$0000
	sta.b d4
	jsl.l setpads
.1xxxxxxx:
	cpx.w #$0018
	bcs .t1xxxxx
	lda.w playerpad,x
	bmi .t1xxxxx
	tay
	lda.w padinputdone,y
	bne .t1xxxxx
	lda.w #$0001
	sta.w padinputdone,y
	lda.w JoyPad,y
	sta.b d3
	lda.w padchange,y
	sta.b d2
	lda.w padnew,y
	sta.b d1
	lda.w paddir,y
	sta.b d0
	iny
	iny
	sty.b d4
	jsl.l doinput
	bra .t1xxxxx

.t1xxxxx:
	lda.w pfalock,x
	bne .1xxxxxxxx
	lda.w asscur,x
	asl a
	asl a
	tax
	lda.l asstab,x
	sta.w jmlvector+1
	lda.l asstab+1,x
	sta.w jmlvector+2
	ldx.b curobj
	jsl.l loadTeamStruct
	jsl.l jmlvector
.1xxxxxxxx:
	lda.w position,x
	ora.w gmclock
	bne .17
	cpx.w #$0018
	bcs .17
	cpx.w puckc
	beq .17
	lda.w goalieflags,x
	bit.w #$0001
	bne .17
	lda.w Xpos,x
	cmp.w #$FFD5
	bpl .t3x
	cmp.w #$FFCF
	bmi .16
	lda.w #$FFD5
	stz.w Xvel,x
	bra .16

.t3x:
	cmp.w #$002C
	bmi .16
	cmp.w #$0031
	bpl .16
	lda.w #$002B
	stz.w Xvel,x
.16:
	sta.w Xpos,x
	lda.w Ypos,x
	bpl .t1xxxxxx
	cmp.w #$FF1C
	bmi .17
	cmp.w #$FF21
	bpl .17
	lda.w #$FF1B
	sta.w Ypos,x
	stz.w Yvel,x
	bra .17

.t1xxxxxx:
	cmp.w #$00E5
	bpl .17
	cmp.w #$00E0
	bmi .17
	lda.w #$00E5
	sta.w Ypos,x
	stz.w Yvel,x
.17:
	stz.w Wallcos,x
	stz.w Wallsin,x
	lda.w Ypos,x
	sta.b d3
	lda.w Xpos,x
	sta.b d2
	cmp.w OldXpos,x
	bne .t1xxxxxxx
	lda.b d3
	cmp.w OldYpos,x
	bne .t1xxxxxxx
	jmp.w .18

.t1xxxxxxx:
	jsl.l checkcoll
	cpx.w #$0018
	bcs .18
	lda.w position,x
	beq .18
	lda.w pflags,x
	and.w #$8000
	ora.w sfhormode
	bne .18
	lda.w Xpos,x
	cmp.w #$FFE7
	bmi .18
	cmp.w #$0019
	bpl .18
	lda.w Ypos,x
	bit.w #$8000
	beq .1xxxxxxxxx
	eor.w #$FFFF
	inc a
.1xxxxxxxxx:
	sec
	sbc.w #$010D
	sta.b r0
	lda.w OldYpos,x
	bit.w #$8000
	beq .2xxxxx
	eor.w #$FFFF
	inc a
.2xxxxx:
	sec
	sbc.w #$010D
	eor.b r0
	bmi .4x
	lda.w Ypos,x
	bit.w #$8000
	beq .3xx
	eor.w #$FFFF
	inc a
.3xx:
	cmp.w #$0103
	bcc .18
	cmp.w #$0117
	bcs .18
.4x:
	lda.w OldXpos,x
	sta.w Xpos,x
	lda.w OldYpos,x
	sta.w Ypos,x
.18:
	lda.w impact,x
	sec
	sbc.w impactstep
	bpl .19
	lda.w #$0000
.19:
	sta.w impact,x
	inx
	inx
	cpx.w #$0020
	beq .t1xxxxxxxx
	jmp.w .15

.t1xxxxxxxx:
	lda.w puckz
	cmp.w #$0018
	bcs .2xxxxxx
	lda.w puckx
	cmp.w #$FF78
	bpl .1xxxxxxxxxx
	lda.w #$FF78
	sta.w puckx
	ldx.w frame+$1C
	cpx.w #SPFpuck
	bne .1xxxxxxxxxx
	sta.w Xpos+$1E
.1xxxxxxxxxx:
	lda.w puckx
	cmp.w #sideline
	bmi .2xxxxxx
	lda.w #sideline
	sta.w puckx
	ldx.w frame+$1C
	cpx.w #SPFpuck
	bne .2xxxxxx
	sta.w Xpos+$1E
.2xxxxxx:
	lda.w puckz
	bne .4xx
	lda.w pucky
	cmp.w #$FEC2
	bmi .4xx
	cmp.w #$013E
	bpl .4xx
	lda.w pucky
	cmp.w #$FEDB
	bpl .3xxx
	lda.w #$FEDB
	sta.w pucky
	sta.w Ypos+$1E
.3xxx:
	lda.w pucky
	cmp.w #$012A
	bmi .4xx
	lda.w #$012A
	sta.w pucky
	sta.w Ypos+$1E
.4xx:
	lda.w puckc
	bmi .20
	lda.w pucky
	sta.l carriedy
.20:
	rtl
.21:
	db $FD,$FA,$F7,$F4,$F1,$EE,$EB,$E8,$E6,$E3
.22:
	db $FF,$FF,$FE,$FE,$FE,$FD,$FD,$FD,$FC,$FC
