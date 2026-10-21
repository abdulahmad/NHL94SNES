; Build the title logo path, $500 steps: the mode 7 scale (titlescale), the x offset (titlexofs) and the y
; scroll (titleyscroll) of each step
BuildTitlePath:						; called from TitleScreen
	ldx.w #$0000
	ldy.w #$0000
.loop:								; loop: call TitlePathScale, titlescale,x = A, call TitlePathX, ...
	tya
	jsr.w TitlePathScale
	sta.l titlescale,x
	tya
	jsr.w TitlePathX
	sta.l titlexofs,x
	tya
	jsr.w TitlePathY
	sta.l titleyscroll,x
	inx
	inx
	iny
	cpy.w #$0500
	bcc .loop
	rts
