; Player a2 falls or stumbles from a hit
FallDown:
	lda.w CwdExciteLvl
	clc
	adc.w #$000F
	bmi .1
	sta.w CwdExciteLvl
.1:
	ldy.b a2
	cpy.w #$0018
	bcs .t1
	lda.w SPA,y
	cmp.w #SPAinjury1
	beq .t1
	cmp.w #SPAstumble
	beq .t1
	cmp.w #SPAfallfwd
	beq .t1
	cmp.w #SPAfallback
	beq .t1
	cmp.w #SPAflip
	beq .t1
	lda.w #SPAstumble
	sta.b d1
	lda.w gmclock
	bne .t2
	lda.w stickhand,y
	cmp.w #$000C
	bcc .t2
	lda.w nopuckb,y
	bne .t2
	lda.w seed
	and.w #$000F
	adc.w #$000A
	sta.b d0
	sec
	sbc.w impact,y
	bmi .t2
	lda.w #$003C
	sta.w nopuckb,y
	jmp.w .21

.t1:
	rtl

.t2:
	lda.w position,x
	beq .2
	stz.b a0
	lda.w pfteam,x
	beq .1x
	lda.w #$0002
	sta.b a0
.1x:
	lda.w gmclock
	bne .2
	ldy.b a0
	lda.w tmchecks,y
	inc a
	sta.w tmchecks,y
.2:
	ldy.b a2
	lda.w #$0078
	sta.w nopuck,y
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	lda.w Xpos,y
	cmp.w #$0068
	bpl .7
	cmp.w #$FF98
	bmi .10
	lda.w Ypos,y
	cmp.w #$0112
	bpl .5
	cmp.w #$FEED
	bmi .4
.3:
	jmp.w .20
.4:
	jmp.w .17
.5:
	jmp.w .15
.6:
	jmp.w .27
.7:
	lda.w Ypos,y
	cmp.w #$00F0
	bpl .6
	cmp.w #$FF0A
	bmi .6
	lda.b d0
	cmp.w #$0005
	bcc .3
	lda.w #$0082
	sta.w Xpos,y
	lda.w #$0000
	sta.w Xvel,y
.8:
	lda.w attribute,y
	bit.w #$0800
	bne .12
.9:
	lda.w #SPAboardright
	bra .13
.10:
	lda.w Ypos,y
	cmp.w #$00F0
	bpl .6
	cmp.w #$FF0A
	bmi .6
	lda.b d0
	dec a
	cmp.w #$0003
	bcs .3
	lda.w #$FF7E
	sta.w Xpos,y
	lda.w #$0000
	sta.w Xvel,y
	lda.w Ypos,y
	cmp.w #$0058
	bpl .11
	cmp.w #$FFA8
	bpl .14
.11:
	lda.w attribute,y
	bit.w #$0800
	bne .9
.12:
	lda.w #SPAboardleft
.13:
	ldx.b a2
	sta.w pfalock,x
	jsl.l SetSPAUpdate
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .1xx
	sta.w CwdExciteLvl
.1xx:
	stz.w benchcheer
	ldy.b a2
	lda.w pfteam,y
	beq .2x
	lda.w #$0002
.2x:
	clc
	adc.w #$0006
	jsl.l StartBenchCheer
	lda.w #$0002
	sta.w benchrounds
	ldx.b a3
	ldy.b a2
	jmp.w .24
.14:
	jmp.w .26
.15:
	lda.w Xpos,y
	cmp.w #$0050
	bpl .19
	cmp.w #$FFB0
	bmi .19
	lda.b d0
	inc a
	inc a
	and.w #$0007
	cmp.w #$0005
	bcc .20
	lda.w #$0128
	sta.w Ypos,y
	lda.w #$0000
	sta.w Yvel,y
.16:
	lda.w #SPAboardfront
	bra .13
