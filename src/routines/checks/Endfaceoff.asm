; Drop the puck: pick the face off winner and send the puck off
Endfaceoff:							; called from puckfaceoff2 when the puck drops
	lda.w #$2400
	sta.b p0
	stz.b p0+2
	lda.w #$0007
	jsl.l sfx
	lda.w #$0100
	trb.w sflags
	lda.w #$0000
	sta.l fobox
	lda.w #$0400
	trb.w sflags
	stz.w replaydelay
	stz.w gmclock
	lda.w #$0010
	tsb.w sflags3
	lda.l fodir1
	sta.b d3
	lda.w #$0800
	sta.b d4
	stz.b a1
	lda.w #$0010
	sta.b d2
	lda.l fofdata2
	tax
	lda.l .14-1,x
	and.w #$00FF
	bit.w #$0080
	beq .2
.1:									; ora #$FF00
	ora.w #$FF00
.2:									; eor #$FFFF, increment a, adc d2, ...
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.b d2
	sta.b d2
	lda.l fofdata2+fosize
	tax
	lda.l .14-1,x
	and.w #$00FF
	bit.w #$0080
	beq .4
.3:									; ora #$FF00
	ora.w #$FF00
.4:									; adc d2, d2 = A, call RandomWord, ...
	clc
	adc.b d2
	sta.b d2
	jsl.l RandomWord
	and.w #$001F
	inc a
	cmp.b d2
	bcs .5
	lda.w #$0004
	sta.b a1
.5:									; if fofdata2+foattr,x bits $0800 clear go to .6, ...
	ldx.b a1
	lda.l fofdata2+foattr,x
	bit.w #$0800
	beq .6
	lda.l fodir2
	sta.b d3
	lda.w #$F800
	sta.b d4
.6:									; if d3 bit $0008 set go to .7, ...
	lda.b d3
	bit.w #$0008
	bne .7
	and.w #$0007
	sta.b d0
	lda.w seed
	and.w #$0003
	bne .8
.7:									; call randoma8, decrement a, decrement a, ...
	lda.w #$0005
	jsl.l randoma8
	dec a
	dec a
	and.w #$0007
	sta.b d0
	lda.b d4
	bmi .8
	lda.b d0
	eor.w #$0004
	sta.b d0
.8:									; asl d0, asl d0, Xvel,x = dirtab,x * 2 * 2 * 2 * 2 * 2, ...
	asl.b d0
	asl.b d0
	ldx.b d0
	lda.l dirtab,x
	asl a
	asl a
	asl a
	asl a
	asl a
	ldx.b a3
	sta.w Xvel,x
	ldx.b d0
	lda.l dirtab+2,x
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.b d4
	ldx.b a3
	sta.w Yvel,x
	lda.w #$0004
	ldy.w #$0000
	jsr.w .13
	bmi .12
	lda.w puckvy
	bpl .10
	lda.w pfgoal,y
	bne .11
.9:									; call .13, if minus go to .12, ...
	lda.w #$0004
	ldy.w #$000C
	jsr.w .13
	bmi .12
	bra .11
.10:								; puckvy >= 0: if pfgoal,y != 0 go to .9
	lda.w pfgoal,y
	bne .9
.11:								; a2 = Y, call a2touchpuck
	sty.b a2
	ldx.b a3
	jsl.l a2touchpuck
.12:								; tmflags = tmflags & $FFFB, tmflags+2 = tmflags+2 & $FFFB, call Random...
	lda.w tmflags
	and.w #$FFFB
	sta.w tmflags
	lda.w tmflags+2
	and.w #$FFFB
	sta.w tmflags+2
	ldx.b a3
	jsl.l RandomWord
	and.w #$07FF
	sta.w puckvz
	stz.w puckz
	stz.w pfnc,x
	lda.w #$0018
	sta.b d0
	jml.l assreplace
.13:								; subroutine: d0 = $0006
	pha
	lda.w #$0006
	sta.b d0
	pla
.loop:								; find position A among the six players of the team at y
	cmp.w position,y
	beq .1x
	iny
	iny
	dec.b d0
	bne .loop
	ldy.w #$FFFF
.1x:								; return
	cpy.w #$0000
	rts
.14:								; db $00,$08,$10,$00,$08,$10
	db $00,$08,$10,$00,$08,$10
