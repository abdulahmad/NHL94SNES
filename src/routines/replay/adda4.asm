; Move the replay one frame forward
adda4:
	stz.b d7
	lda.w sflags
	bit.w #sf2drec
	beq .t2
	lda.b a4+2
	pha
	lda.b a4
	pha
	jsl.l adda43
	lda.b a4+2
	sta.b tmp1
	lda.b a4
	sta.b tmp0
	pla
	sta.b a4
	pla
	sta.b a4+2
	lda.b tmp0
	cmp.w ReplayBufferPtr
	bne .t2
	lda.b tmp1
	cmp.w ReplayBufferPtr+2
	bne .t2
	rtl

.t2:
	lda.b a4
	cmp.w ReplayBufferPtr
	bne .t1
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	bne .t1
	rtl

.t1:
	jsl.l RestoreReplayFrame
adda43:
	lda.b a4
	clc
	adc.w #replaysize
	sta.b a4
	bcc .1
	inc.b a4+2
.1:
	cmp.w #ReplayBufferEnd
	bne .rtl
	lda.b a4+2
	cmp.w #$007E
	bne .rtl
	lda.w #$007E
	sta.b a4+2
	lda.w #ReplayBufferStart
	sta.b a4
.rtl:
	rtl