.17:
	lda.w Xpos,y
	cmp.w #$0050
	bpl .19
	cmp.w #$FFB0
	bmi .19
	lda.b d0
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .20
	lda.w #$FED8
	sta.w Ypos,y
	lda.w #$0000
	sta.w Yvel,y
.18:
	lda.w #SPAboardback
	jmp.w .13
.19:
	jmp.w .27
.20:
	ldy.b a3
	lda.w pfteam,y
	beq .1xxx
	lda.w #$0002
.1xxx:
	inc a
	inc a
	jsl.l StartBenchCheer
	lda.w #$0002
	sta.w benchrounds
	lda.w #SPAfallback
	sta.b d1
	ldy.b a2
	lda.b d0
	sec
	sbc.w facedir,y
	inc a
	and.w #$0007
	cmp.w #$0003
	bcc .21
	lda.w #SPAfallfwd
	sta.b d1
	lda.w facedir,y
	and.w #$0003
	bne .21
	lda.w aggress,x
	sec
	sbc.w #$000A
	bmi .21
	cpx.w #$0018
	bcs .21
	lda.w #SPAflip
	sta.b d1
.21:
	ldx.b a2
	lda.w #$0001
	sta.w pfalock,x
	jsl.l SetSPA
	ldx.b a3
	lda.w position,x
	bne .24
	cpx.w #$0018
	bcs .24
	bra .24
.22:
	jmp.w CollisionSfx
.23:
	jmp.w .25
.24:
	lda.l crowdlevel
	clc
	adc.w #$012C
	sta.l crowdlevel
	lda.w #$002D
	sta.b crowdhold
	lda.w puckc
	sta.b d0
	bmi .22
	cpy.b d0
	bne .22
	lda.w gmode
	bit.w #gmhl
	bne .23
	lda.l OptPlayMode
	cmp.w #$0004
	beq .23
	lda.w position,x
	beq .23
	lda.w SPA,y
	cmp.w #SPAfallback
	bne .23
	lda.w facedir,y
	and.w #$0003
	bne .23
	lda.w pflags,y
	bit.w #$4000
	bne .23
	lda.w #$0096
	jsl.l randoma8
	asl a
	ldy.b a2
	sec
	sbc.w impact,y
	bpl .23
	lda.w gmclock
	bne .23
	lda.w position,y
	bmi .25
	beq .25
	lda.w #$FFFF
	sta.w puckc
	stz.w benchcheer
	ldy.b a2
	lda.w pfteam,y
	beq .1xxxx
	lda.w #$0002
.1xxxx:
	clc
	adc.w #$0006
	jsl.l StartBenchCheer
	ldx.b a2
	lda.w #SPAinjury1
	jsl.l SetSPAFromA
	ldx.b a3
	lda.w Xvel,x
	eor.w #$FFFF
	inc a
	cmp.w #$8000
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	eor.w #$FFFF
	inc a
	cmp.w #$8000
	ror a
	sta.w Yvel,x
	jsl.l setInjuryType
	lda.w #$0004
	sta.w InjCntDown
	lda.w #$0016
	sta.b d0
	lda.w CwdExciteLvl
	clc
	adc.w #$001E
	bmi .2xx
	sta.w CwdExciteLvl
.2xx:
	lda.w position,x
	bne .t2x
	jmp.w AddPenalty2

.t2x:
	lda.l OptPen
	bne .t1x
	jmp.w AddPenalty2

.t1x:
	lda.w #PenRoughing2
	sta.b d0
	jsl.l AddPenalty2
	jmp.w Stop4Pen
.25:
	ldy.b a2
	lda.w SPA,y
	cmp.w #SPAstumble
	beq .1xxxxx
	lda.w #$FFFF
	sta.w puckc
.1xxxxx:
	ldy.b a2
	lda.w pfteam,y
	bne .t1xx
	lda.w #$0003
	jsl.l StreamSfx
	rtl

.t1xx:
	lda.l crowdlevel
	clc
	adc.w #$0258
	sta.l crowdlevel
	lda.w #$002D
	sta.b crowdhold
	rtl
