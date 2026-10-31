; Show the little warning referee when a teammate is over the blue line
checkob:							; called from asspuckc, doinput
	lda.w gmode
	bit.w #gmoffs
	bne .t2
	jmp.w .5

.t2:								; gmode bit gmoffs set: d0 = $0005, if $0000 < $000C go to .1, ...
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.w #$0005
	sta.b d0
	ldy.w #$0000
	cpx.w #$000C
	bcc .1
	ldy.w #$000C
.1:									; a0 = Y, d1 = $005C, if pfgoal,x = 0 go to .t1, ...
	sty.b a0
	lda.w #$005C
	sta.b d1
	lda.w pfgoal,x
	beq .t1
	jmp.w .7

.t1:								; pfgoal,x = 0: d1 = $FFA4, if zero go to .1x, ...
	lda.w #$FFA4
	sta.b d1
	sec
	sbc.w pucky						; puck not in this zone: no offside
	beq .1x
	bpl .3
.1x:								; loop: if position,y negative go to .2, ...
	ldy.b a0
	lda.w position,y
	bmi .2
	lda.b d1
	sec
	sbc.w Ypos,y
	beq .2
	bpl .6
.2:									; increment a0, increment a0, decrement d0, ...
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .1x
.3:									; d0 = $0040, trb sflags, if zero go to .4, ...
	lda.w #$0040
	sta.b d0
	lda.w #$8000
	trb.w sflags
	beq .4
	lda.l refwindow
	bne .4
	lda.w #$0005
	sta.b d0
	lda.w #$0005
	sta.b d1
	lda.l blankchar
	sta.b d2
	lda.w #$0002
	sta.w printx
	sta.w printy
	jsl.l eraser
.4:									; a0+2 = pulled value, a0 = pulled value, d1+2 = pulled value, ...
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
.5:									; return
	rtl
.6:									; d0 = $0006, tsb sflags, if not zero go to .4, ...
	lda.w #$0006					; d0 = 6
	sta.b d0
	lda.w #$8000
	tsb.w sflags
	bne .4
	lda.w RefCnt
	bpl .4
	jsl.l PushRef					; draws a referee frame
	bra .4
.7:									; if d1 - pucky negative go to .3
	lda.b d1
	cmp.w pucky
	bmi .3
.loop:								; loop: if position,y negative go to .1xx, ...
	ldy.b a0
	lda.w position,y
	bmi .1xx
	lda.b d1
	cmp.w Ypos,y
	bmi .6
.1xx:								; increment a0, increment a0, decrement d0, ...
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .loop
	bra .3
