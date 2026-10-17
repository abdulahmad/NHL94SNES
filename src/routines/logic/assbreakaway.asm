; Assignment: the puck carrier on a breakaway (asstab $10): skate in on the goal and shoot; anyone else exits
assbreakaway:
	cpx.w puckc
	bne .1
	lda.w playerpad,x
	bmi .8
.1:
	jmp.w assexit

.t1:
	rtl
.2:
	jsl.l GlideBack
	lda.w #$003C
	sta.w nopuck,x
	jmp.w assnothing
.8:
	lda.w gmclock
	bne .2
	lda.w Ypos,x
	sta.b d0
	ldy.w pfgoal,x
	bne .2x
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.2x:
	lda.w pflags,x
	bit.w #$0002
	beq .1x
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	stz.w sopathpoint
	lda.w seed
	and.w #$0003
	sta.w temp3,x
	jsr.w .11
.1x:
	lda.w sopathnext
	bmi .4
	lda.b d0
	cmp.w sopathnext
	bmi .3
	jsr.w .9
	lda.w facedir,x
	sta.w sopathface
.3:
	lda.w sopathx
	sta.b d0
	lda.w sopathy
	sta.b d1
	lda.w pfgoal,x
	bne .1xx
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.1xx:
	lda.w #.nocallback>>16
	sta.b a0+2
	lda.w #.nocallback
	sta.b a0
	lda.w temp2,x
	sec
	sbc.w impactstep
	sta.w temp2,x
	jml.l skateto
.4:
	lda.w facedir,x
	sec
	sbc.w sopathface
	beq .3
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .t1x
	jsl.l RandomWord
	and.w #$0F80
	bne .3
	bra .5

.t1x:
	jsl.l RandomWord
	and.w #$0600
	bne .3
.5:
	jsl.l RandomWord
	and.w #$0001
	inc a
	inc a
	sta.b d0
	ldy.w sopathside
	bpl .1xxx
	lda.b d0
	clc
	adc.w #$0003
	sta.b d0
.1xxx:
	lda.b d0
	sta.w passdir
	lda.w #$0014
	sta.w passspeed
	lda.w #$0000
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w pfgoal,x
	bne .t1xx
	lda.w #$FEF8
	sec
	sbc.w Ypos,x
	sta.b d1
	bra .6

.t1xx:
	lda.w #$0108
	sec
	sbc.w Ypos,x
	sta.b d1
.6:
	jsl.l vtoa
	jsl.l Findhittype
	beq .t1xxx
	lda.w #SPAonetimerb
	bra .7

.t1xxx:
	lda.w #SPAonetimerf
.7:
	jsl.l SetSPAFromA
	jsl.l updateanim
	lda.w #$0002
	sta.w SPAcnt,x
	jsl.l doshot
	rtl
.nocallback:						; the skateto callback that does nothing
	rtl
.9:
	lda.w sopathpoint
	asl a
	adc.w sopathpoint
	asl a
	tay
	lda.w #$009E
	sta.b a0+2
	lda.w #.10
	sta.b a0
	lda.b [a0],y
	sta.b d0
	lda.w sopathside
	bpl .1xxxx
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.1xxxx:
	lda.b d0
	sta.w sopathx
	iny
	iny
	lda.b [a0],y
	sta.w sopathy
	iny
	iny
	lda.b [a0],y
	sta.w sopathnext
	inc.w sopathpoint
	rts
.10:
	dw 40,120,74,-22,151,134,-22,224,177,44,227,-1
.11:
	lda.b d0
	cmp.w #$002C
	bpl .4x
	jsl.l RandomWord
	and.w #$00C0
	beq .t1xxxx
	lda.w attribute,x
	bit.w #$0800
	bne .1xxxxx
	bra .2xx

.t1xxxx:
	jsl.l RandomWord
	and.w #$00F0
	sta.b d0
	lda.w #$007F
	sec
	sbc.b d0
	bmi .2xx
.1xxxxx:
	lda.w #$002D
	bra .3x
.2xx:
	lda.w #$FFD3
.3x:
	ldy.w pfgoal,x
	bne .2xxx
.1xxxxxx:
	eor.w #$FFFF
	inc a
.2xxx:
	sta.w sopathside
	sta.w sopathx
	lda.w #$0028
	sta.w sopathy
	lda.w #$001E
	sta.w sopathnext
	rts
.4x:
	lda.w Xpos,x
	cmp.w #$0020
	bpl .8x
	cmp.w #$FFE0
	bmi .8x
	jsl.l RandomWord
	and.w #$00C0
	beq .t1xxxxx
	lda.w attribute,x
	bit.w #$0800
	bne .1xxxxxxx
	bra .5x

.t1xxxxx:
	jsl.l RandomWord
	and.w #$00F0
	sta.b d0
	lda.w #$007F
	sec
	sbc.b d0
	bmi .5x
.1xxxxxxx:
	lda.w #$002C
	bra .6x
.5x:
	lda.w #$FFD4
.6x:
	ldy.w pfgoal,x
	bne .1xxxxxxxx
	eor.w #$FFFF
	inc a
.1xxxxxxxx:
	sta.w sopathside
	sta.w sopathx
.7x:
	lda.w #$0002
	sta.w sopathpoint
	lda.w #$0097
	sta.w sopathy
	lda.w #$0086
	sta.w sopathnext
	rts
.8x:
	sta.w sopathside
	stz.w sopathx
	bra .7x
