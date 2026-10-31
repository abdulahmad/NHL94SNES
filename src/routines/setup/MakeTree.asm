; Build the playoff tree from the seeds and the series wins
MakeTree:							; called from EncodePW, GameOver, NewPO, setoptions
	stx.b xsave						; keep X
	ldx.w #$0000
.loop:								; loop: X + 1, X + 1, if not zero go to .loop, ...
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .loop
	ldx.b xsave						; restore X
	stx.b xsave						; keep X
	ldx.w #$0000
.loop2:								; loop: X + 1, X + 1, if not zero go to .loop2, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .loop2
	ldx.b xsave						; restore X
	lda.l postarts
	asl a
	asl a
	asl a
	asl a
	sta.b d1
	lda.w #potree>>16
	sta.b a0+2
	lda.w #potree
	sta.b a0
	lda.w #playoffseats
	clc
	adc.b d1
	sta.b a1
	lda.w #playoffseats>>16
	sta.b a1+2
	ldy.w #$000E					; 16 seeds, 8 words
	sty.b d2
.loop3:								; loop: [a0],y = [a1],y, Y - 1, Y - 1, ...
	lda.b [a1],y					; copy the seeds into the tree
	sta.b [a0],y
	dey
	dey
	bpl .loop3
	lda.w #$34E2
	sta.b a1
	lda.b a0+2
	sta.b a1+2
	lda.w WinBits					; win bits of the series so far
	sta.b d0
.loop4:								; loop: d1 = d0 & $0001, [a1] = [a0],y, increment a1, ...
	lda.b d0
	and.w #$0001
	sta.b d1
	tay
	sep #$20						; 8-bit A
	lda.b [a0],y					; copy the winner of the pair
	sta.b [a1]
	rep #$20						; 16-bit A
	inc.b a1
	inc.b a0
	inc.b a0
	lsr.b d0
	dec.b d2
	bpl .loop4
	jsl.l GetShifter				; games of the round less one and its first win bit
	lda.b d1
	bmi .1							; round has no games
	lda.b d2
	asl a
	adc.w #potree
	sta.b a0
	lda.w #potree>>16
	sta.b a0+2
	stz.b a1
.loop5:								; loop: gss1,x = $0000, gss2,x = $0000, gsper,x = $0000, ...
	ldx.b a1
	lda.w #$0000
	sta.l gss1,x
	sta.l gss2,x
	sta.l gsper,x
	lda.l gsflags,x
	and.w #$FFFD
	sta.l gsflags,x
	jsl.l .t2
	inc.b a1
	inc.b a1
	dec.b d1
	bpl .loop5
	jsl.l FigureJoy					; choose the joystick teams
.1:									; xsave = X
	stx.b xsave						; keep X
	ldx.w #$000E
.loop6:								; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop6
	ldx.b xsave						; restore X
	stx.b xsave						; keep X
	ldx.w #$0012
.loop7:								; loop: d0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b d0,x
	dex
	dex
	bpl .loop7
	ldx.b xsave						; restore X
	ldx.b a3
	rtl

.t2:								; subroutine: if bosgames = $0002 go to .t1, ...
	lda.w bosgames
	cmp.w #$0002
	beq .t1
	cmp.w #$0003
	beq .t1
	cmp.w #$0005
	beq .t1
	lda.l gsflags,x
	ora.w #$0001
	sta.l gsflags,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.l gst2,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.l gst1,x
	rtl

.t1:								; gsflags,x = gsflags,x & $FFFE, increment a0, gst1,x = [a0] & $00FF, ...
	lda.l gsflags,x
	and.w #$FFFE
	sta.l gsflags,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.l gst1,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.l gst2,x
	rtl
