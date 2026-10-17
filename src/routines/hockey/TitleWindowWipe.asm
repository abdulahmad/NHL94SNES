; Title: count $07D6 down, moving the window edges WH1 ($0BCB) and WH3 ($0BCF) each step (TitleDelay), then
; close them ($FF)
TitleWindowWipe:
	lda.w BG1HScroll
.loop:
	dec a
	bmi .t1
	sta.w BG1HScroll
	tay
	eor.w #$FFFF
	inc a
	and.w #$00FF
	beq .1
	sta.w TitleWH1
	sec
	sbc.w #$0020
	bmi .1
	and.w #$00FF
	sta.w TitleWH3Low
.1:
	tya
	ldx.w #$0200
	jsr.w TitleDelay
	bra .loop

.t1:
	stz.w BG1HScroll
	lda.w #$00FF
	sta.w TitleWH1
	sta.w TitleWH3Low
	rts
