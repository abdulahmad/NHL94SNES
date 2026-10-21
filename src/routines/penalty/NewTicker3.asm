; Show the ticker box for game d3: round, period and both teams with their scores
;
; a0 = game offset. Skips games that are over or have a highlight pending (flags $0006). Draws a framed
; box with the round label, the period label and the two team lines (TickerTeam).
; Called from NewTicker2.
NewTicker3:							; shows the ticker box
	lda.b d3						; d3 = game
	asl a							; times 2
	sta.b a0						; a0 = word offset
	tax								; x = it
	lda.l gsflags,x					; game flags
	bit.w #$0006					; flags $0006: over or highlight pending
	bne NewTicker2					; yes: take the next game
	lda.b a1+2						; save a1 (long pointer)
	pha
	lda.b a1
	pha
	lda.w #NewTicker3Pos>>16		; a1 = NewTicker3Pos
	sta.b a1+2
	lda.w #NewTicker3Pos
	sta.b a1
	jsl.l print						; print the position
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.w sflags					; pause mode?
	bit.w #$0001					; flag sfpz
	bne .pj							; yes: one position is enough
	lda.b a1+2						; save a1
	pha
	lda.b a1
	pha
	lda.w #NewTicker3Pos2>>16		; a1 = NewTicker3Pos2
	sta.b a1+2
	lda.w #NewTicker3Pos2
	sta.b a1
	jsl.l print						; print the second position
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
.pj:								; horizontal rink?
	lda.w sfhormode					; yes: keep the position
	bne .frame						; else y minus 5
	lda.w printy
	sec
	sbc.w #$0005
	sta.w printy					; print y - 5
.frame:								; draw the frame
	lda.w #$001C					; frame $1C wide
	sta.b d0
	lda.w #$0005					; frame 5 high
	sta.b d1
	jsl.l Framer					; draw it
	lda.b vcount					; ticker timer = frame counter
	sta.w tickervc
	inc.w printx					; x + 1
	lda.w printy					; y - 4
	sec
	sbc.w #$0004
	sta.w printy					; print y - 4
	lda.w printx					; keep x on the stack
	pha								; 1,s = x once a1 is restored
	jsl.l GetShifter				; GetShifter
	lda.w #$2400					; text palette
	sta.w printa					; palette for the text
	lda.b a1+2						; save a1
	pha
	lda.b a1
	pha
	lda.w #NewTicker3Pos3>>16		; a1 = NewTicker3Pos3
	sta.b a1+2
	lda.w #NewTicker3Pos3
	sta.b a1
	jsl.l print						; print it
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.b 1,s						; x from the stack
	sta.w printx
	lda.l playoffRoundIdx			; round number + 1
	inc a
	sta.b d0
	lda.l OptPlayMode				; playoffs?
	bne .1							; yes
	stz.b d0						; no: label 0
.1:									; print the round label
	lda.w #GameLabels>>16			; a1 = GameLabels
	sta.b a1+2
	lda.w #GameLabels
	sta.b a1
	jsl.l PrintStringFromList		; print it
	lda.b 1,s						; x plus $15
	clc
	adc.w #$0015
	sta.w printx					; x + $15
	ldx.b a0						; period of this game
	lda.l gsper,x
	dec a							; minus 1: label index
	sta.b d0
	lda.w #PerLabels>>16			; a1 = PerLabels
	sta.b a1+2
	lda.w #PerLabels
	sta.b a1
	jsl.l PrintStringFromList		; print it
	lda.w #$2000					; palette for the scores
	sta.w printa
	ldx.b a0						; first team and score
	lda.l gst1,x					; team
	sta.b d0
	lda.l gss1,x					; score
	sta.b d1
	jsl.l TickerTeam				; print the line
	ldx.b a0						; second team and score
	lda.l gst2,x
	sta.b d0
	lda.l gss2,x
	sta.b d1
	jsl.l TickerTeam				; print the line
	pla								; drop the saved x
	rtl								; return
