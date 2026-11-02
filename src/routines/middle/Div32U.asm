; $08-$0B / $04 into $00, unsigned; $7FFF when the quotient does not fit
Div32U:								; called from Div32S, Gameloop, ReplayMode, UpdateCrowdMeter, doshot
	sep #$20
	lda.b r2+3
	beq .hi0
	cmp.b r1+1
	bcc .go
	jmp.w Div_Overflow
.go:								; falls through
	rep #$20
	lda.b r2+2
	ldx.w #$0010
.loop:								; loop: asl r2, rol a, if carry set go to .sub, ...
	asl.b r2
	rol a
	bcs .sub
	cmp.b r1
	bcc .bit
.sub:								; sbc r1
	sbc.b r1
	sec
.bit:								; rol r0, X - 1, if X not yet 0 go to .loop, ...
	rol.b r0
	dex
	bne .loop
	rtl
	sep #$20						; not reached
.hi0:								; if r1+1 = 0 go to Div32U_ByteDivisor, ...
	lda.b r1+1
	beq Div32U_ByteDivisor
	lda.b r2+2
	beq Div16U_Go
	cmp.b r1+1
	bcc Div_8Bits
	rep #$20
	lda.b r2+2
	and.w #$00FF
	ldx.w #$0010
.loop2:								; loop: asl r2, rol a, if carry set go to .sub2, ...
	asl.b r2
	rol a
	bcs .sub2
	cmp.b r1
	bcc .bit2
.sub2:								; sbc r1
	sbc.b r1
	sec
.bit2:								; rol r0, X - 1, if X not yet 0 go to .loop2, ...
	rol.b r0
	dex
	bne .loop2
	rtl
