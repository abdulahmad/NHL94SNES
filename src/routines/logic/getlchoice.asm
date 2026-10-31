; d0 = the line for line choice d0 of team a2, by the man advantage. -1 = none.
;
; Takes a2 = team, d0 = choice (0-2). Index = choice + 3 * tmline of the team, plus 21 when the active player
; counts (tmap) of the two teams differ and 21 more when the other team has more. Returns d0 = the byte
; from the table at .tab (sign extended), d1/d2 are kept. Called from lcfound, SetLCmode2 and setlccords.
getlchoice:							; line for choice d0 of team a2
	lda.b d1						; save d1 and d2 (both words)
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	lda.b a2						; other team offset
	eor.w #$0002
	tay
	lda.w tmap,y					; players of the other team
	ldy.b a2						; Y = own team
	sec
	sbc.w tmap,y					; minus own
	sta.b d2						; d2 = difference
	beq .1							; even: first set of lines
	lda.b d0						; players differ: skip 21 entries
	clc
	adc.w #$0015
	sta.b d0
	lda.b d2						; other team has fewer?
	bmi .1							; yes: stop here
	lda.b d0						; other team has more: 21 entries further
	clc
	adc.w #$0015
	sta.b d0
.1:									; add three times the current line
	ldy.b a2						; Y = team offset
	lda.w tmline,y					; current line
	sta.b d1
	lda.b d0						; choice + 3 * line
	clc
	adc.b d1
	clc
	adc.b d1
	clc
	adc.b d1
	sta.b d0
	tay								; Y = table index
	lda.w #.tab>>16					; table bank
	sta.b a0+2
	lda.w #.tab
	sta.b a0
	lda.b [a0],y					; byte from the table
	and.w #$00FF
	bit.w #$0080					; sign extend: bit 7 set?
	beq .sext						; a negative byte: sign extend
	ora.w #$FF00
.sext:								; d0 = line, or -1 for none
	sta.b d0						; d0 = the line, or -1
	pla								; restore d1 and d2
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	rtl
.tab:								; lines for each choice; $FF = none
	db $00,$01,$02,$01,$02,$00,$02,$00,$01,$00,$01,$02,$00,$01,$02,$00
	db $01,$02,$00,$01,$02,$03,$04,$FF,$03,$04,$FF,$03,$04,$FF,$03,$04
	db $FF,$04,$03,$FF,$03,$04,$FF,$03,$04,$FF,$05,$06,$FF,$05,$06,$FF
	db $05,$06,$FF,$05,$06,$FF,$05,$06,$FF,$05,$06,$FF,$06,$05,$FF
