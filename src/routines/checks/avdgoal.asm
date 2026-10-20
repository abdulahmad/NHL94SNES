; Do not skate through the goal: aim beside the net when the path crosses it
avdgoal:							; called from assgoalietopuck, skateto, skatetopuck
	phb
	phk								; data bank = program bank
	plb
	stz.b tmp2
	lda.w Xpos,x
	sta.b p0
	lda.w Ypos,x
	sta.b p0+2
	lda.b d0
	sta.b p1
	lda.b d1
	sta.b p1+2
	lda.w position,x
	bne .t1
	jmp.w .28

.t1:								; position,x != 0: call .27, r3 = $00E4, r3+2 = $011D, ...
	ldx.w #$00E5
	ldy.w #$011C
	jsr.w .27
	ldx.w #$00E4
	ldy.w #$011D
	stx.b r3
	sty.b r3+2
	lda.w #$0108
	sta.b r6+2
	lda.w topgoalie
	sta.b r6
	lda.b tmp2
	bne .t2
	ldx.w #$FEE4
	ldy.w #$FF1B
	jsr.w .27
	ldx.w #$FEE3
	ldy.w #$FF1C
	stx.b r3
	sty.b r3+2
	lda.w #$FEF8
	sta.b r6+2
	lda.w botgoalie
	sta.b r6
	lda.b tmp2
	bne .2
	ldx.b curobj
	plb
	rtl

.t2:								; tmp2 != 0: r3 = r3+2, r3+2 = r3, p0+2 = -(p0+2), ...
	lda.b r3
	ldy.b r3+2
	sty.b r3
	sta.b r3+2
	lda.b p0+2
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b p0+2
	lda.b p1+2
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b p1+2
	lda.b tmp0
	bit.w #$000A
	beq .1
	eor.w #$000A
	sta.b tmp0
.1:									; if tmp1 bits $000A clear go to .2, ...
	lda.b tmp1
	bit.w #$000A
	beq .2
	eor.w #$000A
	sta.b tmp1
.2:									; if tmp1 = 0 go to .t1x, ...
	lda.b tmp1
	beq .t1x
	ldx.b tmp0
	jsr (.26,x)
	ldx.b curobj
	plb
	rtl

.t1x:								; tmp1 = 0: call .t2x, return
	jsr.w .t2x
	ldx.b curobj
	plb
	rtl

.t2x:								; subroutine: if p0+2 - $FEF8 >= 0 go to .t1xx, ...
	ldx.b curobj
	lda.b p0+2
	cmp.w #$FEF8
	bpl .t1xx
	lda.b p1+2
	cmp.w #$FEF8
	bmi .3
	bra .8

.t1xx:								; p0+2 - $FEF8 >= 0: if p1+2 - $FEF8 negative go to .5, ...
	lda.b p1+2
	cmp.w #$FEF8
	bmi .5
	ldy.b r6
	bmi .3
	lda.b p0
	cmp.b p1
	bmi .4
	cmp.w Xpos,y
	bmi .3
	lda.b r3+2
	sta.b d1
.3:									; return
	rts
.4:									; p0 - p1 negative: if plus go to .rts, ...
	cmp.w Xpos,y
	bpl .rts
	lda.b r3+2
	sta.b d1
.rts:								; return
	rts
.5:									; p1+2 - $FEF8 negative: d1 = r3+2, go to .10
	lda.b r3+2
	sta.b d1
	bra .10
.6:									; d0 = $FFCA, return
	lda.w #$FFCA
	sta.b d0
	rts
.7:									; if p0+2 - $FEF8 >= 0 go to .9
	lda.b p0+2
	cmp.w #$FEF8
	bpl .9
.8:									; if p0 - $FFCB negative go to .6, ...
	lda.b p0
	cmp.w #$FFCB
	bmi .6
	cmp.w #$0036
	bpl .17
	lda.b r3
	sta.b d1
	bra .12
.9:									; p0+2 - $FEF8 >= 0: if p1+2 - $FEF8 >= 0 go to .t1xxx, ...
	lda.b p1+2
	cmp.w #$FEF8
	bpl .t1xxx
	lda.b r6+2
	sta.b d1
	ldy.b r6
	bmi .12
	lda.b p0
	cmp.w Xpos,y
	bmi .6
	bra .17

