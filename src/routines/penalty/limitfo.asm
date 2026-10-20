; Keep the face off spot away from the blue line for every called penalty
limitfo:							; called from Stop4Pen
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
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.w #PenBuf>>16
	sta.b a0+2
	lda.w #PenBuf
	sta.b a0
.loop:								; loop: call .t2, increment a0, increment a0, ...
	lda.b [a0]
	jsl.l .t2
	inc.b a0
	inc.b a0
	lda.b [a0]
	bne .loop
	pla
	sta.b a1+2
	pla
	sta.b a1
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
	rtl

.t2:								; subroutine: and #$00FF, if zero go to .3, ...
	and.w #$00FF
	cmp.w #$0034
	beq .3
	lda.b [a0]
	xba
	and.w #$007F
	asl a
	tay
	lda.w #$0058
	sta.b d1
	lda.w pfgoal,y
	bne .t1
	lda.w #$FFA8
	sta.b d1
	cmp.l foy
	bmi .3
	lda.w #$FFBF
	sta.l foy
	bra .2

.t1:								; pfgoal,y != 0: if d1 - foy >= 0 go to .3, ...
	lda.b d1
	cmp.l foy
	bpl .3
	lda.w #$0041
	sta.l foy
.2:									; d0 = $0046, if fox >= 0 go to .1, ...
	lda.w #$0046
	sta.b d0
	lda.l fox
	bpl .1
	lda.w #$FFBA
	sta.b d0
.1:									; fox = d0
	lda.b d0
	sta.l fox
.3:									; return
	rtl
