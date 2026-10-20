; Check object X against the objects near it in y
checkplcoll:
	lda.w pflags,x
	bit.w #$8000
	bne .rtl
	cpx.w #$0018
	bcc .t2
.rtl:
	rtl

.t2:								; X's index in the sorted list
	lda.w OOlistpos,x				; d1 = position of X in OOlist
	sta.b d1						; X's index in the sorted list
.loop:
	ldy.b d1
	cpy.w #$000F
	beq .t1
	lda.w OOlist+1,y
	and.w #$00FF
	tay
	lda.w Ylist,y					; its y
	sec
	sbc.b d3						; minus the y of X
	sec
	sbc.w #$000E
	bpl .t1
	lda.w position,y
	bmi .1
	lda.w Xpos,y					; its x
	sec
	sbc.b d2						; minus the x of X
	cmp.w #$FFF1
	bmi .1
	cmp.w #$000F
	bpl .1
	lda.w pflags,y
	and.w #$8000
	ora.w pfnc,y
	bne .1
	cpy.w #$0018
	bcs .1
	jsl.l .t3
.1:
	inc.b d1
	bra .loop

.t1:
	lda.w OOlistpos,x
	beq .rtlx
	sta.b d1
.loopx:
	ldy.b d1
	lda.w OOlist-1,y				; next object down the list
	and.w #$00FF
	tay
	lda.b d3
	sec
	sbc.w Ylist,y					; y of X minus its y
	sec
	sbc.w #$000E
	bpl .rtlx
	lda.w position,y
	bmi .1x
	lda.w Xpos,y					; its x
	sec
	sbc.b d2						; minus the x of X
	cmp.w #$FFF1
	bmi .1x
	cmp.w #$000F
	bpl .1x
	lda.w pflags,y
	and.w #$8000
	ora.w pfnc,y
	bne .1x
	cpy.w #$0018
	bcs .1x
	jsl.l .t3
.1x:
	dec.b d1
	bne .loopx
.rtlx:
	rtl

.t3:
	lda.b d0
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d3
	pha
	lda.b d4
	pha
	lda.b d5
	pha
	sty.b a2
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d2
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d3
	ldy.b d2
	jsl.l ApproxLength
	cmp.w #$0010
	bmi .t1x
	jmp.w .10

.t1x:
	ldy.b a2
	lda.w Xvel,x
	sec
	sbc.w Xvel,y
	sta.b d0
	lda.w Yvel,x
	sec
	sbc.w Yvel,y
	sta.b d1
	lda.b d0
	ora.b d1
	bne .t2x
	jmp.w .10

.t2x:
	lda.b d1
	pha
	lda.b d0
	pha
	lda.b d3
	ldx.b d1
	jsl.l Mul16x8S
	lda.b r2+2
	sta.b d1+2
	lda.b r2
	sta.b d1
	lda.b d2
	ldx.b d0
	jsl.l Mul16x8S
	ldx.b a3
	lda.b r2
	clc
	adc.b d1
	sta.b d1
	lda.b r2+2
	adc.b d1+2
	sta.b d1+2
	bpl .t1xx
	jmp.w .11

.t1xx:
	lda.w SPA,x
	cmp.w #SPAHold2
	bcc .2
	cmp.w #$F46B
	bcs .2
	stz.w pfalock,x
	stz.w pf2aip,x
	ldy.w impactp,x
	lda.w SPA,y
	cmp.w #SPAHold2
	bcc .1x2
	cmp.w #$F46B
	bcs .1x2
	lda.w #$0000
	sta.w pfalock,y
	sta.w pf2aip,y
.1x2:
	ldy.b a2
.2:
	lda.w SPA,y
	cmp.w #SPAHold2
	bcc .4
	cmp.w #$F46B
	bcs .4
	lda.w #$0000
	sta.w pfalock,y
	sta.w pf2aip,y
	ldx.w impactp,y
	lda.w SPA,x
	cmp.w #SPAHold2
	bcc .3
	cmp.w #$F46B
	bcs .3
	stz.w pfalock,x
	stz.w pf2aip,x