.t1xxx:								; p1+2 - $FEF8 >= 0: if r6 negative go to .13
	ldy.b r6
	bmi .13
.10:								; eor r0+1,s, if plus go to .14, ...
	lda.b p1
	sec
	sbc.w Xpos,y
	pha
	lda.b p0
	sec
	sbc.b p1
	eor.b r0+1,s
	bpl .14
	pla
	lda.b p0
	cmp.w Xpos,y
	bpl .17
	bra .23
.11:								; d1 = r3+2, if tmp1 & $0008 != 0 go to .13
	lda.b r3+2
	sta.b d1
	lda.b tmp1
	and.w #$0008
	bne .13
.12:								; if p1 >= 0 go to .t1xxxx, ...
	lda.b p1
	bpl .t1xxxx
	cmp.w #$FFCB
	bmi .13
	lda.w #$FFCA
	sta.b d0
	rts

.t1xxxx:							; p1 >= 0: if plus go to .13, ...
	cmp.w #$0036
	bpl .13
	lda.w #$0036
	sta.b d0
.13:								; return
	rts
.14:								; return
	pla
	rts
.15:								; if tmp1 != $0010 go to .17
	lda.b tmp1
	cmp.w #$0010
	bne .17
.16:								; d1 = r3+2, return
	lda.b r3+2
	sta.b d1
	rts
.17:								; d0 = $0036, return
	lda.w #$0036
	sta.b d0
	rts
.18:								; d0 = $0036, if tmp1 & $000A = 0 go to .16, ...
	lda.w #$0036
	sta.b d0
	lda.b tmp1
	and.w #$000A
	beq .16
	rts
.19:								; if tmp1 != $0010 go to .17
	lda.b tmp1
	cmp.w #$0010
	bne .17
.20:								; d1 = r3, return
	lda.b r3
	sta.b d1
	rts
.21:								; d1 = r3, if tmp1 & $0002 != 0 go to .12, ...
	lda.b r3
	sta.b d1
	lda.b tmp1
	and.w #$0002
	bne .12
	rts
.22:								; if tmp1 = $0004 go to .20
	lda.b tmp1
	cmp.w #$0004
	beq .20
.23:								; d0 = $FFCA, return
	lda.w #$FFCA
	sta.b d0
	rts
.24:								; d0 = $FFCA, if tmp1 & $000A = 0 go to .16, ...
	lda.w #$FFCA
	sta.b d0
	lda.b tmp1
	and.w #$000A
	beq .16
	rts
.25:								; if tmp1 = $0004 go to .16
	lda.b tmp1
	cmp.w #$0004
	beq .16
.1x:								; d0 = $FFCA, return
	lda.w #$FFCA
	sta.b d0
	rts
.26:								; jump table for jsr (.26,x)
	dw .7,.11,.18,.15,.21,$0000,.19
	dw $0000,.24,.25,$0000,$0000,.22
.27:								; subroutine: r3 = X, r3+2 = Y, tmp0 = 0, ...
	stx.b r3
	sty.b r3+2
	stz.b tmp0
	stz.b tmp1
	ldx.b p0+2
	ldy.b p1+2
	cpx.b r3
	bpl .4x
	lda.w #$0008
	sta.b tmp0
	cpy.b r3
	bpl .5x
.1xx:								; return
	rts
.2x:								; if minus go to .6x, ...
	cpy.b r3+2
	bmi .6x
	lda.w #$0002
	sta.b tmp1
	bra .6x
.3x:								; p1 - $002C negative: if minus go to .7x, ...
	cpy.w #$002C
	bmi .7x
	lda.b tmp1
	ora.w #$0004
	sta.b tmp1
	bra .7x
.4x:								; p1+2 - r3 >= 0: if plus go to .5x, ...
	cpy.b r3
	bpl .5x
	lda.w #$0008
	sta.b tmp1
.5x:								; if minus go to .2x, ...
	cpx.b r3+2
	bmi .2x
	lda.w #$0002
	sta.b tmp0
	cpy.b r3+2
	bpl .1xx
