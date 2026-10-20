; Build the player stats page in the stats page buffer, a row per player in the sorted order
FillPlayerStatsPage:				; called from SortPlayerStats
	lda.w #$007F
	sta.b p1+2
	lda.w #$2780
	sta.b p1
	ldx.w #$4D80
	lda.l smallfontchars
	clc
	adc.l printfontset
	jsl.l MemFill
	ldy.w listtop
	tya
	dec a
	asl a
	sta.w printy
.1:									; increment printy, increment printy, if statcolumn = 0 go to .t1, ...
	inc.w printy
	inc.w printy
	sep #$20
	lda.w statsorder,y
	rep #$20
	and.w #$00FF
	tax
	lda.w statcolumn
	beq .t1
	jsl.l .3
	bra .2

.t1:								; statcolumn = 0: call .4
	jsl.l .4
.2:									; Y + 1, if zero go to .1, ...
	iny
	cpy.w listend
	beq .1
	bcc .1
	rtl
.3:									; subroutine: call SetStatColumnPal, printx = $0003, d0 = X, ...
	phy
	lda.b d1
	pha
	lda.w #$FFFF
	jsl.l SetStatColumnPal
	lda.w #$0003
	sta.w printx
	stx.b d0
	jsl.l PlayerInitialName
	jsl.l PrintToStatsPage
	stx.w statstemp
	lda.b a2
	beq .2x
.1x:								; falls through
	lda.w #$001A
.2x:								; adc statstemp, call SetStatColumnPal, printx = $0011, ...
	clc
	adc.w statstemp
	tax
	lda.w #$0001
	jsl.l SetStatColumnPal
	lda.w #$0011
	sta.w printx
	sep #$20
	lda.w tmgoals,x
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l PrintToStatsPage
	lda.w #$0002
	jsl.l SetStatColumnPal
	lda.w #$0014
	sta.w printx
	sep #$20
	lda.w passists,x
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l PrintToStatsPage
	lda.w #$0003
	jsl.l SetStatColumnPal
	lda.w #$0017
	sta.w printx
	sep #$20
	lda.w tmgoals,x
	rep #$20
	and.w #$00FF
	sta.b d0
	sep #$20
	lda.w passists,x
	rep #$20
	and.w #$00FF
	clc
	adc.b d0
	sta.b d0
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l PrintToStatsPage
	lda.w #$0004
	jsl.l SetStatColumnPal
	lda.w #$001A
	sta.w printx
	sep #$20
	lda.w pshots,x
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l PrintToStatsPage
	lda.w #$0005
	jsl.l SetStatColumnPal
	lda.w #$001D
	sta.w printx
	sep #$20
	lda.w ppenmin,x
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l PrintToStatsPage
	lda.w #$FFFF
	jsl.l SetStatColumnPal
	pla
	sta.b d1
	ply
	rtl
.4:									; subroutine: call SetStatColumnPal, printx = $0003, d0 = X, ...
	phy
	lda.b d1
	pha
	lda.w #$FFFF
	jsl.l SetStatColumnPal
	lda.w #$0003
	sta.w printx
	stx.b d0
	jsl.l PlayerInitialName
	jsl.l PrintToStatsPage
	stx.w statstemp
	lda.b a2
	beq .1xx
	lda.w #$001A
.1xx:								; adc statstemp, printx = $0012, d0 = tmgoals,x & $00FF, ...
	clc
	adc.w statstemp
	tax
	lda.w #$0012
	sta.w printx
	sep #$20
	lda.w tmgoals,x
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l PrintToStatsPage
	lda.w #$0016
	sta.w printx
	sep #$20
	lda.w pshots,x
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l PrintToStatsPage
	lda.w #$001B
	sta.w printx
	sep #$20
	lda.w tmgoals,x
	rep #$20
	and.w #$00FF
	phx
	ldx.w #$0064
	jsl.l Mul8XS
	sta.b r2
	plx
	sep #$20
	lda.w pshots,x
	rep #$20
	and.w #$00FF
	sta.b r1
	cmp.w #$0000
	beq .t1x
	jsl.l Div16U
	lda.b r0
	sta.b d0
	bra .2xx

.t1x:								; d0 = $0064
	lda.w #$0064
	sta.b d0
.2xx:								; d0 = $0064 - d0, d1 = $0003, call PushNumberWrap, ...
	lda.w #$0064
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l PrintToStatsPage
	lda.w #$001E
	sta.w printx
	lda.w #PercentSign>>16
	sta.b a1+2
	lda.w #PercentSign
	sta.b a1
	jsl.l PrintToStatsPage
	pla
	sta.b d1
	ply
	rtl
