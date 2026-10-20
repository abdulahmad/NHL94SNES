; A = the mode 7 scale of title path step A
TitlePathScale:						; A = step, returns A = scale; called from BuildTitlePath
	phx								; keep x and y
	phy
	cmp.w #$0400					; first part of the path?
	bcs .t1							; step $400 or later: second part
	ldx.w #$0E00					; step * $0E00
	jsl.l Mul16U
	lda.b r2+1						; product / 256
	sta.b r2
	lda.w #$0008					; divided by 8
	sta.b r1
	jsl.l Div16S
	asl.b r0						; times 2
	lda.w #$0F00					; scale = $0F00 - that
	bra .1							; subtract

.t1:								; second part of the path
	sec
	sbc.w #$0400					; step - $400
	ldx.w #$00C0					; times $C0
	jsl.l Mul16U
	lda.b r2+1						; product / 256
	sta.b r2
	lda.w #$0002					; divided by 2
	sta.b r1
	jsl.l Div16S
	asl.b r0						; times 2
	lda.w #$0100					; scale = $0100 - that
.1:									; A = start scale - r0
	sec
	sbc.b r0						; result
	ply								; restore y and x
	plx
	rts
