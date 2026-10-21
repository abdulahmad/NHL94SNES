; Assignment: the player nearest the puck who does not have it
assnearest:							; X = player; asstab entry
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
.1:									; if position,x = 0 go to .t2, ...
	lda.w position,x
	beq .t2
	cpx.w puckc
	bne .t3
	lda.w #$0011
	sta.b d0
	lda.w playerpad,x
	bpl .t1
	jmp.w assinsert

.t1:								; pad-controlled player (playerpad >= 0): return
	rtl

.t2:								; position 0 (goalie): jump to assgoalie
	jml.l assgoalie

.t3:								; X is not the puck carrier: run the temp1 timer
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .t2x
	jmp.w .9

.t2x:								; temp1 ran out: add aioff,x to it and reload
	adc.w aioff,x
	bpl .1x
	lda.w #$0000
.1x:								; temp1,x = A, if puckc negative go to .t1x, ...
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

.t1x:								; puck not held by a teammate: use the team's nearest player
	ldy.b a2
	lda.w tmnear,y
	sta.b d2
	lda.w tmnearpl,y
	sta.b a1
	lda.b d2
	bmi .3
.2:									; if zero go to .3, ...
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
.3:									; d1 = $0002, if d2 >= $00E2 go to .1xx, ...
	lda.w #$0002
	sta.b d1
	lda.b d2
	cmp.w #$00E2
	bcs .1xx
	stz.b d1
	lda.w position,x
	beq .9
.1xx:								; if sflags bits $2000 clear go to .2x, ...
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
.2x:								; d0 = $0014 - checking,x, tmp0 = d1
	lda.w #$0014
	sec
	sbc.w checking,x
	sta.b d0
	lda.b d1
	sta.b tmp0
.loop:								; shift d0 left once per count in tmp0 (from d1)
	dec.b tmp0
	bmi .8
	asl.b d0
	bra .loop
.4:									; playerpad,x >= 0: return
	rtl
.5:									; if puckc negative go to .7, ...
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
.1xxx:								; d1 = A, a0 = rtss, call skateto, ...
	sta.b d1
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jsl.l skateto
	jmp.w check4check
.6:									; gmclock != 0: call GlideBack, go to assnothing
	jsl.l GlideBack
	jmp.w assnothing
.7:									; call skatetopuck, go to check4check
	jsl.l skatetopuck
	jmp.w check4check
.8:									; tmp0 counted below 0: call randomd0, if d0 >= $0002 go to .9, ...
	jsl.l randomd0
	lda.b d0
	cmp.w #$0002
	bcs .9
	lda.w #$00F0
	sta.w temp3,x
.9:									; if playerpad,x >= 0 go to .4, ...
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
.1xxxx:								; call skatetopuckinit, d0 = -(d0), d1 = -(d1) + $00F4, ...
	jsl.l skatetopuckinit
	lda.b d1
	pha
	lda.b d0
	pha
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF					; negate: two's complement
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
.2xx:								; ror a, d0 = A, ror a, ...
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
.3x:								; if pfgoal,x = 0 go to .t1xx, ...
	lda.w pfgoal,x
	beq .t1xx
	lda.b d1
	sec
	sbc.w #$0053
	bmi .4x
	lda.w #$0044
	sta.b d1
	bra .4x

.t1xx:								; pfgoal clear: if d1 < $FFAD then d1 = $FFBC
	lda.b d1
	sec
	sbc.w #$FFAD
	bpl .4x
	lda.w #$FFBC
	sta.b d1
.4x:								; a0 = rtss, call skateto, go to check4check
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jsl.l skateto
	jmp.w check4check
