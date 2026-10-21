; Assignment: the goalie
assgoalie:							; called from assnearest, asstab
	lda.w #$0006
	ora.w goalieflags,x
	sta.w goalieflags,x
	lda.w Xpos,x
	cmp.w #$FFD8
	bmi .2
	cmp.w #$0029
	bpl .2
	lda.w Ypos,x
	bit.w #$8000
	beq .1
	eor.w #$FFFF					; negate: two's complement
	inc a
.1:									; r0 = A, if minus go to .2, ...
	sta.b r0
	cmp.w #$00E4
	bmi .2
	cmp.w #$0104
	bpl .2
	lda.w #$FFFB
	and.w goalieflags,x
	sta.w goalieflags,x
.2:									; if Xpos,x - $FFD0 negative go to .4, ...
	lda.w Xpos,x
	cmp.w #$FFD0
	bmi .4
	cmp.w #$0031
	bpl .4
	lda.w Ypos,x
	bit.w #$8000
	beq .3
	eor.w #$FFFF					; negate: two's complement
	inc a
.3:									; r0 = A, if minus go to .4, ...
	sta.b r0
	cmp.w #$00E4
	bmi .4
	lda.w #$FFFD
	and.w goalieflags,x
	sta.w goalieflags,x
.4:									; call check4bench, if pflags,x bits pfna clear go to .5, ...
	jsl.l check4bench
	lda.w pflags,x
	bit.w #pfna
	beq .5
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	lda.w #$FFFF
	sta.w temp4,x
.5:									; if playerpad,x >= 0 go to .t2, ...
	ldy.w playerpad,x
	bpl .t2
	lda.w Xpos,x
	cmp.w #$FFCB
	bmi .7
	cmp.w #$0035
	bpl .7
	lda.w Ypos,x
	bit.w #$8000
	beq .6
	eor.w #$FFFF					; negate: two's complement
	inc a
.6:									; if carry set go to .7, ...
	cmp.w #$010F
	bcs .7
	cmp.w #$00D3
	bcs .10
.7:									; a0 = rtss, if Xpos,x >= 0 go to .8, ...
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	ldy.w #$0004
	lda.w Xpos,x
	bpl .8
	ldy.w #$FFFC
.8:									; d0 = Y, d1 = $00F4, if pfgoal,x = 0 go to .9, ...
	sty.b d0
	lda.w #$00F4
	sta.b d1
	lda.w pfgoal,x
	beq .9
	lda.w #$FF0C
	sta.b d1
.9:									; go to skateto
	jml.l skateto

.t1:								; return
	rtl

.t2:								; playerpad,x >= 0: if gmclock != 0 go to .t1x, ...
	lda.w gmclock
	bne .t1x
	cpx.w puckc
	beq .t1x
	jmp.w .12

.t1x:								; goalieflags,x = goalieflags,x | $0001
	lda.w goalieflags,x
	ora.w #$0001
	sta.w goalieflags,x
.10:								; go to .13
	jmp.w .13
.11:								; a0 = rtss, if Xpos,x >= 0 go to .1x, ...
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	ldy.w #$0004
	lda.w Xpos,x
	bpl .1x
	ldy.w #$FFFC
.1x:								; d0 = Y, d1 = $00F9, if pfgoal,x = 0 go to .2x, ...
	sty.b d0
	lda.w #$00F9
	sta.b d1
	lda.w pfgoal,x
	beq .2x
	lda.w #$FF07
	sta.b d1
.2x:								; temp2,x = 0, go to skateto
	stz.w temp2,x
	jml.l skateto
.12:								; if goalieflags,x bit $0001 set go to .10, ...
	lda.w goalieflags,x
	bit.w #$0001
	bne .10
	bit.w #$0002
	bne .11
	ldy.w playerpad,x
	lda.w paddir,y
	cmp.w #$0008
	bne .13
	jsl.l StopNA
.13:								; if pf2aip,x != 0 go to .1xx, ...
	lda.w pf2aip,x
	bne .1xx
	lda.w #SPAgready
	jsl.l SetSPAFromA
.1xx:								; if gmclock != 0 go to .14, ...
	lda.w gmclock
	bne .14
	lda.w temp5,x
	bmi .16
	cpx.w puckc
	bne .t1xx
	lda.w Ypos,x
	cmp.w #$00BB
	bpl .15
	cmp.w #$FF45
	bmi .15
	stz.w temp5,x
	bra .15

