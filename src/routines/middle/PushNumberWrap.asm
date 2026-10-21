; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
PushNumberWrap:						; called from AttribRating, DrawPeriodStats, DrawPlayerCard, FillPenalt...
	lda.b d0
	pha
	lda.b d1
	cmp.w #$0002
	bne PushNumberWidth
	lda.b d0
.loop:								; loop: if carry clear go to .t1, ...
	cmp.w #$0064
	bcc .t1
	sbc.w #$0064
	bra .loop

.t1:								; d0 = A
	sta.b d0
PushNumberWidth:					; called from PushNumberWrap
	lda.w #$0000
	sta.b a1+2
	lda.w #PushWidthBuf
	sta.b a1
	lda.b d1						; width
	inc a
	inc a							; plus the length word
	sta.w PushWidthBuf				; length
	tay								; Y = end
	lda.w #$2020					; spaces
	sta.w PushWidthBuf+2
	sta.w PushWidthBuf+4
	sta.w PushWidthBuf+6
	sta.w PushWidthBuf+8
	phx
	lda.b d0						; the number
.loop:								; loop: r2 = A, r1 = $000A, Y - 1, ...
	sta.b r2						; dividend
	lda.w #$000A					; 10
	sta.b r1
	dey								; one character back
	jsl.l Div16x8U					; divide
	lda.w RDMPYL
	sep #$20
	clc
	adc.b #$30						; ASCII
	sta.w PushWidthBuf,y			; store it
	rep #$20						; 16-bit A
	lda.b r0						; quotient
	bne .loop						; more digits
	plx
	pla
	sta.b d0
	lda.b r0
	rtl
