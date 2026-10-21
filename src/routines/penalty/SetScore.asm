; Play one period of a playoff game with random goals
SetScore:							; called from InitScores, UpdateScores
	phx
	ldx.b a0
	lda.l gsper,x
	cmp.w #$0004
	bcc .t3
	jmp.w .3

.t3:								; gsper,x < $0004: if gsper,x != $0003 go to .t2, ...
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	ldx.b a0
	lda.l gsper,x
	cmp.w #$0003
	bne .t2
	lda.w #$0005
	sta.l gsper,x
	lda.l gss1,x
	sec
	sbc.l gss2,x
	bit.w #$8000
	beq .1
	eor.w #$FFFF					; negate: two's complement
	inc a
.1:									; if carry set go to .2, ...
	cmp.w #$0002
	bcs .2
	lda.w gsp
	cmp.w #$0004
	bne .t1
	lda.l gss1,x
	cmp.l gss2,x
	bne .2
	inc a
	sta.l gss1,x
	bra .2

.t1:								; gsp != $0004: gsper,x = $0003, gsflags,x = gsflags,x | $0002, go to .2
	lda.w #$0003
	sta.l gsper,x
	lda.l gsflags,x
	ora.w #$0002
	sta.l gsflags,x
	bra .2

.t2:								; gsper,x != $0003: gsper,x = gsper,x + 1, d0 = gst1,x, d1 = gst2,x, ...
	lda.l gsper,x
	inc a
	sta.l gsper,x
	lda.l gst1,x
	sta.b d0
	lda.l gst2,x
	sta.b d1
	jsl.l .4
	ldx.b a0
	lda.l gss1,x
	clc
	adc.b d0
	sta.l gss1,x
	lda.l gst2,x
	sta.b d0
	lda.l gst1,x
	sta.b d1
	jsl.l .4
	ldx.b a0
	lda.l gss2,x
	clc
	adc.b d0
	sta.l gss2,x
.2:									; a1+2 = pulled value, a1 = pulled value, a0+2 = pulled value, ...
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
.3:									; return
	plx
	rtl
.4:									; subroutine: asl d0, asl d0, a1 = TeamList, ...
	asl.b d0
	asl.b d0
	lda.w #TeamList>>16
	sta.b a1+2
	lda.w #TeamList
	sta.b a1
	ldy.b d0
	lda.b [a1],y
	sta.b a1
	ldy.w #$0008
	adc.b [a1],y
	sta.b a1
	lda.b [a1]
	and.w #$0070
	lsr a
	adc.w #.5
	sta.b a1
	lda.w #.5>>16
	sta.b a1+2
	lda.b [a1]
	sta.w nibblebuffer
	ldy.w #$0002
	lda.b [a1],y
	sta.w nibblebuffer+2
	ldy.w #$0004
	lda.b [a1],y
	sta.w nibblebuffer+4
	ldy.w #$0006
	lda.b [a1],y
	sta.w nibblebuffer+6
	asl.b d1
	asl.b d1
	lda.w #TeamList>>16
	sta.b a1+2
	lda.w #TeamList
	sta.b a1
	ldy.b d1
	lda.b [a1],y
	sta.b a1
	ldy.w #$0008
	adc.b [a1],y
	sta.b a1
	lda.b [a1]
	and.w #$0007
	asl a
	asl a
	asl a
	adc.w #.5
	sta.b a1
org $9FA001
	lda.w #.5>>16
	sta.b a1+2
	lda.b [a1]
	adc.w nibblebuffer
	sta.w nibblebuffer
	ldy.w #$0002
	lda.b [a1],y
	adc.w nibblebuffer+2
	sta.w nibblebuffer+2
	ldy.w #$0004
	lda.b [a1],y
	adc.w nibblebuffer+4
	sta.w nibblebuffer+4
	ldy.w #$0006
	lda.b [a1],y
	adc.w nibblebuffer+6
	sta.w nibblebuffer+6
	lda.w #$0004
	sta.b d0
	jml.l WeightedRandomSelect		; d0 = a random index 0 
.5:									; dw $002B,$001E,$0017,$0004,$0027,$0020,$0018,$0005, dw $0023,$0021,$0...
	dw $002B,$001E,$0017,$0004,$0027,$0020,$0018,$0005
	dw $0023,$0021,$001A,$0006,$001E,$0022,$001E,$0006
	dw $001A,$0024,$001E,$0008,$0016,$0025,$001F,$000A
	dw $0013,$0026,$001F,$000C,$000F,$0026,$0020,$000F
