; Assignment: the player nearest the puck who does not have it
assnearest:
	lda.w pflags,x
	bit.w #pfna
	beq .1
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp3,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	stz.w temp1,x
.1:
	lda.w position,x
	beq .t2
	cpx.w puckc
	bne .t3
	lda.w #$0011
	sta.b d0
	lda.w playerpad,x
	bpl .t1
	jmp.w assinsert

.t1:
	rtl

.t2:
	jml.l assgoalie

.t3:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .t2x
	jmp.w .9

.t2x:
	adc.w aioff,x
	bpl .1x
	lda.w #$0000
.1x:
	sta.w temp1,x
	ldy.w puckc
	bmi .t1x
	lda.w position,y
	beq .t1x
	sty.b a1
	lda.w pfteam,y
	eor.w pfteam,x
	bne .t1x
	jmp.w .2

.t1x:
	ldy.b a2
	lda.w tmnear,y
	sta.b d2
	lda.w tmnearpl,y
	sta.b a1
	lda.b d2
	bmi .3
.2:
	cpx.b a1
	beq .3
	lda.w gmclock
	bne .3
	ldy.b a1
	lda.w pflags,y
	bit.w #$1000
	bne .3
	lda.w position,y
	beq .3
	lda.w asscur,y
	cmp.w #$0015
	beq .3
	ldx.b a1
	lda.w pflags,x
	and.w #$FFFE
	sta.w pflags,x
	lda.w #$0012
	sta.b d0
	jsl.l assinsert
	ldx.b curobj
	jmp.w assexit
.3:
	lda.w #$0002
	sta.b d1
	lda.b d2
	cmp.w #$00E2
	bcs .1xx
	stz.b d1
	lda.w position,x
	beq .9
.1xx:
	lda.w sflags
	bit.w #$2000
	beq .2x
	dec.b d1
	dec.b d1
	jsl.l chkpk2
	bne .2x
	inc.b d1
	inc.b d1
	inc.b d1
	inc.b d1
.2x:
	lda.w #$0014
	sec
	sbc.w aggress,x
	sta.b d0
	lda.b d1
	sta.b tmp0
.loop:
	dec.b tmp0
	bmi .8
	asl.b d0
	bra .loop
.4:
	rtl
.5:
	ldy.w puckc
	bmi .7
	lda.w position,y
	bne .7
	lda.w puckx
	sta.b d0
	lda.w #$0058
	ldy.w pfgoal,x
	bne .1xxx
	lda.w #$FFA8
.1xxx:
	sta.b d1
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jsl.l skateto
	jmp.w check4check
.6:
	jsl.l GlideBack
	jmp.w assnothing
.7:
	jsl.l skatetopuck
	jmp.w check4check
.8:
	jsl.l randomd0
	lda.b d0
	cmp.w #$0002
	bcs .9
	lda.w #$00F0
	sta.w temp3,x
.9:
	lda.w playerpad,x
	bpl .4
	lda.w gmclock
	bne .6
	ldy.b a2
	lda.w tmflags,y
	bit.w #$0002
	bne .1xxxx
	lda.w puckc
	bmi .5
	lda.w temp3,x
	sec
	sbc.b d7
	sta.w temp3,x
	cmp.w #$0000
	bpl .5
	stz.w temp3,x
.1xxxx:
	jsl.l skatetopuckinit
	lda.b d1
	pha
	lda.b d0
	pha
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	clc
	adc.w #$00F4
	sta.b d1
	lda.w pfgoal,x
	beq .2xx
	lda.b d1
	sec
	sbc.w #$01E8
	sta.b d1
.2xx:
	lda.b d0
	pha
	asl a
	pla
	ror a
	sta.b d0
	lda.b d1
	pha
	asl a
	pla
	ror a
	sta.b d1
	pla
	clc
	adc.b d0
	sta.b d0
	pla
	clc
	adc.b d1
	sta.b d1
	ldy.b a2
	lda.w tmflags,y
	bit.w #$0002
	beq .4x
.3x:
	lda.w pfgoal,x
	beq .t1xx
	lda.b d1
	sec
	sbc.w #$0053
	bmi .4x
	lda.w #$0044
	sta.b d1
	bra .4x

.t1xx:
	lda.b d1
	sec
	sbc.w #$FFAD
	bpl .4x
	lda.w #$FFBC
	sta.b d1
.4x:
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jsl.l skateto
	jmp.w check4check
