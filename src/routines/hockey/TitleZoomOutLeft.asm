; Title: raise the mode 7 scale TitleM7Scale to $200 while the BG1 scroll moves to $120, $140
TitleZoomOutLeft:					; no input; called from TitleScreen
	lda.w TitleM7Scale				; current scale
	inc a							; larger
	cmp.w #$0200					; reached $200?
	bcs .t1							; yes, stop
	sta.w TitleM7Scale				; store
	sec
	sbc.w #$0100					; scale - $100
	pha								; keep it
	ldx.w #$0070					; times $70
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	xba								; high byte: /256
	and.w #$00FF
	eor.w #$FFFF					; negate
	inc a
	clc
	adc.w #$0190					; $190 minus the product
	sta.w TitleM7HOfs				; horizontal offset
	pla								; scale - $100
	ldx.w #$0040					; times $40
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	xba
	and.w #$00FF
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0180					; $180 minus the product
	sta.w TitleM7VOfs				; vertical offset
	ldx.w #$03E8					; delay of 1000 loops
	jsr.w TitleDelay				; wait
	bra TitleZoomOutLeft			; next step

.t1:								; end positions
	lda.w #$0200					; scale $200
	sta.w TitleM7Scale
	lda.w #$0120					; horizontal offset $120
	sta.w TitleM7HOfs
	lda.w #$0140					; vertical offset $140
	sta.w TitleM7VOfs
	rts