.t1xx:								; temp5,x = $FFFF, go to .16
	lda.w #$FFFF
	sta.w temp5,x
	bra .16
.14:								; return
	rtl
.15:								; temp5,x = temp5,x - d7, if plus go to .16, ...
	lda.w temp5,x
	sec
	sbc.b d7
	sta.w temp5,x
	bpl .16
	lda.w #PenGhold
	sta.b d0
	jsl.l AddPenalty2
.16:								; if pf2aip,x = 0 go to .t1xxx, ...
	lda.w pf2aip,x
	beq .t1xxx
	jmp.w .14

.t1xxx:								; pf2aip,x = 0: temp1,x = temp1,x - d7, if minus go to .t2x, ...
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .t2x
	jmp.w .45

.t2x:								; if plus go to .1xxx, ...
	lda.w aidef,x
	lsr a
	clc
	adc.w temp1,x
	cmp.w #$0000
	bpl .1xxx
	lda.w #$0000
.1xxx:								; temp1,x = A, if playerpad,x >= 0 go to .3x, ...
	sta.w temp1,x
	lda.w playerpad,x
	bpl .3x
	lda.w pucky
	sta.b d0
	lda.w Ypos,x
	eor.b d0
	sta.b d1
	bpl .t1xxxx
	stz.b d0
	lda.w #$00F4
	sta.b d2
	lda.w pfgoal,x
	beq .2xx
	lda.w #$FF0C
	sta.b d2
.2xx:								; go to .44
	jmp.w .44

.t1xxxx:							; decrement temp4,x, if temp4,x still >= 0 go to .1xxxx, ...
	dec.w temp4,x
	bpl .1xxxx
	lda.w #$FFFF
	sta.w temp4,x
.1xxxx:								; if zero go to .17
	cpx.w puckc
	beq .17
.3x:								; go to .23
	jmp.w .23
.17:								; if temp5,x >= 0 go to .1xxxxx, ...
	lda.w temp5,x
	bpl .1xxxxx
	lda.w #$005A
	sta.w temp5,x
.1xxxxx:							; temp4,x = $FFFF, if plus go to .18, ...
	lda.w #$FFFF
	sta.w temp4,x
	lda.w temp5,x
	sec
	sbc.w #$005A
	bpl .18
	jsl.l RandomWord
	cmp.w #$C000
	bcc .18
	lda.w #$0005
	sta.b d0
	stz.b a0
	lda.w pfteam,x
	bne .2xxx
	lda.w #$000C
	sta.b a0
.2xxx:								; loop: if pflags,y bit $1000 set go to .3xx, ...
	ldy.b a0
	lda.w pflags,y
	bit.w #$1000
	bne .3xx
	lda.w puckdist,y
	cmp.w #$0023
	bcc .19
.3xx:								; increment a0, increment a0, decrement d0, ...
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .2xxx
	lda.w #$0001
	sta.w threat
	jsl.l chk4pass
	lda.w puckc
	bmi .20
.18:								; go to .24
	jmp.w .24
.19:								; puckdist,y < $0023: if $0000 >= $0014 go to .18, ...
	ldy.w #$0000
	cmp.w #$0014
	bcs .18
	lda.w #$005A
	sta.w pf2aip,x
	lda.w #SPAgcover
	jsl.l SetSPAFromA
.20:								; return
	rtl
.21:								; call vtoa
	jsl.l vtoa
	lda.b d0
.22:								; facedir,x = A, pfalock,x = A, call SetSPAFromA, ...
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #SPAgpoke
	jsl.l SetSPAFromA
	lda.w #$00F0
	sta.w goaliedivewait,x
	rtl
.23:								; if playerpad,x negative go to .t3, ...
	ldy.w playerpad,x
	bmi .t3
	lda.w padinputdone,y
	cmp.w #$0001
	bne .t3
	cpx.w puckc
	beq .18
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w pucky
	sec
	sbc.w Ypos,x
	sta.b d1
	lda.w JoyPad,y
	bit.w #$4000
	bne .t2xx
	lda.w padnew,y
	bit.w #$0040
	beq .18
	lda.w paddir,y
	cmp.w #$0008
	beq .21
	and.w #$0007
	bra .22