.6x:								; if p1 - $002C negative go to .3x, ...
	ldx.b p0
	ldy.b p1
	cpx.w #$002C
	bmi .3x
	lda.b tmp0
	ora.w #$0004
	sta.b tmp0
	cpy.w #$002C
	bpl .1xx
.7x:								; if plus go to .2xx, ...
	cpx.w #$FFD4
	bpl .2xx
	lda.b tmp0
	ora.w #$0010
	sta.b tmp0
	cpy.w #$FFD4
	bmi .1xx
.1xxx:								; increment tmp2, return
	inc.b tmp2
	rts
.2xx:								; if plus go to .1xxx, ...
	cpy.w #$FFD4
	bpl .1xxx
	lda.b tmp1
	ora.w #$0010
	sta.b tmp1
	inc.b tmp2
	rts
.28:								; call .48, r3 = $0101, r3+2 = $011D, ...
	ldx.w #$0102
	ldy.w #$011C
	jsr.w .48
	ldx.w #$0101
	ldy.w #$011D
	stx.b r3
	sty.b r3+2
	lda.b tmp2
	bne .t1xxxxx
	ldx.w #$FEE4
	ldy.w #$FEFE
	jsr.w .48
	ldx.w #$FEE3
	ldy.w #$FEFF
	stx.b r3
	sty.b r3+2
	lda.b tmp2
	bne .2xxx
	ldx.b curobj
	plb
	rtl

.t1xxxxx:							; tmp2 != 0: r3 = r3+2, r3+2 = r3, p0+2 = -(p0+2), ...
	lda.b r3
	ldy.b r3+2
	sty.b r3
	sta.b r3+2
	lda.b p0+2
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b p0+2
	lda.b p1+2
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b p1+2
	lda.b tmp0
	bit.w #$000A
	beq .1xxxx
	eor.w #$000A
	sta.b tmp0
.1xxxx:								; if tmp1 bits $000A clear go to .2xxx, ...
	lda.b tmp1
	bit.w #$000A
	beq .2xxx
	eor.w #$000A
	sta.b tmp1
.2xxx:								; if tmp1 = 0 go to .t1xxxxxx, ...
	lda.b tmp1
	beq .t1xxxxxx
	ldx.b tmp0
	jsr (.47,x)
	ldx.b curobj
	plb
	rtl

.t1xxxxxx:							; tmp1 = 0: call .t3, return
	jsr.w .t3
	ldx.b curobj
	plb
	rtl

.t3:								; subroutine: if p0+2 - $FEF8 >= 0 go to .t1xxxxxxx, ...
	ldx.b curobj
	lda.b p0+2
	cmp.w #$FEF8
	bpl .t1xxxxxxx
	lda.b p1+2
	cmp.w #$FEF8
	bmi .t2xx
	bra .31

.t1xxxxxxx:							; p0+2 - $FEF8 >= 0: if p1+2 - $FEF8 >= 0 go to .t2xx, ...
	lda.b p1+2
	cmp.w #$FEF8
	bpl .t2xx
	bra .33

.t2xx:								; return
	rts

.t1xxxxxxxx:						; if plus go to .36, ...
	cmp.w Xpos,y
	bpl .36
	lda.b r3+2
	sta.b d1
	rts
.29:								; p0 - $FFDB negative: d0 = $FFDA, return
	lda.w #$FFDA
	sta.b d0
	rts
.30:								; if p0+2 - $FEF8 >= 0 go to .32
	lda.b p0+2
	cmp.w #$FEF8
	bpl .32
.31:								; if p0 - $FFDB negative go to .29, ...
	lda.b p0
	cmp.w #$FFDB
	bmi .29
	cmp.w #$0026
	bpl .39
	lda.b r3
	sta.b d1
	bra .35
.32:								; p0+2 - $FEF8 >= 0: if tmp1 bit $0002 set go to .36
	lda.b tmp1
	bit.w #$0002
	bne .36
.33:								; d1 = r3+2, go to .35
	lda.b r3+2
	sta.b d1
	bra .35
.34:								; d1 = r3+2, if tmp1 & $0008 != 0 go to .36
	lda.b r3+2
	sta.b d1
	lda.b tmp1
	and.w #$0008
	bne .36
