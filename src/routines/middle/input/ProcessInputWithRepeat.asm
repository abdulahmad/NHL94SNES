; Read the pads with key repeat. A held button repeats after a delay
ProcessInputWithRepeat:				; called from LineEditorExit, LineEditor, PasswordRedraw, PenaltySu...
	lda.b d3						; buttons held
	beq .rtl						; none: leave
	lda.b d2						; d2 = changed buttons
	bne .t1							; a change: restart the delay
	dec.w repeatdelayframes			; count down
	bpl .rtl						; not yet: leave
	lda.w #$0006
	sta.w repeatdelayframes
	lda.b d3						; held buttons count as new presses
	sta.b d1
.rtl:								; return
	rtl

.t1:								; d2 != 0: repeatdelayframes = $0014, return
	lda.w #$0014
	sta.w repeatdelayframes
	rtl
