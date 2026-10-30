; Look for a good chance to check an opponent
check4check:						; called from assdefd, assnearest
	lda.w #$0014
	sec
	sbc.w checking,x
	sta.b d0
	lda.l OptPen
	beq .1
	asl.b d0
.1:									; call randomd0A, if carry clear go to .2, ...
	lda.b d0
	jsl.l randomd0A					; A = a random number from 0 to A-1
	cmp.w #$0004
	bcc .2
	lda.b d0
	jsl.l randomd0A					; A = a random number from 0 to A-1
	cmp.w #$0004
	bcs .6
.2:									; d2 = $0005, if $0000 >= $000C go to .4, ...
	lda.w #$0005
	sta.b d2
	ldy.w #$0000
	cpx.w #$000C
	bcs .4
	ldy.w #$000C
.4:									; loop: a0 = Y, if position,y = 0 go to .5, ...
	sty.b a0
	lda.w position,y
	beq .5
	lda.w SPA,y
	cmp.w #SPAHold2
	bcc .3
	cmp.w #$F46B
	bcc .7
.3:									; if pfalock,y = 0 go to .7
	lda.w pfalock,y
	beq .7
.5:									; Y + 1, Y + 1, decrement d2, ...
	ldy.b a0
	iny
	iny
	dec.b d2
	bpl .4
.6:									; return
	rtl
.7:									; d0 = Xpos,y - Xpos,x, if minus go to .5, ...
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d0
	cmp.w #$FFDE
	bmi .5
	cmp.w #$0022
	bpl .5
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d1
	cmp.w #$FFDE
	bmi .5
	cmp.w #$0022
	bpl .5
	jsl.l vtoa						; direction of the vector d0 / d1
	lda.b d0
	cmp.w facedir,x
	bne .5
	lda.w Xpos,x
	cmp.w #$004A
	bpl .5x
	cmp.w #$FFB6
	bmi .5x
	lda.w pfgoal,x
	bne .4x
	lda.w Ypos,x
	cmp.w #$0058
	bmi .5x
	cmp.w #$0108
	bpl .5x
.2x:								; if SPA,y < SPAHold2 go to .1x, ...
	lda.w SPA,y
	cmp.w #SPAHold2
	bcc .1x
	cmp.w #$F46B
	bcc .8
.1x:								; if seed+1 & $0007 = 0 go to .8
	lda.w seed+1
	and.w #$0007
	beq .8
.3x:								; go to Acheck
	jml.l Acheck					; hook or hold the chosen player
.4x:								; pfgoal,x != 0: if Ypos,x - $FFA8 >= 0 go to .5x, ...
	lda.w Ypos,x
	cmp.w #$FFA8
	bpl .5x
	cmp.w #$FEF8
	bpl .2x
.5x:								; if seed+1 & $0007 != 0 go to .8, ...
	lda.w seed+1
	and.w #$0007
	bne .8
	jmp.w .3x
.8:									; go to burst
	jml.l burst						; speed burst by player X
