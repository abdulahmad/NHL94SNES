; Assignment: skate to the side of the screen holding the Stanley Cup overhead
assstanley:
	lda.w pflags,x
	bit.w #pfna
	beq .2
	and.w #$FFFD
	sta.w pflags,x
	lda.w #$005A
	sta.w temp3,x
	lda.w Hpos
	bpl .1
	lda.w #$FFA6
	sta.w temp3,x
.1:
	lda.w Vpos
	sta.w temp4,x
	lda.w #SPAstanley
	sta.w pfalock,x
	jsl.l SetSPAFromA
.2:
	lda.w temp3,x
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w temp4,x
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.b d0
	cmp.w #$0008
	bpl .t1
	lda.b d0
	sta.b d2
	sta.w facedir,x
	lda.w #$0014
	sta.w pfalock,x
	jmp.w playeracc

.t1:
	rtl
