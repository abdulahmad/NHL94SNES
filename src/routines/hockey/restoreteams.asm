; Put both teams' players on the bench
;
; Sets tmap to 6 for both teams and every roster entry of tmpdst to TMPDBENCH.
; Called from StartGame and SaveRegsStartHL2.
restoreteams:						; all players of both teams on the bench
	stz.b a2						; team 0 first
	jsl.l .r						; do it as a subroutine
	lda.w #$0002					; then team 1
	sta.b a2
.r:									; shared body: one team (a2)
	ldy.b a2						; Y = team offset into the tables
	lda.w #$0006					; tmap = 6 (the value the code stores)
	sta.w tmap,y
	lda.w #$0032
	sta.b d0						; d0 = offset of the last roster entry ($32)
.0:									; next roster entry (counting down by words)
	lda.b a2						; team 0?
	beq .home						; yes: base offset 0
	lda.w #$0034					; team 1: its roster starts $34 on
.home:								; base chosen
	clc								; plus roster offset
	adc.b d0
	tay								; Y = index into tmpdst
	lda.w #TMPDBENCH				; bench state
	sta.w tmpdst,y					; put the player on the bench
	dec.b d0						; previous player
	dec.b d0
	bpl .0							; loop until d0 goes negative
	rtl
