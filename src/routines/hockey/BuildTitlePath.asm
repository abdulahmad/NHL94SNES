; Build the title logo path, $500 steps: the mode 7 scale ($7F8000), the x offset ($7F8A00) and the y scroll
; ($7F9400) of each step
BuildTitlePath:
	ldx.w #$0000
	ldy.w #$0000
.loop:
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
