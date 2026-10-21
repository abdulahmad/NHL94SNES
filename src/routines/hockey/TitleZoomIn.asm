; Title: lower the mode 7 scale TitleM7Scale (M7A / M7D) to $100 a step at a time (TitleDelay); .t2 raises it
; back to $200
TitleZoomIn:						; no input; called from TitleScreen
	lda.w TitleM7Scale				; current scale
.loop:								; one step
	dec a							; smaller
	cmp.w #$0100					; reached $100?
	bcc .t1							; yes, stop
	sta.w TitleM7Scale				; store
	ldx.w #$0064					; delay of 100 loops
	jsr.w TitleDelay				; wait
	bra .loop						; next step

.t1:								; stop at exactly $100
	lda.w #$0100
	sta.w TitleM7Scale				; store
	rts

.t2:								; zoom back out from the current scale to $200
	lda.w TitleM7Scale
.loopx:								; one step
	inc a							; larger
	cmp.w #$0200					; reached $200?
	bcs .t1x						; yes, stop
	sta.w TitleM7Scale
	ldx.w #$0200					; delay of $200 loops
	jsr.w TitleDelay
	bra .loopx						; next step

.t1x:								; stop at exactly $200
	lda.w #$0200
	sta.w TitleM7Scale
	rts