.t2xx:								; JoyPad,y bit $4000 set: if paddir,y != $0008 go to .t1xxxxx, ...
	lda.w paddir,y
	cmp.w #$0008
	bne .t1xxxxx
	jmp.w .t4

.t1xxxxx:							; paddir,y != $0008: and #$0007, go to .2xxxx
	and.w #$0007
	jmp.w .2xxxx

.t3:								; d0 = puckx - Xpos,x, d1 = pucky - Ypos,x, if puckc negative go to .t1...
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w pucky
	sec
	sbc.w Ypos,x
	sta.b d1
	lda.w puckc
	bmi .t1xxxxxx
	lsr a
	tay
	lda.w pfteam,y
	cmp.w pfteam,x
	beq .t2xxx
	lda.w goaliedivewait,x
	bne .t2xxx
	jsl.l RandomWord
	cmp.w #$0A00
	bcs .t2xxx
	lda.w puckdist,x
	cmp.w #$0023
	bcs .24
	lda.w pucky
	cmp.w #$FEF7
	bmi .24
	cmp.w #$0109
	bpl .24
	jmp.w .21

.t1xxxxxx:							; puckc negative: if temp4,x != 0 go to .t2xxx, ...
	lda.w temp4,x
	bne .t2xxx
	lda.w puckdist,x
	cmp.w #$002D
	bcs .24
	lda.w pucky
	cmp.w #$FEF7
	bmi .24
	cmp.w #$0109
	bpl .24
	lda.b a2
	eor.w #$0002
	tay
	lda.w tmnear,y
	cmp.w #$003C
	bcs .24
	jsl.l RandomWord
	cmp.w #$0800
	bcs .24
	bra .t4

.t2xxx:								; go to .24
	jmp.w .24

.t4:								; call vtoa
	jsl.l vtoa
	lda.b d0
.2xxxx:								; facedir,x = A, call SetSPAFromA, goaliedivewait,x = $0168, ...
	sta.w facedir,x
	ldy.w #SPAgdive
	tya
	jsl.l SetSPAFromA
	lda.w #$0168
	sta.w goaliedivewait,x
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .1xxxxxx
	sta.w CwdExciteLvl
.1xxxxxx:							; pfalock,x = $0096, Crowdlevel = $0096 + Crowdlevel, crowdhold = $001E...
	lda.w #$0096
	sta.w pfalock,x
	clc
	adc.l Crowdlevel
	sta.l Crowdlevel
	lda.w #$001E
	sta.b crowdhold
	rtl
.24:								; if pfgoal,x != 0 go to .t1xxxxxxx, ...
	lda.w pfgoal,x
	bne .t1xxxxxxx
	lda.w #$0000
	sta.b a0+2
	lda.w #$0D17
	sta.b a0
	lda.w #$0104
	sta.b d3
	lda.w #$0108
	sta.b d4
	bra .1xxxxxxx

.t1xxxxxxx:							; pfgoal,x != 0: a0 = $0D1B, d3 = $FEFC, d4 = $FEF8
	lda.w #$0D1B
	sta.b a0
	lda.w #$FEFC
	sta.b d3
	lda.w #$FEF8
	sta.b d4
.1xxxxxxx:							; if zero go to .t1xxxxxxxx, ...
	cpx.w puckc
	beq .t1xxxxxxxx
	jsr.w GoaliePuckVector
	jsl.l vtoa
	jsl.l AdjustFacingDirection
	bra .2xxxxx

.t1xxxxxxxx:						; if playerpad,x >= 0 go to .2xxxxx, ...
	lda.w playerpad,x
	bpl .2xxxxx
	lda.w pfgoal,x
	eor.w #$0001
	asl a
	asl a
	sta.b d0
	jsl.l AdjustFacingDirection
.2xxxxx:							; if Ypos,x - $FEFB negative go to .4x, ...
	lda.w Ypos,x
	cmp.w #$FEFB
	bmi .4x
	cmp.w #$0105
	bpl .4x
.3xxx:								; d0 = puckx, d1 = pucky, call .49, ...
	lda.w puckx
	sta.b d0
	lda.w pucky
	sta.b d1
	jsl.l .49
	lda.b d1
	cmp.w #$FFD2
	bmi .25
	cmp.w #$002E
	bpl .25
	lda.b d1
	pha
	lda.b d0
	pha
	jmp.w .31
