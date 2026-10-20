; Draw the zamboni moving across the horizontal rink
showzam:							; called from setvideo
	lda.b vcount
	ldy.b vcount+2
	sbc.w vcountmark
	sta.b tmp0
	tya
	sbc.w vcountmark+2
	bne .rtl
	lda.w sfhormode
	beq .rtl
	lda.w InIntermission
	beq .rtl
	stz.w sprhflip
	stz.w sprvflip
	lda.w #$2000
	sta.w sprattr
	lda.b tmp0
	lsr a
	lsr a
	sta.w sprx
	lda.w #$00C8
	sta.w spry
	lda.w #SPFzamboni
	sta.w sprframe
	jsl.l addframe
.rtl:								; return
	rtl
