; Compare stat column statcolumn of the players at order slots x and y (statsorder); statstemp is not 0 when
; they swap
ComparePlayerStats:					; called from SortPlayerStats
	phx
	phy
	lda.b d0
	pha
	sep #$20
	lda.w statsorder,y
	rep #$20
	and.w #$00FF
	tay
	sep #$20
	lda.w statsorder,x
	rep #$20
	and.w #$00FF
	tax
	stx.w statstemp
	lda.b a2
	beq .2
.1:									; falls through
	lda.w #$001A
.2:									; adc statstemp, statstemp = Y, if a2 = 0 go to .4
	clc
	adc.w statstemp
	tax
	sty.w statstemp
	lda.b a2
	beq .4
.3:									; falls through
	lda.w #$001A
.4:									; adc statstemp, if statcolumn = $0001 go to .t3
	clc
	adc.w statstemp
	tay
	lda.w statcolumn
	cmp.w #$0001
	beq .t3
.5:									; if zero go to .t4, ...
	cmp.w #$0002
	beq .t4
	cmp.w #$0003
	beq .t5
	cmp.w #$0004
	bne .t2
	jmp.w .t6

.t2:								; if not zero go to .t1, ...
	cmp.w #$0005
	bne .t1
	jmp.w .t1x

.t1:								; go to .6
	jmp.w .6

.t3:								; statcolumn = $0001: if zero go to .6
	sep #$20
	lda.w tmgoals,y
	cmp.w tmgoals,x
	rep #$20
	beq .6
.1x:								; if plus go to .7, ...
	bpl .7
	jmp.w .6

.t4:								; if zero go to .6, ...
	sep #$20
	lda.w tmassists,y
	cmp.w tmassists,x
	rep #$20
	beq .6
	bpl .7
	bra .6

.t5:								; d0 = tmgoals,y & $00FF, d0 = tmassists,y & $00FF + d0, statstemp =
									;tmg...
	sep #$20
	lda.w tmgoals,y
	rep #$20
	and.w #$00FF
	sta.b d0
	sep #$20
	lda.w tmassists,y
	rep #$20
	and.w #$00FF
	clc
	adc.b d0
	sta.b d0
	sep #$20
	lda.w tmgoals,x
	rep #$20
	and.w #$00FF
	sta.w statstemp
	sep #$20
	lda.w tmassists,x
	rep #$20
	and.w #$00FF
	clc
	adc.w statstemp
	sta.w statstemp
	lda.b d0
	cmp.w statstemp
	beq .6
	bmi .6
	bra .7

.t6:								; if zero go to .6, ...
	sep #$20
	lda.w tmpshots,y
	cmp.w tmpshots,x
	rep #$20
	beq .6
	bpl .7
	bra .6

.t1x:								; if zero go to .6, ...
	sep #$20
	lda.w ppenmin,y
	cmp.w ppenmin,x
	rep #$20
	beq .6
	bpl .7
.6:									; statstemp = $0000, go to .8
	lda.w #$0000
	sta.w statstemp
	bra .8
.7:									; statstemp = $0001
	lda.w #$0001
	sta.w statstemp
.8:									; d0 = pulled value, return
	pla
	sta.b d0
	ply
	plx
	rtl