.4x:								; if playerpad,x >= 0 go to .3xxx, ...
	lda.w playerpad,x
	bpl .3xxx
	stz.b d2
	stz.b d0
	lda.w Xpos,x
	cmp.w #$FFD3
	bmi .1xxxxxxxx
	cmp.w #$002D
	bpl .1xxxxxxxx
	lda.w #sideline
	sta.b d0
	lda.w Xpos,x
	bpl .1xxxxxxxx
	lda.w #$FF78
	sta.b d0
.1xxxxxxxx:							; go to .44
	jmp.w .44
.25:								; xba, lsr a, and #$007F, ...
	lda.w puckvy
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .1xxxxxxxxx
	ora.w #$FF80
.1xxxxxxxxx:						; r3 = A, ror a, adc r3, ...
	sta.b r3
	cmp.w #$8000
	ror a
	adc.b r3
	clc
	adc.w pucky
	sta.b d1
	lda.b d1
	cmp.w #$00E0
	bpl .2xxxxxx
	lda.b d1
	cmp.w #$FF20
	bpl .28
.2xxxxxx:							; if passReceiverPlayerNum >= 0 go to .27, ...
	lda.w passReceiverPlayerNum
	bpl .27
	lda.w puckc
	bmi .27
	lda.w seed
	and.w #$0180
	beq .29
.26:								; xba, and #$00FF, if zero go to .1xxxxxxxxxx, ...
	lda.w puckvx
	xba
	and.w #$00FF
	bit.w #$0080
	beq .1xxxxxxxxxx
	ora.w #$FF00
.1xxxxxxxxxx:						; r3 = A, ror a, adc r3, ...
	sta.b r3
	cmp.w #$8000
	ror a
	adc.b r3
	clc
	adc.w puckx
	sta.b d0
	bra .30
.27:								; xba, lsr a, and #$007F, ...
	lda.w puckvx
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .1xxxxxxxxxxx
	ora.w #$FF80
.1xxxxxxxxxxx:						; adc puckx, d0 = A, go to .30
	clc
	adc.w puckx
	sta.b d0
	bra .30
.28:								; d1 - $FF20 >= 0: if seed & $0380 = 0 go to .26
	lda.w seed
	and.w #$0380
	beq .26
.29:								; xba, and #$00FF, if zero go to .1xxxxxxxxxxxx, ...
	lda.w puckvx
	xba
	and.w #$00FF
	bit.w #$0080
	beq .1xxxxxxxxxxxx
	ora.w #$FF00
.1xxxxxxxxxxxx:						; adc puckx, d0 = A
	clc
	adc.w puckx
	sta.b d0
.30:								; call .49
	jsl.l .49
	lda.b d1
	pha
	lda.b d0
	pha
.31:								; call ApproxLength, d0 = A, if carry set go to .t1xxxxxxxxx, ...
	lda.b d0
	ldy.b d1
	jsl.l ApproxLength
	sta.b d0
	cmp.w #$001E
	bcs .t1xxxxxxxxx
	pla
	sta.b d0
	pla
	sta.b d1
	bra .5x

.t1xxxxxxxxx:						; d2 = d0 + 1, d4 = $0014, if sflags bits $0008 clear go to .1xxxxxxxxx...
	lda.b d0
	inc a
	sta.b d2
	lda.w #$0014
	sta.b d4
	lda.w sflags
	bit.w #$0008
	beq .1xxxxxxxxxxxxx
	lda.w #$001C
	sta.b d4
.1xxxxxxxxxxxxx:					; d0 = pulled value, d1 = pulled value, call Mul16x8XS, ...
	pla
	sta.b d0
	pla
	sta.b d1
	tax
	lda.b d4
	jsl.l Mul16x8XS
	lda.b d2
	sta.b r1
	jsl.l Div32S
	lda.b r0
	sta.b d1
	lda.b d4
	adc.w #$0006
	sta.b d4
	ldx.b d0
	jsl.l Mul16x8XS
	lda.b d2
	sta.b r1
	jsl.l Div32S
	lda.b r0
	sta.b d0
	ldx.b curobj
.5x:								; d1 = d1 + d3, d2 = d1 + d3, if playerpad,x negative go to .t1xxxxxxxx...
	lda.b d1
	clc
	adc.b d3
	sta.b d1
	sta.b d2
	ldy.w playerpad,x
	bmi .t1xxxxxxxxxx
	cpx.w puckc
	beq .1xxxxxxxxxxxxxx
	lda.w JoyPad,y
	bit.w #$0080
	bne .t3x
