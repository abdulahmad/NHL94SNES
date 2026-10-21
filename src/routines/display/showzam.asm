; Draw the zamboni moving across the horizontal rink
showzam:							; called from setvideo
	lda.b vcount
	ldy.b vcount+2
	sbc.w vcountmark				; minus the mark: elapsed frames
	sta.b tmp0
	tya
	sbc.w vcountmark+2
	bne .rtl						; more than 255 frames: done
	lda.w sfhormode					; horizontal mode
	beq .rtl
	lda.w InIntermission
	beq .rtl
	stz.w sprhflip
	stz.w sprvflip
	lda.w #$2000
	sta.w sprattr
	lda.b tmp0
	lsr a							; elapsed / 4
	lsr a
	sta.w sprx
	lda.w #$00C8
	sta.w spry
	lda.w #SPFzamboni
	sta.w sprframe
	jsl.l addframe
.rtl:								; return
	rtl
