; Count team a2's players kept off the ice by penalties to set how many it has on the ice
coinsearch:							; called from InProgress_coin
	lda.w #$0006					; d1 = 6 players, d0 = last roster word
	sta.b d1						; six players
	lda.w #$0032					; last roster word
	sta.b d0
.top:								; loop: if a2 = 0 go to .tm, ...
	lda.b a2
	beq .tm							; team
	lda.w #$0034					; away team offset
.tm:								; adc d0, if tmpdst,y negative go to .nap, ...
	clc
	adc.b d0
	tay								; index
	lda.w tmpdst,y					; player state
	bmi .nap						; empty
	beq .nap
	and.w #$DFFF
	sta.w tmpdst,y					; state back
	bit.w #(TMPDINJ|$4000)
	bne .nap
	lda.b d1
	cmp.w #$0004					; four minimum
	beq .nap						; keep it
	dec.b d1						; one less
.nap:								; decrement d0, decrement d0, if d0 still >= 0 go to .top, ...
	dec.b d0						; previous player
	dec.b d0
	bpl .top
	ldy.b a2						; team offset
	lda.b d1
	sta.w tmap,y					; players on the ice
	rtl
