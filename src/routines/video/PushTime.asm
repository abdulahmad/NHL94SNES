; a1 = the time d0 (seconds) as a minutes:seconds string.
PushTime:							; called from AttribStatus, FillPenaltyPage, FillScoringPage, PrintTeam...
	lda.w #$0000
	sta.b a1+2
	lda.w #mesareaEnd
	sta.b a1
	lda.b d0						; seconds
	sta.b r2
	lda.w #$000A					; 10
	sta.b r1
	jsl.l Div16x8U					; divide
	dec.b a1						; one character back
	sep #$20						; 8-bit A
	lda.w RDMPYL
	clc
	adc.b #$30						; ASCII
	sta.b [a1]						; store it
	rep #$30						; 16-bit registers
	lda.b r0
	sta.b r2
	lda.w #$0006					; 6
	sta.b r1
	jsl.l Div16x8U					; seconds tens
	dec.b a1						; one character back
	sep #$20						; 8-bit A
	lda.w RDMPYL
	clc
	adc.b #$30
	sta.b [a1]
	rep #$20
	dec.b a1
	sep #$20
	lda.b #$3A						; colon
	sta.b [a1]
	rep #$30						; 16-bit registers
	lda.b r0
	sta.b r2
	lda.w #$000A					; 10
	sta.b r1
	jsl.l Div16x8U					; minutes ones
	dec.b a1						; one character back
	sep #$20						; 8-bit A
	lda.w RDMPYL
	clc
	adc.b #$30
	sta.b [a1]
	rep #$30						; 16-bit registers
	lda.b r0
	beq .noz						; minutes tens present?
	dec.b a1						; one character back
	sep #$20						; 8-bit A
	clc
	adc.b #$30						; ASCII
	sta.b [a1]
	rep #$30						; 16-bit registers
.noz:								; decrement a1, decrement a1, [a1] = mesareaEnd - a1, ...
	dec.b a1						; room for the length word
	dec.b a1
	lda.w #mesareaEnd
	sec
	sbc.b a1
	sta.b [a1]						; length word
	rtl
