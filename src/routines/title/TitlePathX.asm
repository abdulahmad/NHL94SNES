; A = the x offset of title path step A (Sin)
TitlePathX:							; A = step, returns A = x offset; called from BuildTitlePath
	phx								; keep x and y
	phy
	cmp.w #$0480					; first part of the path?
	bcc .t1							; yes: sine part
	sec
	sbc.w #$0480					; step - $480
	tax
	lda.w #$00C6					; times $C6
	jsl.l Mul16x8U
	lda.w #$0080					; divided by $80
	sta.b r1
	jsl.l Div16U
	lda.b r0
	clc
	adc.w #$0066					; plus $66
	bra .1							; done

.t1:								; sine part
	pha								; keep the step
	tax
	lda.w #$000A					; step * 10
	jsl.l Mul16x8U
	lda.w #$0050					; divided by $50
	sta.b r1
	jsl.l Div16U
	lda.b r0
	clc
	adc.w #$0001					; plus 1 = the angle
	tax
	pla								; step
	phx
	jsl.l Sin						; sine of the angle
	tax
	pla
	jsl.l Mul16x8XS					; times the step
	lda.b r2+1						; product / 256
.1:									; A = x offset
	ply								; restore y and x
	plx
	rts
