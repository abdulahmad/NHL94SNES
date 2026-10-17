; Pass the puck in the pass direction, to the best teammate there if any
dopass:
	stz.w onetimerreq
	lda.w #$0004
	trb.w sflags
	lda.w #$FFFF
	sta.w puckc
	lda.w #$0010
	sta.w nopuck,x
	txa
	lsr a
	sta.w lastplayer
	lda.w #$0007
	sta.b d0
	lda.w position,x
	beq .1
	lda.w passacc,x
	sta.b d0
.1:
	lda.b d0
	asl a
	asl a
	adc.w #$0090
	sta.w passspeed
	lda.w #$FFFF
	sta.b d4
	lda.w #$0005
	sta.b d3
	stz.b a1
	cpx.w #$000C
	bcc .2
	lda.w #$000C
	sta.b a1
.2:
	cpx.b a1
	beq .5
	ldy.b a1
	lda.w position,y
	bmi .5
	beq .5
	lda.w pflags,y
	bit.w #$1000
	bne .5
	lda.w puckdir,y
	sec
	sbc.w passdir
	sec
	sbc.w #$0004
	stz.b r0
	and.w #$0007
	beq .4
	cmp.w #$0001
	beq .3
	cmp.w #$0007
	bne .5
.3:
	lda.w #$1000
	sta.b r0
.4:
	lda.b r0
	clc
	adc.w puckdist2,y
	bcs .5
	cmp.b d4
	bcs .5
	sta.b d4
	lda.b a1
	sta.b a0
.5:
	inc.b a1
	inc.b a1
	dec.b d3
	bmi .t1
	jmp.w .2

.t1:
	ldx.b a3
	lda.b d4
	bmi .t2
	jsl.l dopass_count
	lda.w #$0000
	jsl.l PuckSfx
	jmp.w dopass_swing

.t2:
	lda.w passdir
	asl a
	asl a
	adc.w #$DA08
	sta.b a0
	lda.w #$0080
	sta.b a0+2
	lda.b [a0]
	cmp.w #$8000
	ror a
	tax
	lda.w #$0050
	jsl.l Mul8XS
	asl a
	sta.b r3
	ldx.b curobj
	lda.w Yvel,x
	cmp.w #$8000
	ror a
	clc
	adc.b r3
	sta.w puckvy
	dec.b a0
	dec.b a0
	lda.b [a0]
	cmp.w #$8000
	ror a
	tax
	lda.w #$0050
	jsl.l Mul8XS
	asl a
	sta.b r3
	ldx.b curobj
	lda.w Xvel,x
	cmp.w #$8000
	ror a
	clc
	adc.b r3
	sta.w puckvx
	jsl.l RandomWord
	and.w #$0FFF
	sta.w puckvz
; dopass once the puck velocity is set: a goalie never passes back toward his net, then the pass animation
; (SPAgswing / SPApassf); assdumpin ends here too
dopass_swing:
	lda.w position,x
	bne .2
	lda.w pfgoal,x
	beq .t1
	lda.w puckvy
	bmi .1
	bra .2

.t1:
	lda.w puckvy
	bmi .2
.1:
	eor.w #$FFFF
	inc a
	sta.w puckvy
.2:
	lda.w puckvx
	sta.b d0
	lda.w puckvy
	sta.b d1
	jsl.l vtoa
	ldy.w #SPAgswing
	lda.w position,x
	beq .1x
	ldy.w #SPApassf
	jsl.l Findhittype
	beq .1x
	ldy.w #SPApassb
.1x:
	sty.b d1
	jsl.l SetSPA
	lda.w #$0001
	sta.w pfalock,x
	lda.w position,x
	bne .rtl
	lda.w playerpad,x
	bmi .rtl
	stz.w Xvel,x
	stz.w Yvel,x
	sta.b d4
	jsl.l findpc
.rtl:
	rtl
dopass_count:
	jsl.l loadTeamStruct
	lda.w gmclock
	bne .1
	ldy.b a2
	lda.w tmpassatt,y
	inc a
	sta.w tmpassatt,y
