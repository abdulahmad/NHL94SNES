; The puck hits goalie a2: a save or not, by his save ratings
puckgoalie:
	lda.w gmode
	bit.w #gmhl
	beq .t1
	jmp.w .7

.t1:
	stz.b d2
	lda.w puckz
	cmp.w #$0008
	bpl .1
	inc.b d2
	inc.b d2
.1:
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
	jsl.l vtoa
	ldy.b a2
	lda.b d0
	sec
	sbc.w facedir,y
	and.w #$0007
	sta.b d0
	and.w #$0003
	sta.b d1
	bne .2
	lda.w seed
	sta.b d0
.2:
	lda.b d0
	and.w #$0004
	lsr a
	lsr a
	eor.w #$0001
	clc
	adc.b d2
	asl a
	sta.b d2
	lda.w GGSleft,y
	sta.b d1
	lda.b d2
	beq .3
	lda.w passacc,y
	sta.b d1
	lda.b d2
	cmp.w #$0002
	beq .3
	lda.w spodds,y
	sta.b d1
	lda.b d2
	cmp.w #$0004
	beq .3
	lda.w endurance,y
	sta.b d1
.3:
	lda.b d1
	clc
	adc.w #$000F
	sta.b d1
	lda.w attribute,y
	bit.w #$0800
	beq .4
	lda.b d2
	eor.w #$0002
	sta.b d2
.4:
	lda.w frame,y
	sec
	sbc.w #SPFgdive		; goalie dive frames SPFgdive..+15
	cmp.w #$0010
	bcs .t2
	lda.w puckz
	cmp.w #$0005
	bmi .t2
	jmp.w .7

.t2:
	jsl.l ChkShotStat
	jsl.l a2touchpuck
	lda.w #$0006
	jsl.l PuckSfx
	lda.w puckvy
	cmp.w #$3000
	bpl .1x
	cmp.w #$D000
	bpl .5
.1x:
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .2x
	sta.w CwdExciteLvl
.2x:
	ldy.b a2
	lda.w pfteam,y
	beq .t1x
	lda.w #$0004
	jsl.l StreamSfx
	bra .5

.t1x:
	lda.l crowdlevel
	clc
	adc.w #$0258
	sta.l crowdlevel
	lda.w #$003C
	sta.b crowdhold
.5:
	lda.w puckc
	bmi .1xx
	lsr a
.1xx:
	sta.b d2
	bpl .t2x
	jmp.w .9

.t2x:
	cpx.w puckc
	bne .t1xx
	jmp.w .9

.t1xx:
	lda.w #$FF00
	tsb.w puckc
	asl.b d2
	lda.b d2
	sta.b a0
	tay
	lda.w #$0014
	sta.w nopuck,y
	tya
	lsr a
	sta.w lastplayer
	lda.w #$000C
	trb.w sflags
.6:
	stz.w puckvz
	ldy.b a2
	lda.w #$000A
	sta.w nopuck,y
	lda.w #$0004
	sta.w temp4,y
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	bne .1xxx
	lda.b a2
	jsl.l GetHot
.1xxx:
	lda.b d1
	and.w #$00FF
	bit.w #$0080
	beq .2xx
	ora.w #$FF00
.2xx:
	sta.b d1
	lda.b d1
	beq .3x
	inc.b d1
.3x:
	ldy.b a2
	lda.w Yvel,y
	eor.b d1
	bmi .4x
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.4x:
	sep #$20
	lda.b d0
	sta.w Xvel+1,x
	lda.b d1
	sta.w Yvel+1,x
	rep #$20
	jmp.w puckflip
.7:
	rtl
.8:
	jmp.w .6
.9:
	lda.w #$0002
	clc
	adc.w shotspd,y
	xba
	and.w #$FF00
	asl a
	jsl.l randoma
	adc.w #$2000
	sta.b d0
	cmp.w puckvx
	bmi .8
	lda.b d0
	cmp.w puckvy
	bmi .8
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	cmp.w puckvx
	bpl .8
	lda.b d0
	cmp.w puckvy
	bpl .8
	ldy.b a2
	lda.w pflags,y
	bit.w #$1000
	bne .8
	stz.w puckvz
	jmp.w puckglue