.3:
	ldx.b a3
.4:
	lda.b d1+1
	sta.b d1
	lda.w pfteam,x
	cmp.w pfteam,y
	beq .9
	lda.b d1
	lsr a
	lsr a
	lsr a
	lsr a
	cmp.w #$0005
	bcs .5
	lda.w #$0005
.5:
	sta.b d4
	lda.w SPA,x
	cmp.w #SPAsweepchk
	bcc .7
	cmp.w #$F343
	bcs .7
.6:
	lda.b d4
	lsr a
	adc.b d4
	sta.b d4
	bra .8
.7:
	lda.w SPA,y
	cmp.w #SPAsweepchk
	bcc .8
	cmp.w #$F343
	bcc .6
.8:
	lda.b d4
	clc
	adc.w impact,x
	sta.w impact,x
	lda.b d4
	clc
	adc.w impact,y
	sta.w impact,y
	txa
	sta.w impactp,y
	tya
	sta.w impactp,x
	lda.b d4
	cmp.w #$0014
	bcc .2x
	cpx.w puckc
	beq .1xx
	cpy.w puckc
	bne .2x
.1xx:
	jsl.l CollisionSfx
.2x:
	lda.b d1
	pha
	lda.b d2
	pha
	lda.b d3
	pha
	jsl.l checkint
	jsl.l checkcheck
	pla
	sta.b d3
	pla
	sta.b d2
	pla
	sta.b d1
.9:
	lda.b d1
	sta.b d4
	pla
	sta.b d0
	pla
	sta.b d1
	lda.w collflag
	bpl .t1xxx
	jmp.w .10

.t1xxx:
	lda.b d2
	ldx.b d1
	jsl.l Mul16x8S
	lda.b r2+2
	sta.b d1+2
	lda.b r2
	sta.b d1
	lda.b d3
	ldx.b d0
	jsl.l Mul16x8S
	lda.b r2
	sec
	sbc.b d1
	sta.b d1
	lda.b r2+2
	sbc.b d1+2
	sta.b d1+2
	lda.b d1+1
	sta.b d5
	ldx.b a3
	lda.w weight,x
	clc
	adc.w #$008C
	sta.b d0
	ldy.b a2
	lda.w weight,y
	clc
	adc.w #$008C
	sta.b d1
	lda.b d1
	clc
	adc.b d0
	sta.b d1
	lda.b d0
	ldx.b d4
	jsl.l Mul16x8XS
	lda.b d1
	sta.b r1
	jsl.l Div32S
	lda.b r0
	sta.b d0
	sta.b d1
	lda.b d3
	ldx.b d5
	jsl.l Mul16x8S
	lda.b r2
	sta.b tmp0
	lda.b d2
	ldx.b d0
	jsl.l Mul16x8S
	lda.b r2
	clc
	adc.b tmp0
	ldx.b a3
	clc
	adc.w Xvel,y
	sta.w Xvel,x
	lda.b d2
	ldx.b d5
	jsl.l Mul16x8S
	lda.b r2
	sta.b tmp0
	lda.b d3
	ldx.b d0
	jsl.l Mul16x8S
	lda.b r2
	sec
	sbc.b tmp0
	ldx.b a3
	clc
	adc.w Yvel,y
	sta.w Yvel,x
	lda.b d2
	ldx.b d1
	jsl.l Mul16x8S
	lda.b r2
	clc
	adc.w Xvel,y
	sta.w Xvel,y
	lda.b d3
	ldx.b d1
	jsl.l Mul16x8S
	lda.b r2
	clc
	adc.w Yvel,y
	sta.w Yvel,y
	ldx.b a3
	lda.w #$FFFF
	sta.w collflag
.10:
	pla
	sta.b d5
	pla
	sta.b d4
	pla
	sta.b d3
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0
	rtl
.11:
	pla
	pla
	bra .10
