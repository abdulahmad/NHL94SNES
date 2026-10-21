; a1 = d0 as a decimal string, no leading zeros.
PushNumber:							; called from AttribWeight, PrintTeamStatRows, TickerTeam, printscores1
	phx
	lda.w #$0000
	sta.b a1+2
	lda.w #mesareaEnd
	sta.b a1
	lda.b d0
.0:									; loop: r2 = A, r1 = $000A, call Div16x8U, ...
	sta.b r2
	lda.w #$000A
	sta.b r1
	jsl.l Div16x8U
	dec.b a1
	sep #$20
	lda.w RDMPYL
	clc
	adc.b #$30						; remainder as ASCII
	sta.b [a1]						; store it
	rep #$30						; 16-bit registers
	lda.b r0
	bne .0							; more digits
	dec.b a1						; room for the length word
	dec.b a1
	lda.w #mesareaEnd
	sec
	sbc.b a1
	sta.b [a1]						; length word
	plx
	rtl
