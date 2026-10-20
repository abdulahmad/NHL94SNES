; Password bits divided by d0, remainder left in d0
SuperDiv:							; called from BitstoPW, ReadPassBits
	lda.b d0
	cmp.w #$0100
	bcs .t2
	sep #$30
	phx
	ldx.b #$0E
	lda.b #$00
	xba
	lda.l passbits+$F
	sta.b r3
.loop:								; loop: WRDIVL = passbits,x, WRDIVH = r3, WRDIVB = d0, ...
	lda.l passbits,x
	sta.w WRDIVL
	lda.b r3
	sta.w WRDIVH
	lda.b d0
	sta.w WRDIVB
	nop
	nop
	nop
	nop
	nop
	nop
	xba
	clc
	adc.w RDDIVL
	sta.l passbits,x
	lda.w RDDIVH
	adc.b #$00
	xba
	lda.w RDMPYL
	sta.b r3
	dex
	bpl .loop
	lda.b r3
	sta.b d0
	plx
	rep #$30
	clc
	rtl

.t2:								; d0 >= $0100: if not zero go to .t1, ...
	cmp.w #$0200
	bne .t1
	lda.l passbits
	and.w #$01FF
	sta.b d0
	sep #$30
	phx
	phy
	clc
	ldx.b #$0E
	lda.l passbits+$F
	sta.b r3
.loopx:								; loop: r3 = passbits,x, ror a, passbits,x = A, ...
	ldy.b r3
	lda.l passbits,x
	sta.b r3
	tya
	ror a
	sta.l passbits,x
	dex
	bpl .loopx
	lda.b #$00
	sta.l passbits+$F
	ply
	plx
	rep #$30
	clc
	rtl

.t1:								; d0 = passbits & $3FFF
	lda.l passbits
	and.w #$3FFF
	sta.b d0
	phx
	ldx.w #$0000
.loopxx:							; loop: xba, passbits,x = A, X + 1, ...
	lda.l passbits+1,x
	asl a
	asl a
	xba
	sep #$20
	sta.l passbits,x
	rep #$20
	inx
	cpx.w #$000E
	bcc .loopxx
	lda.w #$0000
	sta.l passbits+$F
	sta.l passbits+$E
	plx
	clc
	rtl
