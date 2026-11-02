; Title: count BG1HScroll down, moving the window edges WH1 (TitleWH1) and WH3 (TitleWH3Low) each step
; (TitleDelay), then close them ($FF)
TitleWindowWipe:					; no input; called from TitleScreen
	lda.w BG1HScroll				; counter in BG1HScroll
.loop:								; one step
	dec a							; count down
	bmi .t1							; finished
	sta.w BG1HScroll				; store the counter
	tay								; keep it
	eor.w #$FFFF					; 256 - low byte: the opening
	inc a
	and.w #$00FF					; low byte
	beq .1							; 0: leave the window edges
	sta.w TitleWH1					; window edge 1
	sec
	sbc.w #$0020					; edge 3 is 32 less
	bmi .1							; below 0: skip
	and.w #$00FF
	sta.w TitleWH3Low				; window edge 3
.1:									; delay
	tya								; counter
	ldx.w #$0200					; delay of $200 loops
	jsr.w TitleDelay				; wait
	bra .loop						; next step

.t1:								; finished: close both edges
	stz.w BG1HScroll				; scroll back to 0
	lda.w #$00FF
	sta.w TitleWH1					; $FF closes them
	sta.w TitleWH3Low				; both edges
	rts
