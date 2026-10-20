; The puck hits player a2's stick
puckstick:							; called from checkpuckcoll_ccx
	ldy.b a2						; player a2
	lda.w position,y				; position
	bne .2
	lda.w gmode
	bit.w #gmhl
	beq .2
.1:									; return
	rtl
.2:									; pflags,y = pflags,y & $FFFE, if puckc >= 0 go to .t1, ...
	lda.w pflags,y
	and.w #$FFFE
	sta.w pflags,y
	ldy.w puckc
	bpl .t1
	jmp.w .5

.t1:								; puckc >= 0: if a2 = pfteam,y go to .1, ...
	lda.w pfteam,y
	ldy.b a2
	cmp.w pfteam,y
	beq .1
	lda.b d0
	cmp.w #$0025
	bcs .1
	lda.w position,y
	beq .1x
	ldy.b a0
	lda.w position,y
	beq .1
	lda.w stickhand,y
	jsl.l makepde					; makepde
	lda.b d0
	pha								; keep it
	lda.b a0						; carrier offset
	ldy.b a2						; a2
	sty.b a0
	sta.b a2
	lda.w stickhand,y				; stickhand of a2
	sta.b d0
	jsl.l makepde					; makepde
	lda.b a0						; carrier offset
	ldy.b a2
	sty.b a0
	sta.b a2
	pla								; carrier value
	sec
	sbc.b d0						; minus a2 value
	clc
	adc.w #$0024					; plus 36
	jsl.l randoma					; random number 0 to A-1
	cmp.w #$0003					; steal fails
	bcs .1
.1x:								; call makepde, nopuck,y = d0 + $0014, a0 = a2, ...
	ldy.b a0
	lda.w stickhand,y
	jsl.l makepde
	lda.b d0
	adc.w #$0014					; nopuck = makepde(stickhand) + 20 for both
	ldy.b a0
	sta.w nopuck,y					; store it for the carrier
	lda.b a0						; a2
	ldy.b a2						; stealer
	sty.b a0
	sta.b a2
	lda.w stickhand,y
	jsl.l makepde
	lda.b d0
	adc.w #$0014					; plus 20
	ldy.b a0
	sta.w nopuck,y					; store it for the stealer
	lda.b a0
	ldy.b a2
	sty.b a0
	sta.b a2
	tya								; old carrier
	lsr a
	sta.w lastplayer				; lastplayer = the old carrier
	lda.w #$000C
	trb.w sflags
.3:									; call PuckSfx, call a2touchpuck, go to deflect
	lda.w #$0003
	jsl.l PuckSfx
	jsl.l a2touchpuck
	jmp.w deflect
.4:									; return
	rtl
.5:									; d2 = d0, call Mul16S, d0+2 = r2+2, ...
	lda.b d0
	sta.b d2
	lda.w puckvx
	phx
	tax
	jsl.l Mul16S
	lda.b r2+2
	sta.b d0+2
	lda.b r2
	sta.b d0
	lda.w puckvy
	tax
	jsl.l Mul16S
	plx
	lda.b r2
	clc
	adc.b d0
	sta.b d0
	lda.b r2+2
	adc.b d0+2
	sta.b d0+2
	stz.b d1						; no stickhand bonus
	lda.w sflags					; sf2shot: no stickhand bonus
	bit.w #$1000
	bne .1xx
	ldy.b a2
	lda.w stickhand,y
	phx
	ldx.w #$02BC
	jsl.l Mul16x8U
	lda.b r2
	sta.b d1
	plx
.1xx:								; if position,x = 0 go to .2x, ...
	lda.b d1
	clc
	adc.w #$2710
	ldy.w position,x
	beq .2x
	cpx.w passReceiverPlayerNum
	bne .3x
.2x:								; adc #$0BB8
	adc.w #$0BB8
.3x:								; call Mul16U, if carry set go to .t2, ...
	phx
	tax
	jsl.l Mul16U
	plx
	lda.b r2
	cmp.b d0
	lda.b r2+2
	sbc.b d0+2
	bcs .t2
	lda.w position,x
	beq .t1x
	lda.b d2
	cmp.w #$0025
	bcc .t1x
	jmp.w .4

.t1x:								; nopuck,y = $0008, go to .3
	ldy.b a2
	lda.w #$0008					; too fast: nopuck 8, deflect
	sta.w nopuck,y
	jmp.w .3

.t2:								; go to puckglue
	jmp.w puckglue
