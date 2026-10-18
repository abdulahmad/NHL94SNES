; Move the replay one frame back
suba4:
	lda.b a4
	cmp.w #ReplayBufferStart
	bne .a4ne
	lda.b a4+2
	cmp.w #ReplayBufferStart>>16
	bne .a4ne
	lda.w sflags
	bit.w #sfwrap
	beq .t3
	lda.w #ReplayBufferEnd>>16
	sta.b a4+2
	lda.w #ReplayBufferEnd
	sta.b a4
.a4ne:
	lda.b a4
	sec
	sbc.w #replaysize
	sta.b a4
	lda.b a4+2
	sbc.w #$0000
	sta.b a4+2
	lda.b a4
	cmp.w ReplayBufferPtr
	beq .t2
	jml.l RestoreReplayFrame

.t2:
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	beq .t1
	jml.l RestoreReplayFrame

.t1:
	lda.b a4
	clc
	adc.w #replaysize
	sta.b a4
	bcc .1
	inc.b a4+2
.1:
	cmp.w #ReplayBufferEnd
	bne .2
	lda.b a4+2
	cmp.w #$007E
	bne .2
	lda.w #$007E
	sta.b a4+2
	lda.w #ReplayBufferStart
	sta.b a4
.2:
	stz.b d7
	rtl

.t3:
	jsl.l RestoreReplayFrame
	stz.b d7
	rtl
