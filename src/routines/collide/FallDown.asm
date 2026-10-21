; Player a2 falls or stumbles from a hit
FallDown:							; called from Bcheck, checkcheck, checkint, puckbody
	lda.w CwdExciteLvl
	clc
	adc.w #$000F
	bmi .1
	sta.w CwdExciteLvl
.1:									; if a2 >= $0018 go to .t1, ...
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
	sbc.w impact,y					; minus the impact
	bmi .t2
	lda.w #$003C
	sta.w nopuckb,y
	jmp.w .21

.t1:								; return
	rtl

.t2:								; if position,x = 0 go to .2, ...
	lda.w position,x
	beq .2
	stz.b a0
	lda.w pfteam,x
	beq .1x
	lda.w #$0002
	sta.b a0
.1x:								; if gmclock != 0 go to .2, ...
	lda.w gmclock
	bne .2
	ldy.b a0
	lda.w tmchecks,y				; team checks
	inc a
	sta.w tmchecks,y				; count it
.2:									; nopuck,y = $0078, d0 = Xpos,x - Xpos,y, d1 = Ypos,x - Ypos,y, ...
	ldy.b a2						; nopuck 120 for a2
	lda.w #$0078					; puck lockout 120
	sta.w nopuck,y
	lda.w Xpos,x					; direction from a2 to the hitter
	sec
	sbc.w Xpos,y					; minus x of a2
	sta.b d0
	lda.w Ypos,x					; y of the hitter
	sec
	sbc.w Ypos,y					; minus y of a2
	sta.b d1
	jsl.l vtoa						; vector to direction
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
.3:									; go to .20
	jmp.w .20
.4:									; go to .17
	jmp.w .17
.5:									; Ypos,y - $0112 >= 0: go to .15
	jmp.w .15
.6:									; go to .27
	jmp.w .27
.7:									; Xpos,y - $0068 >= 0: if Ypos,y - $00F0 >= 0 go to .6, ...
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
.8:									; if attribute,y bit $0800 set go to .12
	lda.w attribute,y
	bit.w #$0800
	bne .12
.9:									; go to .13
	lda.w #SPAboardright
	bra .13
.10:								; if Ypos,y - $00F0 >= 0 go to .6, ...
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
.11:								; if attribute,y bit $0800 set go to .9
	lda.w attribute,y
	bit.w #$0800
	bne .9
.12:								; falls through
	lda.w #SPAboardleft
.13:								; pfalock,x = A, call SetSPAUpdate, if minus go to .1xx, ...
	ldx.b a2
	sta.w pfalock,x
	jsl.l SetSPAUpdate
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .1xx
	sta.w CwdExciteLvl
.1xx:								; benchcheer = 0, if pfteam,y = 0 go to .2x, ...
	stz.w benchcheer
	ldy.b a2
	lda.w pfteam,y
	beq .2x
	lda.w #$0002
.2x:								; adc #$0006, call StartBenchCheer, benchrounds = $0002, ...
	clc
	adc.w #$0006
	jsl.l StartBenchCheer
	lda.w #$0002
	sta.w benchrounds
	ldx.b a3
	ldy.b a2
	jmp.w .24
.14:								; go to .26
	jmp.w .26
.15:								; if Xpos,y - $0050 >= 0 go to .19, ...
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
.16:								; go to .13
	lda.w #SPAboardfront
	bra .13
.17:								; if Xpos,y - $0050 >= 0 go to .19, ...
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
.18:								; go to .13
	lda.w #SPAboardback
	jmp.w .13
.19:								; go to .27
	jmp.w .27
.20:								; if pfteam,y = 0 go to .1xxx, ...
	ldy.b a3
	lda.w pfteam,y
	beq .1xxx
	lda.w #$0002
.1xxx:								; increment a, increment a, call StartBenchCheer, ...
	inc a
	inc a
	jsl.l StartBenchCheer
	lda.w #$0002
	sta.w benchrounds
	lda.w #SPAfallback				; fall back
	sta.b d1
	ldy.b a2						; hit from the front: fall back
	lda.b d0						; direction to the hitter
	sec
	sbc.w facedir,y
	inc a
	and.w #$0007
	cmp.w #$0003					; within 2 of the facing?
	bcc .21
	lda.w #SPAfallfwd				; else fall forward
	sta.b d1
	lda.w facedir,y					; facedir 0 or 4 and hitter checking >= 10: third fall
	and.w #$0003
	bne .21
	lda.w checking,x				; hitter's checking rating
	sec
	sbc.w #$000A					; minus 10
	bmi .21
	cpx.w #$0018
	bcs .21
	lda.w #SPAflip
	sta.b d1
