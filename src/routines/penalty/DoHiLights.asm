; Playoffs: play the highlight of each game of the round that has one
DoHiLights:
	lda.l OptPlayMode
	beq .rtl
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.loop:
	ldx.b a0
	lda.l gsflags,x
	bit.w #$0004
	bne .1
	bit.w #$0002
	beq .1
	and.w #$FFFD
	sta.l gsflags,x
	jsl.l SaveRegsStartHL2
.1:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .loop
.rtl:
	rtl
