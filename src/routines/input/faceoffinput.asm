; Pad input for a player taking a face off
faceoffinput:
	lda.w asscur,x
	cmp.w #$0017
	bne .t2
	lda.w #fodir1>>16
	sta.b a0+2
	lda.w #fodir1
	sta.b a0
	lda.w pfgoal,x
	beq .1
	lda.w #fodir2>>16
	sta.b a0+2
	lda.w #fodir2
	sta.b a0
.1:
	lda.b d0
	sta.b [a0]
	lda.w pf2aip,x
	bne .t2
	lda.b d1
	bit.w #$8000
	beq .t1
	lda.w #$0001
	sta.w pf2aip,x
	lda.w #SPAfaceoff
	jml.l SetSPAFromA

.t1:
	lda.w #SPAfaceoffr
	jml.l SetSPAFromA

.t2:
	rtl
