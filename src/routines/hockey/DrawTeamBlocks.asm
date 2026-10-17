; Draw team d1's block at printx / printy: its name as letter sprites (PrintTeamSprites) and its logo map (2
; rows of 9 words) in its palette
DrawTeamBlocks:
	lda.b a2
	pha
	phx
	lda.w printx
	asl a
	asl a
	asl a
	clc
	adc.w #$0024
	tax
	lda.l cardblock
	beq .1
	txa
	sec
	sbc.w #$0008
	tax
.1:
	lda.w printy
	asl a
	asl a
	asl a
	inc a
	inc a
	inc a
	tay
	lda.l pausesubmenu
	bne .t1
	lda.l cardblock
	bne .t1
	bra .2

.t1:
	inx
	inx
	inx
	inx
	iny
	iny
	iny
	iny
.2:
	jsl.l PrintTeamSprites
	lda.l horblocks
	beq .t2
	lda.l redrawblocks
	bne .t2
	jmp.w .3

.t2:
	lda.w #$1800
	sta.b r3
	ldy.w #$0060
	lda.b d1
	cmp.w HomeTeam
	bne .1x
	ldx.w #$1C00
	stx.b r3
	ldy.w #$0070
.1x:
	asl a
	asl a
	tax
	lda.l TeamBlockPalettes+2,x
	sta.b p0+2
	lda.l TeamBlockPalettes,x
	sta.b p0
	ldx.w #$0010
	jsl.l SetColours
	lda.w HomeTeam
	cmp.w VisTeam
	bne .t1x
	lda.b r3
	cmp.w #$1800
	beq .t1x
	lda.w #$1800
	sta.b r3
	ldy.w #$0060
	lda.b d1
	bra .1x

.t1x:
	ldy.w #$0000
	lda.w #TeamBlocksMap>>16
	sta.b a2+2
	lda.w #TeamBlocksMap+6
	sta.b a2
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.w printm
	tax
	lda.w #$0009
	sta.b tmp0
	sta.b tmp1
.loop:
	lda.b [a2],y
	clc
	adc.l scorechars
	clc
	adc.l printfontset
	clc
	adc.b r3
	sta.l textmap,x
	iny
	iny
	inx
	inx
	dec.b tmp0
	bne .loop
.loop2:
	lda.b [a2],y
	clc
	adc.l scorechars
	clc
	adc.l printfontset
	clc
	adc.b r3
	sta.l textmap+$2E,x
	iny
	iny
	inx
	inx
	dec.b tmp1
	bne .loop2
.3:
	plx
	pla
	sta.b a2
	rtl
