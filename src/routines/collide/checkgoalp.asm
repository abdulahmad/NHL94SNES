; Player X runs into the goal a2
checkgoalp:							; called from checkgoal
	lda.w pflags,x
	bit.w #$8000
	bne .1
	cpx.w #$0017
	bcc .11
.1:									; return
	rtl
.11:								; if a2 = $0018 go to .t1, ...
	ldy.b a2
	cpy.w #$0018
	beq .t1
	lda.b d3
	sec
	sbc.w wcradiusy
	cmp.w #$FF16
	bpl .1
	bra .8

.t1:								; a2 = $0018: if minus go to .1
	lda.b d3
	clc
	adc.w wcradiusy
	cmp.w #$00EA
	bmi .1
.8:									; if d2 bits $8000 clear go to .1x, ...
	lda.b d2
	bit.w #$8000
	beq .1x
	eor.w #$FFFF					; negate: two's complement
	inc a
.1x:								; sbc wcradiusx, if plus go to .1, ...
	sec
	sbc.w wcradiusx
	cmp.w #$0040
	bpl .1
	lda.b d3						; keep y
	pha
	sec
	sbc.w Ypos,y					; minus the goal y
	sta.b d3
	eor.w #$FFFF					; negate
	inc a
	sta.b d0						; d0 = -dy
	lda.b d2						; keep x
	pha
	sec
	sbc.w Xpos,y					; minus the goal x
	sta.b d1						; d1 = dx
	sta.b r1
	tax
	jsl.l Mul8S
	sta.b r2
	ldx.b a3
	lsr a
	lsr a
	cmp.w #$0101
	bcs .2
	sta.b d2
	lda.b d3
	sta.b r1+2
	tax
	jsl.l Mul8S
	asl a
	sta.b r2+2
	ldx.b a3
	clc
	adc.b d2
	cmp.w #$0101
.2:									; if carry set go to .7, ...
	bcs .7
	pla								; restore x
	sta.b d2
	pla								; restore y
	sta.b d3
	jsr.w .t1x
	lda.b d3						; keep y
	pha
	lda.b d2						; and x
	pha
	lda.b r1
	ldy.b r1+2
	jsl.l ApproxLength
	inc a
	sta.b d2
	lda.b d0
	xba
	and.w #$FF00
	tax
	lda.b d2
	jsl.l DivX8S
	cmp.w #$00FF
	bmi .3
	lda.w #$00FF
.3:									; if plus go to .4, ...
	cmp.w #$FF01
	bpl .4
	lda.w #$FF01
.4:									; d0 = A, xba, and #$FF00, ...
	sta.b d0
	lda.b d1
	xba
	and.w #$FF00
	tax
	lda.b d2
	jsl.l DivX8S
	cmp.w #$00FF
	bmi .5
	lda.w #$00FF
.5:									; if plus go to .6, ...
	cmp.w #$FF01
	bpl .6
	lda.w #$FF01
.6:									; d1 = A, call wallcoll
	sta.b d1
	ldx.b a3
	jsl.l wallcoll
.7:									; d2 = pulled value, d3 = pulled value, return
	pla								; restore x
	sta.b d2
	pla								; restore y
	sta.b d3
	rtl

.t1x:								; subroutine: if seed & $01C0 != 0 go to .1xx, ...
	lda.b d0
	pha
	lda.b d1
	pha
	lda.w seed
	and.w #$01C0
	bne .1xx
	lda.w SPA,x
	cmp.w #SPAburst
	bne .1xx
	ldy.b a2
	lda.w pucky
	sec
	sbc.w Ypos,y
	cmp.w #$FF80
	bmi .1xx
	cmp.w #$0080
	bpl .1xx
	lda.w Xvel,x
	sta.b d0
	lda.w Yvel,x
	sta.b d1
	cmp.w #$DFFF
	bmi .10
	cmp.w #$2001
	bpl .10
	lda.b d0
	cmp.w #$DFFF
	bmi .10
	cmp.w #$2001
	bpl .10
.1xx:								; d1 = pulled value, d0 = pulled value
	pla
	sta.b d1
	pla
	sta.b d0
.9:									; return
	rts
.10:								; if zero go to .1xxx, ...
	pla
	pla
	lda.b d0
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .1xxx
	ora.w #$E000
.1xxx:								; d0 = A, ror a, adc d0, ...
	sta.b d0
	cmp.w #$8000
	ror a
	clc
	adc.b d0
	sta.b d0
	ldy.b a2
	sta.w Xvel,y
	lda.b d1
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .2x
	ora.w #$E000
.2x:								; d1 = A, ror a, adc d1, ...
	sta.b d1
	cmp.w #$8000
	ror a
	clc
	adc.b d1
	sta.b d1
	sta.w Yvel,y
	stz.w Xvel,x
	stz.w Yvel,x
	lda.w #$0040
	tsb.w sflags
	lda.w gmclock
	bne .9
	pla
	lda.w #PenGhold
	sta.b d0
	jmp.w AddPenalty2