.1xxxxxxxxxxxxxx:					; go to .43
	jmp.w .43

.t1xxxxxxxxxx:						; playerpad,x negative: if [a0],y < $0023 go to .t2xxxx, ...
	ldy.w #$0002
	lda.b [a0],y
	cmp.w #$0023
	bcc .t2xxxx
	jmp.w .44

.t2xxxx:							; [a0],y < $0023: if [a0] - $FFE7 negative go to .t1xxxxxxxxxxx, ...
	lda.b [a0]
	cmp.w #$FFE7
	bmi .t1xxxxxxxxxxx
	cmp.w #$0019
	bpl .t1xxxxxxxxxxx
	lda.b [a0],y
	cmp.w #$0013
	bcs .1xxxxxxxxxxxxxxx
	lda.w pucky
	cmp.w #$FEF7
	bmi .1xxxxxxxxxxxxxxx
	cmp.w #$0109
	bmi .t3x
.1xxxxxxxxxxxxxxx:					; go to .43
	jmp.w .43

.t1xxxxxxxxxxx:						; go to .48
	jmp.w .48

.t3x:								; ror a, Xvel,x = A, ror a, ...
	lda.w Xvel,x
	cmp.w #$8000
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	cmp.w #$8000
	ror a
	sta.w Yvel,x
	lda.w goalieflags,x
	bit.w #$0002
	beq .t1x2
	jmp.w .40

.t1x2:								; goalieflags,x bits $0002 clear: xba, lsr a, lsr a, ...
	lda.w puckvx
	xba
	lsr a
	lsr a
	and.w #$003F
	bit.w #$0020
	beq .1x2
	ora.w #$FFC0
.1x2:								; adc puckx, sbc Xpos,x, d0 = A, ...
	clc
	adc.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	sta.b r0+2
	bit.w #$8000
	beq .2xxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xxxxxxx:							; r0 = A, xba, lsr a, ...
	sta.b r0
	lda.w puckvy
	xba
	lsr a
	lsr a
	and.w #$003F
	bit.w #$0020
	beq .3xxxx
	ora.w #$FFC0
.3xxxx:								; adc pucky, sbc Ypos,x, d1 = A, ...
	clc
	adc.w pucky
	sec
	sbc.w Ypos,x
	sta.b d1
	bit.w #$8000
	beq .4xx
	eor.w #$FFFF					; negate: two's complement
	inc a
.4xx:								; r1 = A, call vtoa, if d0 = $0008 go to .33, ...
	sta.b r1
	jsl.l vtoa
	lda.b d0
	cmp.w #$0008
	beq .33
	sec
	sbc.w facedir,x
	and.w #$0007
	sta.b d3
	beq .33
	jmp.w .41
.32:								; if puckvy - $0800 >= 0 go to .33, ...
	lda.w puckvy
	cmp.w #$0800
	bpl .33
	cmp.w #$F800
	bmi .33
	lda.w #$0008
	sta.b d0
	jmp.w .42
.33:								; if facedir,x = 0 go to .t1xxxxxxxxxxxx, ...
	lda.w facedir,x
	beq .t1xxxxxxxxxxxx
	cmp.w #$0004
	beq .35
	cmp.w #$0001
	beq .37
	cmp.w #$0005
	beq .37
	cmp.w #$0007
	beq .38
	cmp.w #$0003
	beq .38
	lda.w seed
	and.w #$0001
	bra .41

.t1xxxxxxxxxxxx:					; facedir,x = 0: if r0+2 >= 0 go to .36
	lda.b r0+2
	bpl .36
.34:								; go to .41
	lda.w #$0007
	bra .41
.35:								; if r0+2 >= 0 go to .34
	lda.b r0+2
	bpl .34
.36:								; go to .41
	lda.w #$0001
	bra .41
.37:								; if r0 - r1 >= 0 go to .36, ...
	lda.b r0
	cmp.b r1
	bpl .36
	bra .34
.38:								; if r1 - r0 >= 0 go to .36, ...
	lda.b r1
	cmp.b r0
	bpl .36
	bra .34
.39:								; d0 = d0 + $0006, go to .42
	lda.b d0
	clc
	adc.w #$0006
	sta.b d0
	jmp.w .42
