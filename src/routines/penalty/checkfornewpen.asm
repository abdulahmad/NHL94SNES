; Look for a new penalty call and stop play when it should be called
checkfornewpen:						; called from PenaltyManager
	lda.w sfhormode
	beq .t1
	jmp.w .6

.t1:								; sfhormode = 0: a0 = PenBuf
	lda.w #PenBuf					; penalty buffer
	sta.b a0
.4:									; loop: increment a0, increment a0, if zero go to .4, ...
	lda.b (a0)						; next buffered penalty
	inc.b a0
	inc.b a0
	and.w #$00FF
	cmp.w #$0034
	beq .4
	tay
	bne .t2
	jmp.w .6

.t2:								; if gmode bit gmpen set go to .3, ...
	lda.w gmode
	bit.w #gmpen
	bne .3
	dec.b a0						; type byte
	dec.b a0
	lda.b (a0)
	inc.b a0
	inc.b a0
	and.w #$00FF					; penalty type
	sta.b d0
	tay
	lda.w #Penaltylist>>16
	sta.b a1+2
	lda.w #Penaltylist
	sta.b a1
	lda.b [a1],y					; offset of the entry
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]						; minutes
	and.w #$00FF
	beq .2
	lda.w puckc
	bmi .7
	lsr a
	sec
	sbc.w #$0006
	sta.b d0
	dec.b a0
	lda.b (a0)
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .1
	ora.w #$FF00
.1:									; sbc #$0006, eor d0, if minus go to .7
	sec
	sbc.w #$0006
	eor.b d0
	bmi .7
.2:									; call Stop4Pen
	jsl.l Stop4Pen					; stop play
.3:									; decrement a0, (a0) = (a0) | $0080, increment a0, ...
	dec.b a0						; player byte
	lda.b (a0)
	tay
	ora.w #$0080					; set the called bit
	sta.b (a0)
	inc.b a0
	tya
	bit.w #$0080					; already called before?
	beq .t1x
	jmp.w .4

.t1x:								; decrement a0, decrement a0, increment a0, ...
	dec.b a0
	dec.b a0
	lda.b (a0)						; penalty type
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #Penaltylist>>16
	sta.b a1+2
	lda.w #Penaltylist
	sta.b a1
	lda.b [a1],y					; offset of the entry
	clc
	adc.b a1
	sta.b a1
	ldy.w #$0001
	lda.b [a1],y					; delay byte
	and.w #$00FF
	asl a							; times 32
	asl a
	asl a
	asl a
	asl a
	sta.b d1						; d1 = delay * 32
	sec
	sbc.w Pencntdwn					; compare with the countdown
	beq .5
	bmi .5
	lda.b d1
	sta.w Pencntdwn
.5:									; go to .4
	jmp.w .4
.6:									; return
	rtl
.7:									; tsb gmode, if not zero go to .5, ...
	lda.w #$0008
	tsb.w gmode
	bne .5
	lda.w #$0030
	sta.b d0
	jsl.l SetPA
	jmp.w .4
