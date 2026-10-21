; Aim a computer shot at the open side when the goalie covers the middle of the net
shotdiradj:							; called from doshot
	lda.w playerpad,x
	bmi .t2
	jmp.w .6

.t2:								; playerpad,x negative: d0 = $0008, d1 = $0005, if pfteam,x != 0 go to...
	lda.w #$0008					; default: no direction (8)
org $9EE002
	sta.b d0
	lda.w #$0005					; search 6 players
	sta.b d1
	ldy.w #$0000
	lda.w pfteam,x
	bne .1
	ldy.w #$000C
.1:									; loop: if position,y = 0 go to .t1, ...
	lda.w position,y
	beq .t1
	iny
	iny
	dec.b d1
	bpl .1
	jmp.w .5

.t1:								; position,y = 0: if zero go to .1x, ...
	lda.w Xvel+1,y					; goalie x velocity high byte
	and.w #$00FF
	bit.w #$0080
	beq .1x
	ora.w #$FF00					; sign extend
.1x:								; asl a, ror a, adc Xpos,y, ...
	pha								; half of it
	asl a
	pla
	ror a
	clc
	adc.w Xpos,y					; plus his x
	sec
	sbc.w puckx						; minus the puck x
	sta.b d0						; d0 = dx to the goalie
	lda.w Yvel+1,y					; goalie y velocity high byte
	and.w #$00FF
	bit.w #$0080
	beq .2
	ora.w #$FF00					; sign extend
.2:									; asl a, ror a, adc Ypos,y, ...
	pha								; half of it
	asl a
	pla
	ror a
	clc
	adc.w Ypos,y					; plus his y
	sec
	sbc.w pucky						; minus the puck y
	sta.b d1						; d1 = dy to the goalie
	ldy.b d0
	jsl.l ApproxLength
	sta.b d2
	lda.w #$0012
	sta.b d3
	ldy.w #$0108
	lda.w pfgoal,x
	bne .3
	ldy.w #$FEF8
.3:									; d4 = Y, call CalcAngleOffset, d5 = d4, ...
	sty.b d4
	tya
	pha
	lda.b d3
	pha
	jsr.w CalcAngleOffset
	lda.b d4
	sta.b d5
	pla
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b d3						; post at -x
	pla
	sta.b d4
	jsr.w CalcAngleOffset
	lda.b d4						; sum of both angles
	clc
	adc.b d5
	sta.b d4
	ldx.b a3
	stz.b d0
	lda.b d4
	cmp.w #$FFD3
	bmi .5
	cmp.w #$002D
	bpl .5
	lda.w pfgoal,x
	beq .4
	lda.w #$0000
	sec
	sbc.b d4
	sta.b d4
.4:									; call RandomWord, and #$0003, increment a, ...
	jsl.l RandomWord
	and.w #$0003
	inc a
	sta.b d0
	lda.b d4
	bpl .5
	lda.b d0
	clc
	adc.w #$0004
	sta.b d0
.5:									; passdir = d0
	lda.b d0
	sta.w passdir					; set the pass direction
.6:									; return
	rtl
