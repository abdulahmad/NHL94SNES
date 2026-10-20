; Sort the objects by screen position for drawing
;
; Takes nothing, returns nothing, all registers are kept. Called from SaveRegsStartHL2, puckfaceoff2,
; assepen,
; SetHor, ClrHor, ReplayMode and InitSortObjects. Fills Ylist, then sorts OOlist/OOlistpos (bubble sort).
SprSort:							; sort the objects by screen position
	phx								; save X, Y, d0, d1 and d2
	phy
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	ldx.w #$0000					; X = 0
	lda.w sfhormode					; horizontal mode?
	bne .1
.loop0:								; Ylist = Y position of the 16 objects
	lda.w Ypos,x
	sta.w Ylist,x
	inx
	inx
	cpx.w #$0020					; 16 words
	bne .loop0
	bra .2							; done
.1:									; horizontal mode: Ylist = X position
	lda.w Xpos,x
	sta.w Ylist,x
	inx
	inx
	cpx.w #$0020
	bne .1
.2:									; one pass over OOlist
	stz.b d2						; no swap yet
	ldx.w #$0000					; X = position in OOlist
.loop:								; compare the pair at X and X + 1
	lda.w OOlist+1,x				; d1 = object at X + 1
	and.w #$00FF
	sta.b d1
	lda.w OOlist,x					; d0 = object at X
	and.w #$00FF
	sta.b d0
	tay								; Y of object d0
	lda.w Ylist,y
	ldy.b d1						; compare with the Y of object d1
	cmp.w Ylist,y					; d0 is not lower on the screen: leave the pair
	bmi .1x
	beq .1x
	lda.w OOlist,x					; swap the two bytes of the pair
	xba
	sta.w OOlist,x
	txa								; OOlistpos of d1 = X
	sta.w OOlistpos,y
	inc a							; OOlistpos of d0 = X + 1
	ldy.b d0
	sta.w OOlistpos,y
	inc.b d2						; count the swap
.1x:								; next pair
	inx
	cpx.w #$000F					; 15 pairs
	bne .loop
	lda.b d2						; swapped: another pass
	bne .2
	pla								; restore the registers
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	ply
	plx
	rtl
