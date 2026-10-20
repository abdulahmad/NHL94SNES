; Queue the rink map rows that the vertical scroll brought on screen
ShowRinkRows:						; called from setvideo
	lda.w sfhormode
	beq .t2
	rtl

.t2:								; sfhormode = 0: if not zero go to .t1, ...
	lda.w Vscroll
	clc
	adc.w #$0170
	lsr a
	lsr a
	lsr a
	tax
	sec
	sbc.w Oldrow
	bne .t1
	jmp.w .4

.t1:								; if plus go to .2, ...
	bpl .2
	stx.w Oldrow
	eor.w #$FFFF					; negate: two's complement
	inc a
	cmp.w #$0019
	bcs .1
	sta.b tmp1
	lda.w vramrow
	sec
	sbc.b tmp1
	and.w #$001F
	sta.w vramrow
	sta.b tmp2
	bra .3
.1:									; tmp1 = $001D, vramrow = 0, tmp2 = 0, ...
	lda.w #$001D
	sta.b tmp1
	stz.w vramrow
	stz.b tmp2
	bra .3
.2:									; Oldrow = X, if carry set go to .1, ...
	stx.w Oldrow
	cmp.w #$0019
	bcs .1
	sta.b tmp1
	adc.w vramrow
	and.w #$001F
	sta.w vramrow
	adc.w #$001D
	sec
	sbc.b tmp1
	and.w #$001F
org $9FC002
	sta.b tmp2
	txa
	clc
	adc.w #$001D
	sec
	sbc.b tmp1
	tax
.3:									; tmp0 = X * 2 * 2 * 2 * 2 * 2, tmp0 = X * 2 * 2 * 2 * 2 * 2 * 2 + tmp0...
	txa
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b tmp0
	asl a
	adc.b tmp0
	adc.w #$C800
	adc.w #$0006
	sta.b tmp0
	lda.b tmp2
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w #$0400
	sta.b tmp2
	lda.b tmp1
	sta.b r1
.loop:								; loop: p0+2 = $007F, p0 = tmp0, call DMAToVRAM, ...
	lda.w #$007F
	sta.b p0+2
	lda.b tmp0
	sta.b p0
	ldy.b tmp2
	ldx.w #$0040
	jsl.l DMAToVRAM
	lda.b tmp0
	clc
	adc.w #$0040
	sta.b p0
	lda.b tmp2
	clc
	adc.w #$0400
	tay
	ldx.w #$0020
	jsl.l DMAToVRAM
	lda.b tmp0
	clc
	adc.w #$0060
	sta.b tmp0
	lda.b tmp2
	clc
	adc.w #$0020
	and.w #$03FF
	ora.w #$0400
	sta.b tmp2
	dec.b r1
	bne .loop
.4:									; BG2HScroll = Hscroll + $00C0, r3 = Vscroll & $0007, ora r3, ...
	lda.w Hscroll
	clc
	adc.w #$00C0
	sta.w BG2HScroll
	lda.w Vscroll
	and.w #$0007
	sta.b r3
	lda.w vramrow
	asl a
	asl a
	asl a
	ora.b r3
	sta.w BG2VScroll
	rtl
