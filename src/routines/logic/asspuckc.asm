; Assignment: the puck carrier
asspuckc:
	cpx.w puckc
	bne .1
	lda.w playerpad,x
	bmi .clk
.1:
	jmp.w assexit

.t1:
	rtl
.2:
	jsl.l GlideBack
	jmp.w assnothing
.clk:
	lda.w gmclock
	bne .2
	lda.w pflags,x
	bit.w #pfna
	beq .1x
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b
	lda.w seed
	and.w #$0003
	sta.w temp3,x
.1x:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .3
	adc.w aioff,x
	bpl .3x
.2x:
	lda.w #$0000
.3x:
	sta.w temp1,x
	jsl.l checkob
	lda.w breakaway
	beq .t1x
	lda.w Ypos,x
	sta.b d0
	bpl .4
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.4:
	cmp.w #$0090
	bpl .t1x
	lda.w #$0010
	sta.b d0
	jsl.l assreplace
	bra .10

.t1x:
	jsl.l chk4lc
	jsl.l chk4shot
	lda.w asscur,x
	cmp.w #$0011
	bne .3
	jsl.l chk4pass
.3:
	lda.w #$0006
	clc
	adc.w temp3,x
	sta.b d0
	lda.w #PuckcSpots>>16
	sta.b a0+2
	lda.w #PuckcSpots
	sta.b a0
	lda.w sflags
	bit.w #$8000
	beq .2xx
.1xx:
	lda.w position,x
	sta.b d0
.2xx:
	lda.b d0
	asl a
	asl a
	tay
	lda.b [a0],y
	sta.b d0
	iny
	iny
	lda.b [a0],y
	sta.b d1
	lda.w pfgoal,x
	bne .3xx
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.3xx:
	lda.w #.chkdir>>16
	sta.b a0+2
	lda.w #.chkdir
	sta.b a0
	jml.l skateto
.10:
	rtl
.chkdir:							; skateto callback: turn away from an opponent near where the puck will be
	lda.b d0
	and.w #$00FF
	bit.w #$0080
	beq .2xxx
.1xxx:
	ora.w #$FF00
.2xxx:
	sta.b d0
	lda.w Xvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .3xxx
	ora.w #$FF00
.3xxx:
	clc
	adc.w puckx
	sta.b d2
	lda.w Yvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .4x
	ora.w #$FF00
.4x:
	clc
	adc.w pucky
	sta.b d3
	stz.w threat
	lda.w #$0005
	sta.b d4
	stz.b a0
	cpx.w #$000C
	bcs .6
.5:
	lda.w #$000C
	sta.b a0
.6:
	ldy.b a0
	lda.w Xvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .7
	ora.w #$FF00
.7:
	clc
	adc.w Xpos,y
	sec
	sbc.b d2
	cmp.w #$FFEB
	bmi .9
	cmp.w #$0015
	bpl .9
	lda.w Yvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .8
	ora.w #$FF00
.8:
	clc
	adc.w Ypos,y
	sec
	sbc.b d3
	cmp.w #$FFEB
	bmi .9
	cmp.w #$0015
	bpl .9
	inc.w threat
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	lda.w facedir,x
	eor.w #$0004
	cmp.b d0
	bne .9
	lda.w seed+2
	and.w #$0001
	clc
	adc.b d0
	and.w #$0007
	sta.b d0
.9:
	inc.b a0
	inc.b a0
	dec.b d4
	bmi .t1xx
	jmp.w .6

.t1xx:
	rtl
