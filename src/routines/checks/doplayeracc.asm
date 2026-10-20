; The player skates in direction d0 (or glides or stops), turning toward it
doplayeracc:
	lda.w position,x
	bne .t4
	jml.l goalieacc

.t4:
	lda.w SPA,x
	cmp.w #SPAsweepchk
	beq .t2
	lda.w #SPAglide					; d1 = glide animation
	sta.b d1
	lda.w pfrev,x					; skating backwards?
	beq .1
	lda.w #SPAglideback
	sta.b d1
.1:
	lda.b d0
	and.w #$000F					; low nibble: direction or 8/9
	sta.b d0
	cmp.w #$0008					; 0-7 is a real direction
	bcc .t3
	cmp.w #$0009
	bne .t1
	lda.w Xvel,x
	ora.w Yvel,x
	beq .t1
	jmp.w dostop

.t1:
	lda.w pf2aip,x
	bne .t2
	jmp.w SetSPA

.t2:								; return
	rtl

.t3:								;a direction: pfrev, then the turn
	lda.b d1						; save the animation
	pha
	lda.b d0						; and the wanted direction
	pha
	sta.b d2						; d2 = wanted direction
	cpx.w puckc
	bne .t2x
	jmp.w .4

.t2x:								; dx to the puck
	lda.w puckx						; dx to the puck
	sec
	sbc.w Xpos,x					; minus the x of X
	sta.b d0
	lda.w Ypos,x
	sta.b d3						; d3 = my y
	lda.w puckvy
	xba
	and.w #$00FF
	cmp.w #$0080
	bcc .1x
	ora.w #$FF00
.1x:
	clc
	adc.w pucky						; plus the puck y
	sec
	sbc.b d3						; dy to the puck, led by its y velocity
	sta.b d1
	lda.w pfgoal,x					; mirror for the team shooting toward +y
	bne .2
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
	lda.w #$0000
	sec
	sbc.b d3
	sta.b d3
	lda.b d2						; and the wanted direction
	eor.w #$0004
	sta.b d2
.2:
	lda.w pfrev,x
	bne .t1x
	lda.b d3
	bpl .4
	lda.b d2
	cmp.w #$0004
	bne .4
	jsl.l vtoa						; vector to direction
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .4
	bra .3

.t1x:								; already backwards: stay so only if the wanted direction allows
	lda.b d2						; already backwards: wanted direction 3, 4 or 5
	sec
	sbc.w #$0003
	and.w #$0007
	cmp.w #$0003
	bcs .4
	jsl.l vtoa						; vector to direction
	inc a
	inc a
	and.w #$0007
	cmp.w #$0005
	bcs .4
.3:
	lda.w pfrev,x
	bne .9
	lda.w Xvel,x
	sta.b d0						; moving?
	ora.w Yvel,x
	beq .1xx
	lda.w Yvel,x
	sta.b d1
	jsl.l vtoa						; vector to direction
	sec
	sbc.b r0+1,s
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .9
.1xx:
	inc a
	sta.w pfrev,x
	bra .9
.4:
	stz.w pfrev,x
.9:
	pla								; d0 = wanted direction
	sta.b d0
	pla								; d1 = animation
	sta.b d1
	lda.w facedir,x					; facing direction
	sta.b d2
	lda.b d0
	sec
	sbc.b d2
	and.w #$0007					; d0 = wanted - facing
	asl a
	sta.b d0
	tax
	lda.l .10,x
	ldx.b a3
	cmp.w #$0000
	bne .t2xx
	jmp.w noturn0

.t2xx:
	tax
	lda.b d7
	jsl.l Mul8XS
	ldx.b a3
	sta.b tmp0
	lda.w Xvel,x
	xba
	and.w #$00FF
	cmp.w #$0080
	bcc .1xxx
	ora.w #$FF00
.1xxx:
	tax
	jsl.l Mul8S
	sta.b d4
	ldx.b a3
	lda.w Yvel,x
	xba
	and.w #$00FF
	cmp.w #$0080
	bcc .2x
	ora.w #$FF00
.2x:
	tax
	jsl.l Mul8S
	clc
	adc.b d4
	sta.b d3						; d3 = speed class
	lda.w #$0300					; turn rate base $300
	sec
	sbc.b d3						; falls as speed rises
	sta.b d4
	sec
	sbc.w #$0180					; down to $180
	bpl .3x
	lda.w #$0180
	sta.b d4
.3x:
	lda.b tmp0
	ldx.b d4
	jsl.l Mul16x8S
	lda.b r2+2
	sta.b d4+2
	lda.b r2
	sta.b d4
	ldx.b a3
	lda.w pfrev,x
	beq .4x
	lda.w #$0000
	sec
	sbc.b d4
	sta.b d4
	lda.w #$0000
	sbc.b d4+2
	sta.b d4+2
.4x:
	lda.w facefrac,x				; facing fraction
	clc
	adc.b d4
	sta.w facefrac,x
	lda.w facedir,x					; facing direction
	adc.b d4+2
	and.w #$0007					; 0-7
	sta.w facedir,x
	sta.b d2						; d2 = new facing for playeracc
	lda.b d3
	cmp.w #$0015					; slow: keep the animation
	bcc .7
	stz.b d1
	lda.b tmp0
	bpl .5
	lda.w #$FFCE
	sta.b d1
.5:
	lda.w attribute,x
	bit.w #$0800
	beq .6
	lda.b d1
	eor.w #$FFCE
	sta.b d1
.6:
	lda.b d1
	clc
	adc.w #SPAturnr					; SPAturnr or SPAturnl
	sta.b d1
.7:
	lda.w pf2aip,x
	bne .8
	jsl.l SetSPA
	lda.w #$0001
	sta.w pf2aip,x
.8:
	lda.b d3
	cmp.w #$0003
	bcc .t1xx
	jmp.w revplayeracc

.t1xx:
	rtl
.10:								; steps for eight directions
	dw $0000,$0011,$0011,$0011,$0000,$FFEF,$FFEF,$FFEF
