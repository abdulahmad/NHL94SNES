; Print the message for penalty d0, or clear it
prefmes:							; called from PushRef, SetPA
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.w sfhormode
	beq .t1
	jmp.w .t5

.t1:								; sfhormode = 0: if penmsgbox = 0 go to .1, ...
	lda.l penmsgbox
	beq .1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #prefmesPos>>16
	sta.b a1+2
	lda.w #prefmesPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$000E
	sta.b d0
	lda.w #$0003
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.w #$0000
	sta.l penmsgbox
.1:									; if d0 >= 0 go to .t4, ...
	lda.b d0
	bpl .t4
	jmp.w .3

.t4:								; d0 >= 0: a1 = prefmesPos2, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #prefmesPos2>>16
	sta.b a1+2
	lda.w #prefmesPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #Penaltylist>>16
	sta.b a1+2
	lda.w #Penaltylist
	sta.b a1
	ldy.b d0
	lda.l penmsgbox
	beq .t3
	cpy.w #$0006
	bne .t1x
	jmp.w .3

.t1x:								; if not zero go to .t2, ...
	cpy.w #$0008
	bne .t2
	jmp.w .3

.t2:								; if not zero go to .t1xx, ...
	cpy.w #$000C
	bne .t1xx
	jmp.w .3

.t1xx:								; if not zero go to .t3, ...
	cpy.w #$0012
	bne .t3
	jmp.w .3

.t3:								; a1 = [a1],y + a1 + 1 + 1, d0 = [a1] - 1 - 1, if not zero go to .t1x2...
	lda.b [a1],y
	clc
	adc.b a1
	inc a
	inc a
	sta.b a1
	lda.b [a1]
	dec a
	dec a
	sta.b d0
	bne .t1x2
	jmp.w .3

.t1x2:								; increment a, lsr a, d0 = A, ...
	inc a
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	bpl .1x
	stz.w printx
.1x:								; d0 = [a1], decrement a1, increment a1, ...
	lda.b [a1]
	sta.b d0
	tay
	dec.b a1
	lda.b [a1],y
	inc.b a1
	and.w #$00FF
	bne .2
	dec.b d0
.2:									; penmsgbox = $0001, d1 = $0003, call Framer, ...
	lda.w #$0001
	sta.l penmsgbox
	lda.w #$0003
	sta.b d1
	jsl.l Framer
	dec.w printy
	dec.w printy
	inc.w printx
	jsl.l print
	bra .3

.t5:								; call ClearPenaltyMessage, if d0 negative go to .3, ...
	jsl.l ClearPenaltyMessage
	lda.b d0
	bmi .3
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #prefmesPos3>>16
	sta.b a1+2
	lda.w #prefmesPos3
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #Penaltylist>>16
	sta.b a1+2
	lda.w #Penaltylist
	sta.b a1
	ldy.b d0
	lda.b [a1],y
	clc
	adc.b a1
	inc a
	inc a
	sta.b a1
	lda.b [a1]
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	jsl.l print
.3:									; a1+2 = pulled value, a1 = pulled value, d2+2 = pulled value, ...
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	rtl
