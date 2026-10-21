; Move the replay one frame forward
adda4:								; called from ReplayMode
	stz.b d7						; no extra frames
	lda.w sflags					; flags
	bit.w #sf2drec
	beq .t2
	lda.b a4+2						; keep a4
	pha
	lda.b a4
	pha
	jsl.l adda43					; next frame in the buffer
	lda.b a4+2
	sta.b tmp1
	lda.b a4
	sta.b tmp0
	pla								; restore a4
	sta.b a4
	pla
	sta.b a4+2
	lda.b tmp0						; compare with the buffer pointer
	cmp.w ReplayBufferPtr
	bne .t2
	lda.b tmp1
	cmp.w ReplayBufferPtr+2
	bne .t2
	rtl								; reached the end

.t2:								; if a4 != ReplayBufferPtr go to .t1, ...
	lda.b a4						; compare a4 with the pointer
	cmp.w ReplayBufferPtr
	bne .t1
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	bne .t1
	rtl

.t1:								; call RestoreReplayFrame
	jsl.l RestoreReplayFrame
adda43:								; called from adda4
	lda.b a4
	clc								; next frame
	adc.w #replaysize
	sta.b a4
	bcc .1
	inc.b a4+2
.1:									; if not zero go to .rtl, ...
	cmp.w #ReplayBufferEnd
	bne .rtl						; not the end of the buffer
	lda.b a4+2
	cmp.w #ReplayBufferEnd>>16
	bne .rtl						; not the end
	lda.w #ReplayBufferStart>>16
	sta.b a4+2
	lda.w #ReplayBufferStart
	sta.b a4
.rtl:								; return
	rtl
