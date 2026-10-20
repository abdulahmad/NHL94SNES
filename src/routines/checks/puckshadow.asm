; Assignment: the puck shadow follows the puck
;
; Takes X = the shadow object. Puts the shadow just beside the puck (1 unit to the right or
; below depending on sfhormode) while the puck frame shows, otherwise hides it.
;
; Entry of the puck assignment table, run for the shadow object.
puckshadow:							; puck shadow assignment, X = shadow object
	lda.w frame,x					; frame
	cmp.w #SPFpuck					; puck frame: shadow under the puck
	bne .t2							; not the puck frame: .t2
	lda.w puckx						; puck x
	sta.w Xpos,x
	lda.w pucky						; puck y
	sta.w Ypos,x
	stz.w shadowz					; shadowz = 0
	lda.w sfhormode					; horizontal mode flag
	beq .t1							; not set: shift in y
	inc.w Xpos,x					; x + 1
	rtl

.t1:								; shadow is drawn 1 unit off the puck
	inc.w Ypos,x					; y + 1
	rtl

.t2:								; nothing to show
	tay								; frame 0
	beq .rtl						; nothing to show
	stz.w Xpos,x					; x = 0
	lda.w #$012C
	sta.w Ypos,x
	lda.w #$000E					; shadowz = $0E
	sta.w shadowz
	lda.w pucky						; puck y
	bpl .rtl						; puck on the near side: done
.1:									; puck on the far side: flip the shadow
	lda.w #$8000					; attribute $8000
	sta.w attribute,x
	lda.w #$FED4					; y = $FED4
	sta.w Ypos,x
	dec.w shadowz					; shadowz = $0D
.rtl:								; return
	rtl
