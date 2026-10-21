; A skateto callback near the puck carrier: d0 = the direction away from him
; Takes: X = player object. Used as the a0 callback of skateto (assdefo, assbench, asscentero, asswingo,
; and others). If the puck carrier will be less than 40 away next frame in x and y, d0 = the direction away
; from him (vtoa of the difference); otherwise returns with d0/d1 unchanged.
EvadePC:							; callback: steer away from the puck carrier
	lda.w puckc						; puck carrier
	bmi .rtl						; nobody: nothing to evade
	lda.w Xvel+1,x					; x speed (high byte) of this player
	sec
	sbc.w Xvel+puckobj+1			; minus the puck's x speed (high byte)
	and.w #$00FF					; signed byte
	bit.w #$0080
	beq .2xx
	ora.w #$FF00					; sign extend
.2xx:								; adc Xpos,x, sbc puckx, if minus go to .rtl, ...
	clc
	adc.w Xpos,x					; plus x: where he is next frame
	sec
	sbc.w puckx						; minus the carrier's x
	cmp.w #$FFD7					; more than 40 left of him: leave
	bmi .rtl
	cmp.w #$0029					; more than 40 right of him: leave
	bpl .rtl
	lda.w Yvel+1,x					; y speed (high byte) of this player
	sec
	sbc.w Yvel+puckobj+1			; minus the puck's y speed (high byte)
	and.w #$00FF					; signed byte
	bit.w #$0080
	beq .3x
	ora.w #$FF00					; sign extend
.3x:								; adc Ypos,x, sbc pucky, if minus go to .rtl, ...
	clc
	adc.w Ypos,x					; plus y: where he is next frame
	sec
	sbc.w pucky						; minus the carrier's y
	cmp.w #$FFD7					; more than 40 above him: leave
	bmi .rtl
	cmp.w #$0029					; more than 40 below him: leave
	bpl .rtl
	lda.w Xpos,x					; d0 = dx from the carrier
	sec
	sbc.w puckx
	sta.b d0						; d0 = dx from the carrier
	lda.w Ypos,x					; d1 = dy from the carrier
	sec
	sbc.w pucky
	sta.b d1						; d1 = dy from the carrier
	jml.l vtoa						; direction away from him

.rtl:								; return
	rtl