.21:								; pfalock,x = $0001, call SetSPA, if position,x != 0 go to .24, ...
	ldx.b a2
	lda.w #$0001					; pfalock
	sta.w pfalock,x
	jsl.l SetSPA					; start animation d1
	ldx.b a3
	lda.w position,x
	bne .24
	cpx.w #$0018
	bcs .24
	bra .24
.22:								; go to CollisionSfx
	jmp.w CollisionSfx
.23:								; go to .25
	jmp.w .25
.24:								; Crowdlevel = Crowdlevel + $012C, crowdhold = $002D, d0 = puckc, ...
	lda.l Crowdlevel
	clc
	adc.w #$012C
	sta.l Crowdlevel
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
	sbc.w impact,y					; minus the impact
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
.1xxxx:								; adc #$0006, call StartBenchCheer, call SetSPAFromA, ...
	clc
	adc.w #$0006
	jsl.l StartBenchCheer
	ldx.b a2
	lda.w #SPAinjury1
	jsl.l SetSPAFromA
	ldx.b a3
	lda.w Xvel,x
	eor.w #$FFFF					; negate: two's complement
	inc a
	cmp.w #$8000
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	eor.w #$FFFF					; negate: two's complement
	inc a
	cmp.w #$8000
	ror a
	sta.w Yvel,x
	jsl.l setInjuryType				; setInjuryType
	lda.w #$0004					; injury countdown
	sta.w InjCntDown
	lda.w #$0016
	sta.b d0
	lda.w CwdExciteLvl
	clc
	adc.w #$001E
	bmi .2xx
	sta.w CwdExciteLvl
.2xx:								; if position,x != 0 go to .t2x, ...
	lda.w position,x
	bne .t2x
	jmp.w AddPenalty2

.t2x:								; position,x != 0: if OptPen != 0 go to .t1x, ...
	lda.l OptPen
	bne .t1x
	jmp.w AddPenalty2

.t1x:								; roughing penalty
	lda.w #PenRoughing2				; roughing penalty
	sta.b d0
	jsl.l AddPenalty2
	jmp.w Stop4Pen					; stop play
.25:								; if SPA,y = SPAstumble go to .1xxxxx, ...
	ldy.b a2
	lda.w SPA,y
	cmp.w #SPAstumble
	beq .1xxxxx
	lda.w #$FFFF
	sta.w puckc
.1xxxxx:							; if pfteam,y != 0 go to .t1xx, ...
	ldy.b a2
	lda.w pfteam,y
	bne .t1xx
	lda.w #$0003
	jsl.l StreamSfx
	rtl

.t1xx:								; pfteam,y != 0: Crowdlevel = Crowdlevel + $0258, crowdhold = $002D, re...
	lda.l Crowdlevel
	clc
	adc.w #$0258
	sta.l Crowdlevel
	lda.w #$002D
	sta.b crowdhold
	rtl
.26:								; if minus go to .1xxxxxx, ...
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .1xxxxxx
	sta.w CwdExciteLvl
.1xxxxxx:							; Xpos,x = $FF7E, Xvel,x = $0000, if attribute,x bit $0800 set go to .t...
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

.t1xxx:								; attribute,x bit $0800 set: falls through
	lda.w #SPAbenchcheckr
.2xxx:								; pfalock,x = A, call SetSPAFromA, go to .24
	sta.w pfalock,x
	jsl.l SetSPAFromA
	ldx.b a3
	ldy.b a2
	jmp.w .24
.27:								; d5 = d0, d2 = Xpos,y, d3 = Ypos,y, ...
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
.1xxxxxxx:							; if d3 >= 0 go to .2xxxx, ...
	lda.b d3
	bpl .2xxxx
	ldy.w #$FF16
.2xxxx:								; d0+2 = X, d1+2 = Y, d0 = d2 - d0+2, ...
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

.t1xxxx:							; xba, call DivX8S, lsr a, ...
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
.1xxxxxxxx:							; d0 = A, if zero go to .2xxxxx, ...
	sta.b d0
	bit.w #$8000
	beq .2xxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xxxxx:							; d2+2 = A, xba, call DivX8S, ...
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
.3x:								; d1 = A, if zero go to .4x, ...
	sta.b d1
	bit.w #$8000
	beq .4x
	eor.w #$FFFF					; negate: two's complement
	inc a
.4x:								; if carry set go to .30, ...
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
.28:								; go to .20
	jmp.w .20
.29:								; d0+2 >= 0: if d5 < $0005 go to .28, ...
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
.30:								; if d1+2 >= 0 go to .t1xxxxx, ...
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

.t1xxxxx:							; d1+2 >= 0: if carry clear go to .28, ...
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
