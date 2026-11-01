; IsBreakaway = 1 when the puck carrier is in the attacking zone half with no opposing skater (not the goalie)
; between him and the goal, else 0
CheckBreakaway:						; called from PenShotChk, StartBreakaway, doshot
	stz.w IsBreakaway
	lda.w puckc
	bpl .t4
	jmp.w .4

.t4:								; puckc >= 0: if gmode bit $0002 set go to .t1, ...
	lda.w gmode
	bit.w #gmdir
	bne .t1
	lda.w puckc
	cmp.w #$000C
	bmi .t3
	bra .t2

.t1:								; gmode bit $0002 set: if puckc - $000C negative go to .t2, ...
	lda.w puckc
	cmp.w #$000C
	bmi .t2
	bra .t3

.t2:								; if Ypos,y >= 0 go to .4, ...
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
.1:									; d2 = $0006
	lda.w #$0006
	sta.b d2
.loop:								; loop: if position,y negative go to .2, ...
	lda.w position,y
	bmi .2
	beq .2
	lda.b d0
	sec
	sbc.w Ypos,y
	bpl .4
.2:									; Y + 1, Y + 1, decrement d2, ...
	iny
	iny
	dec.b d2
	bpl .loop
	bra .3

.t3:								; if Ypos,y negative go to .4, ...
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
.1x:								; d2 = $0006
	lda.w #$0006
	sta.b d2
.loopx:								; loop: if position,y negative go to .2x, ...
	lda.w position,y
	bmi .2x
	beq .2x
	lda.b d0
	sec
	sbc.w Ypos,y
	bmi .4
.2x:								; Y + 1, Y + 1, decrement d2, ...
	iny
	iny
	dec.b d2
	bpl .loopx
.3:									; IsBreakaway = 0, increment IsBreakaway
	stz.w IsBreakaway
	inc.w IsBreakaway
.4:									; return
	rtl
