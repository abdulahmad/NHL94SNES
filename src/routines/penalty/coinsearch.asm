; Count team a2's players kept off the ice by penalties to set how many it has on the ice
coinsearch:							; called from InProgress_coin
	lda.w #$0006
	sta.b d1
	lda.w #$0032
	sta.b d0
.top:								; loop: if a2 = 0 go to .tm, ...
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:								; adc d0, if tmpdst,y negative go to .nap, ...
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bmi .nap
	beq .nap
	and.w #$DFFF
	sta.w tmpdst,y
	bit.w #(TMPDINJ|$4000)
	bne .nap
	lda.b d1
	cmp.w #$0004
	beq .nap
	dec.b d1
.nap:								; decrement d0, decrement d0, if d0 still >= 0 go to .top, ...
	dec.b d0
	dec.b d0
	bpl .top
	ldy.b a2
	lda.b d1
	sta.w tmap,y
	rtl
