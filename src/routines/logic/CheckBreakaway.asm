; $1638 = 1 when the puck carrier is in the attacking zone half with no opposing skater (not the goalie)
; between him and the goal, else 0
CheckBreakaway:
	stz.w IsBreakaway
	lda.w puckc
	bpl .t4
	jmp.w .4

.t4:
	lda.w gmode
	bit.w #$0002
	bne .t1
	lda.w puckc
	cmp.w #$000C
	bmi .t3
	bra .t2

.t1:
	lda.w puckc
	cmp.w #$000C
	bmi .t2
	bra .t3

.t2:
	ldy.w puckc
	lda.w Ypos,y
	bpl .4
	sec
	sbc.w #$0004
	sta.b d0
	ldy.w #$0000
	lda.w puckc
	cmp.w #$000C
	bpl .1
	ldy.w #$000C
.1:
	lda.w #$0006
	sta.b d2
.loop:
	lda.w position,y
	bmi .2
	beq .2
	lda.b d0
	sec
	sbc.w Ypos,y
	bpl .4
.2:
	iny
	iny
	dec.b d2
	bpl .loop
	bra .3

.t3:
	ldy.w puckc
	lda.w Ypos,y
	bmi .4
	clc
	adc.w #$0004
	sta.b d0
	ldy.w #$0000
	lda.w puckc
	cmp.w #$000C
	bpl .1x
	ldy.w #$000C
.1x:
	lda.w #$0006
	sta.b d2
.loopx:
	lda.w position,y
	bmi .2x
	beq .2x
	lda.b d0
	sec
	sbc.w Ypos,y
	bmi .4
.2x:
	iny
	iny
	dec.b d2
	bpl .loopx
.3:
	stz.w IsBreakaway
	inc.w IsBreakaway
.4:
	rtl
