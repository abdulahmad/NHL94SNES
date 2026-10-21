; Horizontal rink: draw both team blocks (home at x $14, visitors at x 3, row 2) and send their palette rows
DrawHorTeams:						; called from setvideo
	lda.w #$0001
	sta.l horblocks
	lda.b a2
	pha
	stz.b a2
	lda.w HomeTeam
	sta.b d1
	lda.w #$0014
	sta.w printx
	lda.w #$0002
	sta.w printy
	jsl.l DrawTeamBlocks
	lda.w #$0002
	sta.b a2
	lda.w #$0003
	sta.w printx
	lda.w VisTeam
	sta.b d1
	jsl.l DrawTeamBlocks
	pla
	sta.b a2
	lda.w #$0000
	sta.l horblocks
	lda.w #$0000
	sta.l redrawblocks
	lda.w #$1D47
	sta.l colourbuf+$1C2
	sta.l colourbuf+$1E2
	lda.l pausemenuon
	bne .1
	lda.w #$FFFF
	sta.l colourbuf+$1DE
	sta.l colourbuf+$1FE
.1:									; p0+2 = $007F, p0 = $75C0, call DMAToCGRAM, ...
	lda.w #(colourbuf+$C0)>>16
	sta.b p0+2
	lda.w #colourbuf+$C0
	sta.b p0
	ldy.w #$0060
	ldx.w #$0020
	jsl.l DMAToCGRAM
	lda.w #(colourbuf+$1C0)>>16
	sta.b p0+2
	lda.w #colourbuf+$1C0
	sta.b p0
	ldy.w #$00E0
	ldx.w #$0020
	jsl.l WaitFrame
	jsl.l DMAToCGRAM
	jsl.l SendTextMap
	rtl
