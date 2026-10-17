; Assignment: the puck at the start of play
puckfaceoff:
	stz.w CrowdLoud
	lda.w shootoutmode
	beq .t4
	lda.w shootoutstop
	beq .t4
	inc.w shootoutturnover
	rtl

.t4:
	lda.w #$FFFF
	sta.w puckc
	jsl.l pucknorm_move
	lda.w pflags,x
	bit.w #pfna
	bne .t1x
.1x:
	jmp.w .9

.t1x:
	and.w #$FFFD
	sta.w pflags,x
	lda.w gameclock
	bne .t2x
.1xx:
	jml.l PeriodOver

.t2x:
	lda.w gmode
	bit.w #$0040
	beq .t1xx
.1x2:
	jml.l PeriodOver

.t1xx:
	lda.w gsp
	cmp.w #$0003
	bne .t3
.1xxx:
	lda.w tmscore
	cmp.w tmscore+2
	beq .t3
	jml.l clockcont_0

.t3:
	lda.w gmode
	bit.w #$0008
	beq .t1x2
.1x3:
	jml.l Stop4Pen

.t1x2:
	jsl.l ReturnGoalies
	lda.w #$FFFF
	sta.w temp1,x
	sta.w temp2,x
	lda.l OptLine
	bne .t2xx
	jmp.w .9

.t2xx:
	lda.w penshot
	ora.w penshotlive
	beq .t1xxx
	jmp.w .9

.t1xxx:
	lda.w #$FFFF
	sta.w lcpad
	sta.w lcpad+2
	lda.w #$0008
	trb.w tmflags
	trb.w tmflags+2
	lda.w cont1team
	ora.w cont2team
	ora.w cont3team
	ora.w cont4team
	ora.w cont5team
	beq .1xx2
	lda.w sfhormode
	beq .1xx2
	lda.w #$0040
	tsb.w sflags
	jsl.l ClrHor
.1xx2:
	lda.l newperiod
	bne .2
	lda.w teampads
	beq .2
	jsl.l .11
	lsr a
	sta.b d0
	jsl.l .5
.2:
	lda.l newperiod
	bne .3
	lda.w teampads+2
	beq .3
	jsl.l .12
	lsr a
	sta.b d0
	jsl.l .6
.3:
	lda.w #$0000
	sta.l newperiod
	stz.b a1
	lda.w #$0002
	sta.b a2
	sta.b d0
	jsl.l .1
	jmp.w .9
.1:
	lda.l OptLine
	bne .t1
	jmp.w .8

.t1:
	lda.b d0
	cmp.w cont1team
	bne .t3x
	jmp.w .8

.t3x:
	cmp.w cont2team
	bne .t1xxxx
	jmp.w .8

.t1xxxx:
	cmp.w cont3team
	bne .t2
	jmp.w .8

.t2:
	cmp.w cont4team
	bne .t1xxxxx
	jmp.w .8

.t1xxxxx:
	cmp.w cont5team
	bne .4
	jmp.w .8
.4:
	jsl.l CompLine
	jsl.l setpersonel
	jml.l printscores1
.5:
	lda.l OptLine
	cmp.w #$0002
	bne .7
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w #$0001
	sta.b d0
	bra .4
.6:
	lda.l OptLine
	cmp.w #$0002
	bne .7
	stz.b a1
	lda.w #$0002
	sta.b a2
	sta.b d0
	bra .4
.7:
	ldy.b a3
	sty.b a2
	lda.b d0
	asl a
	sta.b d0
	sta.b a3
	tax
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .1xxxx
	ldy.w #$0002
.1xxxx:
	lda.w #$FFFF
	sta.w lcpad,y
	jsl.l SetLCmode
	ply
	sty.b a2
	ldx.b a3
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .2x
	ldy.w #$0002
.2x:
	lda.w tmflags,y
	ply
	bit.w #$0008
	beq .3x
	lda.w pfteam,x
	beq .t1xxxxxx
	lda.w #$0168
	sta.w temp2,y
	txa
	lsr a
	sta.w temp4,y
	bra .3x

.t1xxxxxx:
	lda.w #$0258
	sta.w temp1,y
	txa
	lsr a
	sta.w temp3,y
.3x:
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
.8:
	rtl
.9:
	stz.w penshotlive
	stz.b d0
	jsl.l .t1xxxxxxx
	lda.w #$0020
	sta.b d0
	jsl.l .t1xxxxxxx
	ldx.b a3
	lda.w temp1,x
	bpl .8
	lda.w temp2,x
	bpl .8
	stz.b a2
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l .1
	lda.w #$001C
	sta.b d0
	ldx.b a3
	jml.l assreplace

.t1xxxxxxx:
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	bmi .8
.1xxxxx:
	lda.w temp3,y
	asl a
	sta.b d1
	tay
	stz.b a0
	stz.b a2
	lda.w pfteam,y
	beq .2xx
	lda.w #$0002
	sta.b a2
.2xx:
	phy
	ldy.b a2
	lda.w tmflags,y
	ply
	bit.w #$0008
	bne .t2xxx
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	ora.w #$FF00
	sta.w temp1,y
	ldx.b a3
	jmp.w SetLCmode2

.t2xxx:
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	sec
	sbc.b d7
	sta.w temp1,y
	bmi .t1xxxxxxxx
	jmp.w .8

.t1xxxxxxxx:
	ldx.b a3
	phx
	ldx.b d1
	stx.b a3
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .1xxxxxx
	ldy.w #$0002
.1xxxxxx:
	lda.w tmflags,y
	ply
	bit.w #$0008
	beq .2xxx
	stz.b d2
	jsl.l lcfound
	jsl.l SetLCmode2
.2xxx:
	plx
	stx.b a3
	rtl
.10:
	ldy.w #$0000
.loop:
	lda.w padside,y
	cmp.b a2
	beq .t1xxxxxxxxx
	iny
	iny
	cpy.w #$000A
	bcc .loop
	lda.w #$FFFF
	bra .1xxxxxxx

.t1xxxxxxxxx:
	tya
.1xxxxxxx:
	rtl
.11:
	lda.w #$0000
	sta.b a2
	jsl.l .10
	tay
	lda.w c1playernum,y
	rtl
.12:
	lda.w #$0002
	sta.b a2
	jsl.l .10
	tay
	lda.w c1playernum,y
	rtl
