; Move object X to its new x / y, checking wall and player collisions
checkcoll:							; called from updateplayers
	stz.w collflag
	lda.w sfhormode
	beq .1
	lda.b d2
	ldy.b d3
	sty.b d2
	sta.b d3
.1:									; if pfnc,x != 0 go to .3, ...
	lda.w pfnc,x
	bne .3
	lda.b d3
	pha
	lda.b d2
	pha
	lda.w Xpos,x					; around the hot spot with the wall
	sta.b d2
	lda.w Ypos,x					; y of X
	sta.b d3
	lda.w radiusx,x					; object radius in x
	sta.w wcradiusx
	lda.w radiusy,x					; object radius in y
	sta.w wcradiusy
	jsl.l checkwallcoll				; check the wall at the hot spot
	lda.w Wallcos,x					; wall hit: done
	ora.w Wallsin,x
	bne .2
	cpx.w #$0018
	bcs .2
	txa								; player number
	jsl.l GetHot					; GetHot
	lda.w Xpos,x					; x of the hot spot
	clc
	adc.b d0
	sta.b d2
	lda.w Ypos,x					; y of the hot spot
	clc
	adc.b d1
	sta.b d3
	lda.w #$0001					; radius 1
	sta.w wcradiusx
	sta.w wcradiusy
	jsl.l checkwallcoll				; check the wall at the stick end
.2:									; d2 = pulled value, d3 = pulled value, if position,x negative go to .3...
	pla
	sta.b d2
	pla
	sta.b d3
	lda.w position,x
	bmi .3
	jsl.l checkplcoll
.3:									; if collflag = 0 go to .t2, ...
	lda.w collflag
	beq .t2
	jmp.w .t3

.t2:								; move up or down OOlist by y
	lda.w OOlistpos,x				; move up/down OOlist by y
	sta.b d1
.loop:								; loop: if d1 = $000F go to .t1, ...
	ldy.b d1
	cpy.w #$000F
	beq .t1
	lda.w OOlist+1,y				; object above
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3						; new y
	sec
	sbc.w Ylist,y					; minus the y of the object above
	beq .t1
	bmi .t1
	inc.w OOlistpos,x				; move X up the list
	lda.w OOlistpos,y				; and the other down
	dec a
	sta.w OOlistpos,y
	sep #$30						; 8-bit registers
	ldy.b d1
	lda.b d4
	sta.w OOlist,y
	txa
	sta.w OOlist+1,y
	rep #$30						; 16-bit registers
	inc.b d1						; next position
	bra .loop

.t1:								; if OOlistpos,x = 0 go to .1x, ...
	lda.w OOlistpos,x
	beq .1x
	sta.b d1
.loopx:								; loop: d4 = OOlist-1,y & $00FF, if plus go to .1x, ...
	ldy.b d1
	lda.w OOlist-1,y				; object below
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3						; new y
	sec
	sbc.w Ylist,y					; minus the y of the object below
	bpl .1x
	dec.w OOlistpos,x				; move X down the list
	lda.w OOlistpos,y				; and the other up
	inc a
	sta.w OOlistpos,y
	sep #$30						; 8-bit registers
	ldy.b d1
	lda.b d4
	sta.w OOlist,y
	txa
	sta.w OOlist-1,y
	rep #$30						; 16-bit registers
	dec.b d1						; previous position
	bne .loopx
.1x:								; Ylist,x = d3, return
	lda.b d3						; new y
	sta.w Ylist,x					; store it
	rtl

.t3:								; undo the move: restore the old x and y
	lda.w SPA,x
	cmp.w #SPAboardfront
	bcs .rtl
	lda.w OldXpos,x					; restore the old x
	sta.w Xpos,x
	lda.w OldYpos,x					; restore the old y
	sta.w Ypos,x
.rtl:								; return
	rtl
