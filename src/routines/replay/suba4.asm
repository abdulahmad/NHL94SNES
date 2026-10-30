; Move the replay one frame back
suba4:								; called from ReplayMode
	lda.b a4						; a4
	cmp.w #replaystart		; start of the buffer
	bne .a4ne
	lda.b a4+2						; bank
	cmp.w #replaystart>>16
	bne .a4ne
	lda.w sflags					; flags
	bit.w #sfwrap
	beq .t3							; not wrapped: stay
	lda.w #replayend>>16
	sta.b a4+2
	lda.w #replayend
	sta.b a4
.a4ne:								; a4 = a4 - replaysize, a4+2 = a4+2 - $0000, if a4 = recbpr go...
	lda.b a4						; a4
	sec
	sbc.w #replaysize				; one frame back
	sta.b a4
	lda.b a4+2
	sbc.w #$0000					; carry
	sta.b a4+2
	lda.b a4
	cmp.w recbpr			; compare with the pointer
	beq .t2							; equal
	jml.l RestoreReplayFrame		; restore the frame

.t2:								; a4 = recbpr: if a4+2 = recbpr+2 go to .t1, ...
	lda.b a4+2						; high word
	cmp.w recbpr+2
	beq .t1							; equal
	jml.l RestoreReplayFrame		; restore the frame

.t1:								; a4+2 = recbpr+2: a4 = a4 + replaysize, if carry clear go to...
	lda.b a4						; undo the move
	clc
	adc.w #replaysize
	sta.b a4						; a4
	bcc .1
	inc.b a4+2
.1:									; if not zero go to .2, ...
	cmp.w #replayend
	bne .2
	lda.b a4+2
	cmp.w #replayend>>16
	bne .2
	lda.w #replaystart>>16
	sta.b a4+2
	lda.w #replaystart
	sta.b a4
.2:									; d7 = 0, return
	stz.b d7
	rtl

.t3:								; sflags bits sfwrap clear: call RestoreReplayFrame, d7 = 0, return
	jsl.l RestoreReplayFrame		; restore the frame
	stz.b d7						; no extra frames
	rtl