.35:								; if p1 >= 0 go to .t1xxxxxxxxx, ...
	lda.b p1
	bpl .t1xxxxxxxxx
	cmp.w #$FFDB
	bmi .36
	lda.w #$FFDA
	sta.b d0
	rts

.t1xxxxxxxxx:						; p1 >= 0: if plus go to .36, ...
	cmp.w #$0026
	bpl .36
	lda.w #$0026
	sta.b d0
.36:								; return
	rts
.37:								; if tmp1 != $0010 go to .39
	lda.b tmp1
	cmp.w #$0010
	bne .39
.38:								; d1 = r3+2, return
	lda.b r3+2
	sta.b d1
	rts
.39:								; d0 = $0026, return
	lda.w #$0026
	sta.b d0
	rts
.40:								; d0 = $0026, if tmp1 & $000A = 0 go to .38, ...
	lda.w #$0026
	sta.b d0
	lda.b tmp1
	and.w #$000A
	beq .38
	rts
.41:								; if tmp1 != $0010 go to .39
	lda.b tmp1
	cmp.w #$0010
	bne .39
.42:								; d1 = r3, return
	lda.b r3
	sta.b d1
	rts
.43:								; d1 = r3, if tmp1 & $0002 != 0 go to .35, ...
	lda.b r3
	sta.b d1
	lda.b tmp1
	and.w #$0002
	bne .35
	rts
.44:								; if tmp1 = $0004 go to .42, ...
	lda.b tmp1
	cmp.w #$0004
	beq .42
	lda.w #$FFDA
	sta.b d0
	rts
.45:								; d0 = $FFDA, if tmp1 & $000A = 0 go to .38, ...
	lda.w #$FFDA
	sta.b d0
	lda.b tmp1
	and.w #$000A
	beq .38
	rts
.46:								; if tmp1 = $0004 go to .38, ...
	lda.b tmp1
	cmp.w #$0004
	beq .38
	lda.w #$FFDA
	sta.b d0
	rts
.47:								; jump table for jsr (.47,x)
	dw .30,.34,.40,.37,.43,$0000,.41
	dw $0000,.45,.46,$0000,$0000,.44
.48:								; subroutine: r3 = X, r3+2 = Y, tmp0 = 0, ...
	stx.b r3
	sty.b r3+2
	stz.b tmp0
	stz.b tmp1
	ldx.b p0+2
	ldy.b p1+2
	cpx.b r3
	bpl .4xx
	lda.w #$0008
	sta.b tmp0
	cpy.b r3
	bpl .5xx
.1xxxxx:							; return
	rts
.2xxxx:								; if minus go to .6xx, ...
	cpy.b r3+2
	bmi .6xx
	lda.w #$0002
	sta.b tmp1
	bra .6xx
.3xx:								; p1 - $0024 negative: if minus go to .7xx, ...
	cpy.w #$0024
	bmi .7xx
	lda.b tmp1
	ora.w #$0004
	sta.b tmp1
	bra .7xx
.4xx:								; p1+2 - r3 >= 0: if plus go to .5xx, ...
	cpy.b r3
	bpl .5xx
	lda.w #$0008
	sta.b tmp1
.5xx:								; if minus go to .2xxxx, ...
	cpx.b r3+2
	bmi .2xxxx
	lda.w #$0002
	sta.b tmp0
	cpy.b r3+2
	bpl .1xxxxx
.6xx:								; if p1 - $0024 negative go to .3xx, ...
	ldx.b p0
	ldy.b p1
	cpx.w #$0024
	bmi .3xx
	lda.b tmp0
	ora.w #$0004
	sta.b tmp0
	cpy.w #$0024
	bpl .1xxxxx
.7xx:								; if plus go to .2xxxxx, ...
	cpx.w #$FFDC
	bpl .2xxxxx
	lda.b tmp0
	ora.w #$0010
	sta.b tmp0
	cpy.w #$FFDC
	bmi .1xxxxx
.1xxxxxx:							; increment tmp2, return
	inc.b tmp2
	rts
.2xxxxx:							; if plus go to .1xxxxxx, ...
	cpy.w #$FFDC
	bpl .1xxxxxx
	lda.b tmp1
	ora.w #$0010
	sta.b tmp1
	inc.b tmp2
	rts
