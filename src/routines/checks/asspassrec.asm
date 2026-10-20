; Assignment: waiting for a pass
asspassrec:							; X = player; asstab entry, waits for the pass to arrive
	lda.w pflags,x
	bit.w #pfna
	beq .3
	and.w #$FFFD
	ora.w #$0001
	sta.w pflags,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.3:
	lda.w passwait,x
	sec
	sbc.w timestep
	sta.w passwait,x
	bmi .6
	lda.w puckc
	bpl .6
	lda.w onetimerreq
	bne .8
	ldy.w playerpad,x
	bmi .t2
	lda.w padnew,y
	bit.w #$8000
	bne .6
	bit.w #$0080
	beq .t2
.4:
	inc.w onetimerreq
	bra .8

.t1:								; bare return, not branched to in this file
	rtl

.t2:								; computer receiver or shoot not pressed: check the team's pads
	ldy.b a2
	lda.w teampads,y
	bne .5
	lda.w pfgoal,x
	bne .2
	lda.w Ypos,x
	cmp.w #$FFA8
	bpl .5
.1:
	jsl.l RandomWord
	and.w #$0080
	bne .5
	inc.w onetimerreq
	jmp.w .8
.2:
	lda.w Ypos,x
	cmp.w #$0058
	bpl .1
.5:
	lda.w puckc
	bmi .7
.6:
	lda.w #$FFFF
	sta.w passReceiverPlayerNum
	stz.w pfalock,x
	stz.w onetimerreq
	lda.w pflags,x
	and.w #$FFFE
	sta.w pflags,x
	jmp.w assexit
.7:
	rtl
.8:
	lda.w SPA,x
	cmp.w #SPAonetimerf
	beq .10
	cmp.w #SPAonetimerb
	beq .10
	phy
	ldy.w #$0000
	cpx.w #$000C
	bmi .1x
	ldy.w #$0002
.1x:
	lda.w tmOneTimerSwings,y
	inc a
	sta.w tmOneTimerSwings,y
	ply
	lda.w #$0000
	sec
	sbc.w passtargetx
	sta.b d0
	lda.w pfgoal,x
	bne .t1x
	lda.w #$FEF8
	sec
	sbc.w passtargety
	sta.b d1
	bra .2x

.t1x:								; pfgoal set: aim at y = $0108 - passtargety
	lda.w #$0108
	sec
	sbc.w passtargety
	sta.b d1
.2x:
	jsl.l vtoa
	jsl.l Findhittype
	beq .t1xx
	lda.w #SPAonetimerb
	bra .3x

.t1xx:								; Findhittype gave 0: use SPAonetimerf instead of SPAonetimerb
	lda.w #SPAonetimerf
.3x:
	jsl.l SetSPAFromA
	jmp.w .7
.9:
	jmp.w .6
.10:
	lda.w #$000A
	sta.w nopuck,x
	lda.w SPAnum,x
	cmp.w #$0010
	bcs .9
	txa
	jsl.l GetHot
	lda.w Xpos,x
	clc
	adc.b d0
	sec
	sbc.w puckx
	sta.b d0
	lda.w Ypos,x
	clc
	adc.b d1
	sec
	sbc.w pucky
	sta.b d1
	ldy.b d0
	jsl.l ApproxLength
	cmp.w #$0008
	bcs .5x
	stz.w SPAcnt,x
	cmp.w #$000C
	bcs .5x
	stx.w puckc
	ldy.w playerpad,x
	bmi .t1xxx
.1xx:
	lda.w paddir,y
	sta.w passdir
	bra .4x

.t1xxx:								; computer player (playerpad < 0): passdir = 8
	lda.w #$0008
	sta.w passdir
.4x:
	lda.w #$0024
	sta.w passspeed
	sta.w pfalock,x
	lda.w gmclock
	bne .2xx
	phy
	ldy.w #$0000
	cpx.w #$000C
	bmi .1xxx
	ldy.w #$0002
.1xxx:
	lda.w tmOneTimers,y
	inc a
	sta.w tmOneTimers,y
	ply
.2xx:
	lda.w #$0001
	sta.w onetimer
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .3xx
	sta.w CwdExciteLvl
.3xx:
	lda.b a2
	pha
	stx.b a2
	jsl.l a2touchpuck
	pla
	sta.b a2
	jsl.l doshot
	jmp.w .6
.5x:
	lda.w puckc
	bmi .t1xxxx
.1xxxx:
	cpx.w puckc
	beq .t1xxxx
	jmp.w .6

.t1xxxx:							; puck loose or X has it: return
	rtl
