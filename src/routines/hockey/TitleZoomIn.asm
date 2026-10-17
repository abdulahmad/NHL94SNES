; Title: lower the mode 7 scale $0BFB (M7A / M7D) to $100 a step at a time (TitleDelay); .t2 raises it back to
; $200
TitleZoomIn:
	lda.w TitleM7Scale
.loop:
	dec a
	cmp.w #$0100
	bcc .t1
	sta.w TitleM7Scale
	ldx.w #$0064
	jsr.w TitleDelay
	bra .loop

.t1:
	lda.w #$0100
	sta.w TitleM7Scale
	rts

.t2:
	lda.w TitleM7Scale
.loopx:
	inc a
	cmp.w #$0200
	bcs .t1x
	sta.w TitleM7Scale
	ldx.w #$0200
	jsr.w TitleDelay
	bra .loopx

.t1x:
	lda.w #$0200
	sta.w TitleM7Scale
	rts
