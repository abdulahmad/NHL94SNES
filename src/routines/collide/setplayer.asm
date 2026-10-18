; Bring roster player d3 onto the ice as object X and set his stats
setplayer:
	phx
	phy
	lda.w pflags,x
	and.w #(~pf2inj&$FFFF)
	sta.w pflags,x
	stz.b a0
	lda.w pfteam,x
	beq .0
	inc.b a0
	inc.b a0
.0:
	lda.b d3
	and.w #$00FF
	sta.w pnum,x
	asl a
	sta.b d3
	lda.w #$000B
	sta.b d0
	lda.b a0
	beq .idx
	lda.w #$0034
.idx:
	adc.b d3
	tay
	lda.w tmpdst,y
	sta.b d1
	tya
	sta.b r3
	asl a
	adc.b r3
	asl a
	sta.b r3
	lda.b d1
	bpl .da
	lda.w #$000A
	sta.b d0
	lda.b d1
	cmp.w #TMPDBENCH
	bne .nda
.da:
	jsl.l assinsert
	stz.w pfalock,x
	stz.w SPA,x
.nda:
	lda.b a0
	beq .nda1
	lda.w #$0034
.nda1:
	clc
	adc.b d3
	tay
	lda.w #TMPDICE
	sta.w tmpdst,y
	lsr.b d3
	ldy.b a0
	lda.w tmdata,y
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	lda.b a0
	pha
	lda.b a0+2
	pha
	ldy.w #$0008
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	stz.w PPBonus
	stz.w PKBonus
	stz.w ThirdPBonus
	stz.w HmAwBonus
	lda.w position,x
	bne .t1
	jmp.w .6

.t1:
	lda.w sflags
	bit.w #$2000
	beq .5
	jsl.l chkpk2
	beq .t2
	ldy.w #$0001
	lda.b [a0],y
	and.w #$000F
	sta.w PPBonus
	bra .5

.t2:
	ldy.w #$0001
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	eor.w #$FFFF
	inc a
	sta.w PKBonus
.5:
	ldy.w #$0002
	lda.b [a0],y
	and.w #$000F
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w pfteam,x
	bne .1
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.b d0
.1:
	lda.b d0
	sta.w HmAwBonus
	lda.w gsp
	sec
	sbc.w #$0002
	bmi .6
	bne .2
	jsl.l GetPeriodTime
	lsr.b d0
	lda.b d0
	sec
	sbc.w gameclock
	beq .2
	bpl .6
.2:
	lda.w tmscore
org $9FD000
	sec
	sbc.w tmscore+2
	sta.b tmp0
	beq .4
	lda.w pfteam,x
	beq .3
	lda.w #$0000
	sec
	sbc.b tmp0
	sta.b tmp0
.3:
	lda.b tmp0
	bpl .6
.4:
	lda.w #$0002
	sta.w ThirdPBonus
.6:
	pla
	sta.b a0+2
	pla
	sta.b a0
	ldy.w #$0000
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
.loop:
	lda.b [a0]
	clc
	adc.b a0
	adc.w #$0008
	sta.b a0
	dec.b d3
	bpl .loop
	lda.b a0
	sec
	sbc.w #$0008
	sta.b a0
	lda.b [a0]
	and.w #$00FF
	sta.w rostnum,x
	ldy.w #$0001
	lda.b [a0],y
	and.w #$00F0
	lsr a
	sta.w weight,x
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	ldy.w #$0000
	jsl.l .8
	sta.w legstr,x
	ldy.w #$0002
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	ldy.w #$0001
	jsl.l .8
	sta.w legspd,x
	ldy.w #$0002
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	clc
	adc.w ThirdPBonus
	ldy.w #$0002
	jsl.l .8
	eor.w #$000F
	clc
	adc.w #$000F
	lsr a
	sta.w aioff,x
	ldy.w #$0003
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w HmAwBonus
	ldy.w #$0003
	jsl.l .8
	pha
	lda.w position,x
	beq .t1x
	pla
	eor.w #$000F
	clc
	adc.w #$0007
	sta.w aidef,x
	bra .7

.t1x:
	pla
	eor.w #$000F
	clc
	adc.w #$000F
	lsr a
	sta.w aidef,x
.7:
	ldy.w #$0003
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	ldy.w #$0004
	jsl.l .8
	sta.w shotspd,x
	ldy.w #$0004
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w ThirdPBonus
	ldy.w #$0005
	jsl.l .8
	sta.w aggress,x
	lda.w attribute,x
	and.w #$F7FF
	sta.w attribute,x
	ldy.w #$0004
	lda.b [a0],y
	and.w #$0001
	eor.w #$0001
	sta.w handed,x
	bne .1x
	lda.w attribute,x
	ora.w #$0800
	sta.w attribute,x
.1x:
	lda.b [a0],y
	and.w #$000E
	sta.w fightagg,x
	ldy.w #$0005
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	ldy.w #$0006
	jsl.l .8
	sta.w stickhand,x
	ldy.w #$0005
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	ldy.w #$0007
	jsl.l .8
	sta.w shotacc,x
	ldy.w #$0006
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	ldy.w #$0008
	jsl.l .8
	sta.w endurance,x
	ldy.w #$0006
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w ThirdPBonus
	clc
	adc.w ThirdPBonus
	ldy.w #$0009
	jsl.l .8
	sta.w spodds,x
	ldy.w #$0007
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w PPBonus
	clc
	adc.w HmAwBonus
	ldy.w #$000A
	jsl.l .8
	sta.w passacc,x
	ldy.w #$0007
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	ldy.w #$000B
	jsl.l .8
	sta.w GGSleft,x
	ply
	plx
	rtl
.8:
	sta.b r3+2
	tya
	clc
	adc.b r3
	tay
	sep #$20
	lda.w HotColdTable,y
	lsr a
	lsr a
	bit.b #$00
	beq .1xx
	ora.b #$00
.1xx:
	clc
	adc.b r3+2
	bpl .2x
	lda.b #$00
.2x:
	cmp.b #$0F
	bcc .3x
	lda.b #$0F
.3x:
	rep #$20
	and.w #$00FF
	rtl
