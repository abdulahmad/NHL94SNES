; Turn goalie X's facing one step toward d0, at most one step per 6 ticks ($0BCB,x)
AdjustFacingDirection:
	lda.w facedir,x
	sta.b r3
	lda.w goalieturnwait,x
	bne .t1
	lda.b d0
	sec
	sbc.b r3
	beq .t1
	eor.w #$FFFF
	inc a
	and.w #$0004
	lsr a
	dec a
	sta.b d0
	clc
	adc.b r3
	and.w #$0007
	sta.w facedir,x
	lda.w #$0006
	sta.w goalieturnwait,x
	rtl

.t1:
	lda.w goalieturnwait,x
	beq .rtl
	sec
	sbc.w timestep
	bpl .1
	lda.w #$0000
.1:
	sta.w goalieturnwait,x
.rtl:
	rtl
