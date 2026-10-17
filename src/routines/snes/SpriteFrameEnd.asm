; move the unused entries off screen, swap the OAM buffers and set OAMReady
SpriteFrameEnd:						;move the unused entries off screen, swap the OAM buffers and set OAMReady
	phb
	pea.w $7E7E
	plb
	plb
	lda.w SpritesLeft
	ldx.w OAMNext
	lda.w #$E100
.loop:
	cpx.w OAMHideEnd
	bcs .1
	sta.w $0000,x
	inx
	inx
	inx
	inx
	bne .loop
.1:
	ldy.w OAMLastEnd
	lda.w OAMNext
org $80B001
	sta.w OAMLastEnd
	sty.w OAMHideEnd
	ldx.w OAMDrawBuf
	ldy.w OAMShowBuf
	stx.w OAMShowBuf
	sty.w OAMDrawBuf
	sep #$20
	lda.b #$01
	sta.w OAMReady
	rep #$20
	plb
	rtl
