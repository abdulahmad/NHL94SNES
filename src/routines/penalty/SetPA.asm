; Start the referee animation for penalty d0 and show its message
;
; SetPA: d0 = penalty number. Starts the referee animation for it (RefPen, RefStep = 0), prepares the
; message (prefmes), shows the goal box for a penalty goal and sets the message timer (shorter in horizontal
; mode). Falls into SetPA2. Called from checkfornewpen, InProgress and Stop4Pen.
SetPA:								; starts the referee animation for penalty d0
	lda.b d0						; RefPen = the penalty
	sta.w RefPen
	stz.w RefStep					; animation at its first step
	jsl.l prefmes					; prepare the message
	lda.b d0						; penalty number
	cmp.w #PenGoal					; PenGoal?
	bne .0							; no
	jsl.l ShowGoalBox				; yes: show the goal box
.0:									; message time
	lda.w #$7FFF					; a long time
	sta.w penmsgtimer
	lda.w sfhormode					; horizontal mode?
	beq SetPA2						; no: keep it
	lda.w #$003C					; only $3C frames
	sta.w penmsgtimer
SetPA2:								; steps the referee animation
	phx								; keep x
	lda.b d0						; save d0 to a1+2 (10 words)
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.w RefStep					; RefStep
	bpl .t1							; not negative: draw the next frame
	lda.w shootoutmode				; shootout?
	beq .skip						; no: skip
	lda.w #$0001					; shootoutstop = 1
	sta.w shootoutstop
.skip:								; RefStep in A
	lda.w RefStep
	bra .2							; leave

.t1:								; next animation frame
	sta.b d0						; d0 = step
	inc.w RefStep					; next step (frame, delay)
	inc.w RefStep
	lda.w RefPen					; current penalty
	sta.b d1
	tax
	lda.l PenaltyList,x				; offset of this penalty's animation in PenaltyList
	inc a
	inc a
	tax								; x = that offset
	clc
	adc.l PenaltyList,x
	adc.b d0						; plus the step
	tax
	lda.l PenaltyList,x				; frame and delay word
	sta.b d0
	bpl .1							; not negative: normal pair
	eor.w #$FFFF					; negative: last pair, use its absolute value
	inc a
	sta.b d0
	lda.w #$FFFF					; RefStep = -1: done
	sta.w RefStep
.1:									; delay in the low byte
	lda.b d0
	and.w #$00FF
	asl a
	asl a
	asl a
	sta.b d1						; d1 = delay times 8
	sta.w RefCnt					; RefCnt = delay times 8
	lda.b d0						; frame in the high byte
	xba
	and.w #$00FF
	sta.b d0
	jsl.l PushRef					; draw the frame
.2:									; restore the registers
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	plx								; restore x
	rtl								; return
