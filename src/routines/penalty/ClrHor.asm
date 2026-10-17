; Switch back from the horizontal rink to the vertical ice rink
ClrHor:
	stx.b xsave
	ldx.w #$0000
.loop:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0038
	bne .loop
	ldx.b xsave
	lda.w brightness
	beq .1
	jsl.l FadeOut
	jsl.l WaitFadeOut
	jsl.l FadeIn
	lda.w #$000A
	sta.w fadestep
.1:
	stz.w sfhormode
	lda.w #$03E7
	sta.w Oldrow
	jsl.l SprSort
	lda.w sflags
	bit.w #sfpz
	bne .2
	jsl.l ClearTextMap
	stz.w textdirtylo
	lda.w #$03FF
	sta.w textdirtyhi
	jsl.l printscores1
.2:
	lda.w #palbuffer>>16
	sta.b p0+2
	lda.w #palbuffer
	sta.b p0
	ldy.w #$0000
	ldx.w #$0080
	jsl.l DMAToCGRAM
	stx.b xsave
	ldx.w #$0036
.loop2:
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop2
	ldx.b xsave
	ldx.b a3
	rtl