.40:								; d3 = puckdir,x - facedir,x & $0007, if zero go to .33
	lda.w puckdir,x
	sec
	sbc.w facedir,x
	and.w #$0007
	sta.b d3
	beq .33
.41:								; if zero go to .32, ...
	cmp.w #$0004
	beq .32
	lsr a
	lsr a
	sta.b d0
	lda.w attribute,x
	bit.w #$0800
	beq .1xxxxxxxxxxxxxxxx
	lda.b d0
	eor.w #$0001
	sta.b d0
.1xxxxxxxxxxxxxxxx:					; if d3 < $0004 go to .2xxxxxxxx, ...
	lda.b d3
	cmp.w #$0004
	bcc .2xxxxxxxx
	eor.w #$FFFF
	adc.w #$0008
.2xxxxxxxx:							; if carry set go to .39, ...
	cmp.w #$0002
	bcs .39
	lda.w puckz
	sec
	sbc.w #$0008
	bpl .42
	lda.w puckvz
	sec
	sbc.w #$0800
	bpl .42
	lda.b d0
	clc
	adc.w #$0004
	sta.b d0
	ldy.w #$0002
	lda.b [a0],y
	cmp.w #$0009
	bcc .42
	lda.w facedir,x
	cmp.w #$0002
	beq .42
	cmp.w #$0006
	beq .42
	lda.w puckc
	bmi .42
	dec.b d0
	dec.b d0
.42:								; asl d0, a1 = GoalieSaveList, pfalock,x = [a1],y, ...
	asl.b d0
	lda.w #GoalieSaveList>>16
	sta.b a1+2
	lda.w #GoalieSaveList
	sta.b a1
	ldy.b d0
	lda.b [a1],y
	sta.w pfalock,x
	jsl.l SetSPAFromA
	lda.l Crowdlevel
	clc
	adc.w #$0096
	sta.l Crowdlevel
	lda.w #$001E
	sta.b crowdhold
.43:								; d0 = [a0], if plus go to .1xxxxxxxxxxxxxxxxx, ...
	lda.b [a0]
	sta.b d0
	lda.w pucky
	sec
	sbc.w #$00FC
	bpl .1xxxxxxxxxxxxxxxxx
	lda.w pucky
	sec
	sbc.w #$FF04
	bpl .44
.1xxxxxxxxxxxxxxxxx:				; d0 = $0018, if puckx >= 0 go to .44, ...
	lda.w #$0018
	sta.b d0
	lda.w puckx
	bpl .44
	lda.w #$FFE8
	sta.b d0
.44:								; if playerpad,x negative go to .t1xxxxxxxxxxxxx, ...
	lda.w playerpad,x
	bmi .t1xxxxxxxxxxxxx
	jmp.w .50

.t1xxxxxxxxxxxxx:					; playerpad,x negative: if puckc negative go to .7x, ...
	ldy.w puckc
	bmi .7x
	lda.w pfteam,x
	cmp.w pfteam,y
	beq .7x
	lda.w SPA,y
	cmp.w #SPAshotf
	bcc .t2xxxxx
	cmp.w #$F021
	bcs .t2xxxxx
	lda.w Yvel,y
	bit.w #$8000
	beq .1xxxxxxxxxxxxxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.1xxxxxxxxxxxxxxxxxx:				; r0 = A, if Xvel,y bits $8000 clear go to .2xxxxxxxxx, ...
	sta.b r0
	lda.w Xvel,y
	bit.w #$8000
	beq .2xxxxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xxxxxxxxx:						; lsr a, if carry set go to .t2xxxxx, ...
	lsr a
	cmp.b r0
	bcs .t2xxxxx
	lda.w goaliestopped
	bne .7x
	stz.w Xvel,x
	stz.w Yvel,x
	inc.w goaliestopped
	rtl

.t2xxxxx:							; goaliestopped = 0
	stz.w goaliestopped
.7x:								; d1 = d2, xba, and #$00FF, ...
	lda.b d2
	sta.b d1
	pha
	lda.b d0
	pha
	lda.w Xvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .1xxxxxxxxxxxxxxxxxxx
	ora.w #$FF00
.1xxxxxxxxxxxxxxxxxxx:				; eor #$FFFF, increment a, d0 = A, ...
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b d0
	pla
	clc
	adc.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Yvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .2xxxxxxxxxx
	ora.w #$FF00