.1:
	ldx.w topgoalie,y
	lda.w aidef,x
	lsr a
	clc
	adc.w #$0001
	adc.w temp1,x
	sta.w temp1,x
	lda.b a0
	sta.w passReceiverPlayerNum
	ldx.b a0
	lda.w #$0015
	sta.b d0
	jsl.l assinsert
	ldx.b a3
	ldy.b a0
	lda.w frame,y
	pha
	lda.w attribute,y
	bit.w #$0800
	beq .t1
	lda.w #$0000
	sec
	sbc.w facedir,y
	bra .2

.t1:
	lda.w facedir,y
.2:
	and.w #$0007
	asl a
	tax
	lda.l SPAonetimerf,x
	tax
	lda.l SPAonetimerf&$FF0000,x	;the first frame of SPAonetimerf in that direction:
	;GetHot below takes its hot spot
	ldx.b a3
	ldy.b a0
	sta.w frame,y
	lda.b a0
	jsl.l GetHot
	ldy.b a0
	pla
	sta.w frame,y
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	lda.w #$0018
	sta.b d6
	lda.b d6
	asl a
	asl a
	asl a
	asl a
	ldy.b a0
	ldx.w Xvel,y
	jsl.l Mul16XS
	lda.b r2+2
	clc
	adc.b d0
	sta.b d2
	lda.b d6
	asl a
	asl a
	asl a
	asl a
	ldx.w Yvel,y
	jsl.l Mul16XS
	lda.b r2+2
	clc
	adc.b d1
	sta.b d3
	ldy.b d2
	jsl.l ApproxLength
	sta.b d4
	asl a
	tax
	lda.w #$0003
	jsl.l DivX8U
	cmp.w #$0040
	bcc .t1x
	cmp.w #$0050
	bcc .4
	ldx.b d4
	lda.w #$0005
	jsl.l DivX8U
	sta.b d6
	lda.w #$0050
	bra .3

.t1x:
	lda.b d4
	lsr a
	lsr a
	sta.b d6
	lda.w #$0040
.3:
	pha
	lda.b d6
	asl a
	asl a
	asl a
	asl a
	ldy.b a0
	ldx.w Xvel,y
	jsl.l Mul16XS
	lda.b r2+2
	clc
	adc.b d0
	sta.b d2
	lda.b d6
	asl a
	asl a
	asl a
	asl a
	ldx.w Yvel,y
	jsl.l Mul16XS
	lda.b r2+2
	clc
	adc.b d1
	sta.b d3
	ldy.b d2
	jsl.l ApproxLength
	sta.b d4
	pla
.4:
	sta.b d5
	sta.w passspeed
	ldx.b curobj
	lda.w #$0010
	sec
	sbc.w passacc,x
	jsl.l randomd0s
	clc
	adc.b d5
	sta.b d5
	ldx.b d2
	jsl.l Mul16x8XS
	lda.b d4
	sta.b r1
	jsl.l Div32S
	lda.b r0
	xba
	and.w #$FF00
	sta.w puckvx
	lda.b d5
	ldx.b d3
	jsl.l Mul16x8XS
	lda.b d4
	sta.b r1
	jsl.l Div32S
	lda.b r0
	xba
	and.w #$FF00
	sta.w puckvy
	lda.b d2
	clc
	adc.w puckx
	sta.w passtargetx
	lda.b d3
	clc
	adc.w pucky
	sta.w passtargety
	lda.b d4
	asl a
	asl a
	asl a
	sta.w puckvz
	lda.w #$000A
	sta.w nopuck+puckobj
	ldy.b a0
	lda.b d6
	clc
	adc.w #$0006
	sta.w passwait,y
	ldx.b curobj
	lda.b d6
	sta.w nopuck,x
	ldy.b a2
	lda.w playerpad,x
	sta.w passpad,y
	lda.w position,x
	bne .rtl
	lda.w playerpad,x
	bmi .rtl
	stz.w Xvel,x
	stz.w Yvel,x
	lda.w playerpad,x
	sta.b d4
	lda.w passReceiverPlayerNum
	sta.b d0
	jsl.l AssignPadIfFree
	lda.w playerpad,x
	bmi .rtl
	jsl.l findpc
.rtl:
	rtl
