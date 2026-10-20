; Collision of object X with the corners, the goals and the boards
checkwallcoll:						; called from ReplayMode, checkcoll
	lda.w #$012A					; d3 = $12A - wcradiusy, d2 = $88 - wcradiusx; corner centers 64 in
	sec
	sbc.w wcradiusy					; y half length minus the radius
	pha								; keep it
	eor.w #$FFFF					; negate
	inc a
	clc
	adc.w #$0040
	sta.b d5						; d5 = corner circle center y
	lda.w #sideline
	sec
	sbc.w wcradiusx					; x half width minus the radius
	pha								; keep it
	eor.w #$FFFF					; negate
	inc a
	clc
	adc.w #$0040
	sta.b d4						; d4 = corner circle center x
	lda.b d3
	pha								; keep y
	ldy.b d2						; and x
	phy
	dec a
	cmp.b d5
	bpl .t1
	lda.b d2
	cmp.b d4
	bmi .t2
	lda.w #$0000
	sec
	sbc.b d4
	sta.b d4
	cmp.b d2
	bmi .t2
	lda.w #$001A
	sta.b a2
	jsl.l checkgoal					; goal at the -y end
	jmp.w .6

.t1:								; d5 = $0000 - d5, if plus go to .1, ...
	lda.w #$0000
	sec
	sbc.b d5
	sta.b d5
	cmp.b d3
	bpl .1
	lda.b d2
	cmp.b d4
	bmi .t2
	lda.w #$0000
	sec
	sbc.b d4
	sta.b d4
	cmp.b d2
	bmi .t2
	lda.w #$0018
	sta.b a2
	jsl.l checkgoal					; goal at the +y end
.1:									; go to .6
	jmp.w .6

.t2:								;distance from the corner center (max+min/4)
	lda.b d2						; corner circle: offset from the center
	sec
	sbc.b d4						; d2 = dx
	sta.b d2
	eor.w #$FFFF					; negate
	inc a
	sta.b d1						; d1 = -dx, sin
	bit.w #$8000
	beq .1x
	eor.w #$FFFF					; negate: two's complement
	inc a
.1x:								; tmp4 = A, d0 = d3 - d5, if zero go to .2, ...
	sta.b tmp4
	lda.b d3
	sec
	sbc.b d5
	sta.b d0						; d0 = dy, cos
	bit.w #$8000
	beq .2
	eor.w #$FFFF					; negate: two's complement
	inc a
.2:									; cornerdy = A, if carry clear go to .t1x, ...
	sta.b cornerdy
	cmp.b tmp4
	bcc .t1x
	lda.b tmp4
	lsr a
	lsr a
	adc.b cornerdy
	bra .5

.t1x:								; scale the wall normal
	lsr a
	lsr a
	adc.b tmp4
.5:									; if carry clear go to .6, ...
	cmp.w #$0041
	bcc .6
	sta.b d3
	lda.b d0
	xba
	and.w #$FF00
	tax
	lda.b d3
	jsl.l DivX8S
	cmp.w #$FF01
	bpl .1xx
	lda.w #$FF01
.1xx:								; if minus go to .2x, ...
	cmp.w #$00FF
	bmi .2x
	lda.w #$00FF
.2x:								; d0 = A, xba, and #$FF00, ...
	sta.b d0
	lda.b d1
	xba
	and.w #$FF00
	tax
	lda.b d3
	jsl.l DivX8S
	ldx.b a3
	cmp.w #$FF01
	bpl .3
	lda.w #$FF01
.3:									; if minus go to .4, ...
	cmp.w #$00FF
	bmi .4
	lda.w #$00FF
.4:									; d1 = A, call wallcollb
	sta.b d1
	jsl.l wallcollb
.6:									; d2 = pulled value, d3 = pulled value, d4 = pulled value, ...
	pla								; restore d2-d5
	sta.b d2
	pla
	sta.b d3
	pla
	sta.b d4
	pla
	sta.b d5
	lda.w Wallcos,x					; corner hit: done
	ora.w Wallsin,x
	bne .rtl
	lda.w #$00FF
	sta.b d0
	stz.b d1
	lda.b d3						; y against the board limit
	dec a
	cmp.b d5
	bpl wallcollb
	lda.w #$FF01
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d5
	dec a
	cmp.b d3
	bpl wallcollb
	stz.b d0
	lda.w #$FF01
	sta.b d1
	lda.b d2
	dec a
	cmp.b d4
	bpl wallcollb
	lda.w #$00FF
	sta.b d1
	lda.w #$0000
	sec
	sbc.b d4
	dec a
	cmp.b d2
	bpl wallcollb
.rtl:								; return
	rtl