.2xxxxxxxxxx:						; eor #$FFFF, increment a, d1 = A, ...
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b d1
	pla
	clc
	adc.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	lda.w #$0005
	sta.b tmp0
	cpx.w puckc
	bne .3xxxxx
	asl.b tmp0
.3xxxxx:							; if d0 bits $8000 clear go to .4xxx, ...
	lda.b d0
	bit.w #$8000
	beq .4xxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.4xxx:								; if carry set go to .6x, ...
	cmp.b tmp0
	bcs .6x
	lda.b d1
	bit.w #$8000
	beq .5xx
	eor.w #$FFFF					; negate: two's complement
	inc a
.5xx:								; if carry set go to .6x, ...
	cmp.b tmp0
	bcs .6x
	stz.b d0
	stz.b d1
.6x:								; call vtoa, temp2b,x = d0
	jsl.l vtoa
	lda.b d0
	sta.w temp2b,x
.45:								; if playerpad,x >= 0 go to .47, ...
	ldy.w playerpad,x
	bpl .47
	lda.w temp2b,x
	sta.b d2
	sec
	sbc.w #$0007
	beq .t1xxxxxxxxxxxxxx
	bmi .t1xxxxxxxxxxxxxx
	jmp.w StopNA

.t1xxxxxxxxxxxxxx:					; go to playeracc
	jml.l playeracc
.46:								; go to .44
	jmp.w .44
.47:								; playerpad,x >= 0: return
	rtl
.48:								; if puckc >= 0 go to .46, ...
	lda.w puckc
	bpl .46
	lda.w iflags
	bit.w #$0004
	bne .46
	lda.w puckx
	bit.w #$8000
	beq .1xxxxxxxxxxxxxxxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.1xxxxxxxxxxxxxxxxxxxx:				; if minus go to .46, ...
	cmp.w #$0068
	bmi .46
	lda.w puckvy
	bit.w #$8000
	beq .2xxxxxxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xxxxxxxxxxx:						; if minus go to .46, ...
	cmp.w #$3800
	bmi .46
	lda.w pucky
	cmp.w #$00B8
	bpl .3xxxxxx
	lda.w pucky
	cmp.w #$FF48
	bpl .46
.3xxxxxx:							; if pfgoal,x = 0 go to .4xxxx, ...
	lda.w puckvy
	ldy.w pfgoal,x
	beq .4xxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.4xxxx:								; if minus go to .46, ...
	cmp.w #$FC00
	bmi .46
	stz.b a1
	lda.w #$0002
	sta.b a2
	lda.w pfteam,x
	beq .5xxx
	stz.b a2
	lda.w #$0002
	sta.b a1
.5xxx:								; if tmnear,y < $0132 go to .t1xxxxxxxxxxxxxxx, ...
	ldy.b a1
	lda.w tmnear,y
	cmp.w #$0132
	bcc .t1xxxxxxxxxxxxxxx
	ldy.b a2
	lda.w tmnear,y
	cmp.w #$0132
	bcc .t1xxxxxxxxxxxxxxx
	lda.w #$000F
	sta.b d0
	jmp.w assinsert

.t1xxxxxxxxxxxxxxx:					; go to .44
	jmp.w .44
.49:								; subroutine: if Ypos,x - $0108 >= 0 go to .3xxxxxxx, ...
	lda.w Ypos,x
	cmp.w #$0108
	bpl .3xxxxxxx
	cmp.w #$FEF8
	bmi .3xxxxxxx
	cpx.w puckc
	bne .1xxxxxxxxxxxxxxxxxxxxx
	stz.b d0
.1xxxxxxxxxxxxxxxxxxxxx:			; if d1 - $0103 negative go to .2xxxxxxxxxxxx, ...
	lda.b d1
	cmp.w #$0103
	bmi .2xxxxxxxxxxxx
	lda.w #$0103
	sta.b d1
.2xxxxxxxxxxxx:						; if d1 - $FEFD >= 0 go to .3xxxxxxx, ...
	lda.b d1
	cmp.w #$FEFD
	bpl .3xxxxxxx
	lda.w #$FEFD
	sta.b d1
.3xxxxxxx:							; d1 = d1 - d3
	lda.b d1
	sec
	sbc.b d3
	sta.b d1
.50:								; return
	rtl