.26:
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .1xxxxxx
	sta.w CwdExciteLvl
.1xxxxxx:
	ldx.b a2
	lda.w #$FF7E
	sta.w Xpos,x
	lda.w #$0000
	sta.w Xvel,x
	lda.w attribute,x
	bit.w #$0800
	bne .t1xxx
	lda.w #SPAbenchcheckl
	bra .2xxx

.t1xxx:
	lda.w #SPAbenchcheckr
.2xxx:
	sta.w pfalock,x
	jsl.l SetSPAFromA
	ldx.b a3
	ldy.b a2
	jmp.w .24
.27:
	lda.b d0
	sta.b d5
	lda.w Xpos,y
	sta.b d2
	lda.w Ypos,y
	sta.b d3
	ldx.w #$0048
	ldy.w #$00EA
	lda.b d2
	bpl .1xxxxxxx
	ldx.w #$FFB8
.1xxxxxxx:
	lda.b d3
	bpl .2xxxx
	ldy.w #$FF16
.2xxxx:
	stx.b d0+2
	sty.b d1+2
	lda.b d2
	sec
	sbc.b d0+2
	sta.b d0
	lda.b d3
	sec
	sbc.b d1+2
	sta.b d1
	ldy.b d0
	jsl.l ApproxLength
	ldy.b a2
	sta.b d4
	cmp.w #$0014
	bcs .t1xxxx
	ldx.b a3
	jmp.w .20

.t1xxxx:
	lda.b d0
	xba
	tax
	lda.b d4
	jsl.l DivX8S
	lsr a
	lsr a
	bit.w #$2000
	beq .1xxxxxxxx
	ora.w #$C000
.1xxxxxxxx:
	sta.b d0
	bit.w #$8000
	beq .2xxxxx
	eor.w #$FFFF
	inc a
.2xxxxx:
	sta.b d2+2
	lda.b d1
	xba
	tax
	lda.b d4
	jsl.l DivX8S
	ldx.b a3
	lsr a
	lsr a
	bit.w #$2000
	beq .3x
	ora.w #$C000
.3x:
	sta.b d1
	bit.w #$8000
	beq .4x
	eor.w #$FFFF
	inc a
.4x:
	cmp.b d2+2
	bcs .30
	lda.b d0+2
	bpl .29
	lda.b d5
	dec a
	cmp.w #$0003
	bcs .28
	lda.b d0
	clc
	adc.w #$0006
	clc
	adc.b d0+2
	sta.w Xpos,y
	lda.b d1
	clc
	adc.b d1+2
	sta.w Ypos,y
	lda.w #$0000
	sta.w Xvel,y
	sta.w Yvel,y
	jmp.w .11
.28:
	jmp.w .20
.29:
	lda.b d5
	cmp.w #$0005
	bcc .28
	lda.b d0
	sec
	sbc.w #$0006
	clc
	adc.b d0+2
	sta.w Xpos,y
	lda.b d1
	clc
	adc.b d1+2
	sta.w Ypos,y
	lda.w #$0000
	sta.w Xvel,y
	sta.w Yvel,y
	jmp.w .8
.30:
	lda.b d1+2
	bpl .t1xxxxx
	lda.b d5
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .28
	lda.b d0
	clc
	adc.b d0+2
	sta.w Xpos,y
	lda.b d1
	clc
	adc.b d1+2
	sta.w Ypos,y
	lda.w #$0000
	sta.w Xvel,y
	sta.w Yvel,y
	jmp.w .18

.t1xxxxx:
	lda.b d5
	inc a
	inc a
	and.w #$0007
	cmp.w #$0005
	bcc .28
	lda.b d0
	clc
	adc.b d0+2
	sta.w Xpos,y
	lda.b d1
	clc
	adc.b d1+2
	sta.w Ypos,y
	lda.w #$0000
	sta.w Xvel,y
	sta.w Yvel,y
	jmp.w .16
