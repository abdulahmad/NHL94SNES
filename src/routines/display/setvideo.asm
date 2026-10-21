; Once per game frame: build the sprite table for the next vblank
setvideo:							; called from DoGameFrame, PauseMenu, Pausemode, PeriodOver, ReloadRink...
	stx.b xsave
	ldx.w #$0000
.loop:								; loop: X + 1, X + 1, if not zero go to .loop, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0038
	bne .loop
	ldx.b xsave
	jsl.l show_rink					; set the rink scroll from the camera position
	jsl.l checkfo					; draw the face off sprites
	jsl.l .t3
	jsl.l setsortcords				; draw the sorted objects in display order
	jsl.l setffo					; draw the objects tied to rink scrolling
	jsl.l showclock					; draw the game clock unless a replay is playing
	jsl.l showzam					; draw the zamboni moving across the horizontal rink
	jsl.l showcrowd					; draw the crowd sprites
	jsl.l showref					; referee graphics: only clears the referee flag here
	jsl.l ShowRinkRows				; queue the rink map rows that the vertical scroll brought on screen
	lda.w sfhormode
	beq .1
	jsl.l DrawHorTeams
.1:									; call QueueTextDMA, xsave = X
	jsl.l QueueTextDMA				; queue the changed part of the text map for transfer to video memory
	stx.b xsave
	ldx.w #$0036
.loop2:								; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop2
	ldx.b xsave
	ldx.b a3
	rtl

.t3:								; subroutine: if pregamepause != 0 go to .rtl, ...
	lda.w pregamepause
	bne .rtl
	lda.w sflags
	and.w #$0800
	bne .rtl
	lda.w #SpriteFrames>>16
	sta.b p1+2
	lda.w #SpriteFrames
	sta.b p1
	ldy.w #$0000
	lda.w #SPFarrow-1				; DrawSprite index (frame - 1) of the controller's first arrow
	sta.b r0
	jsr.w .t1
	ldy.w #$0002
	lda.w #SPFarrow+3-1
	sta.b r0
	jsr.w .t1
	ldy.w #$0004
	lda.w #SPFarrow+6-1
	sta.b r0
	jsr.w .t1
	ldy.w #$0006
	lda.w #SPFarrow+9-1
	sta.b r0
	jsr.w .t1
	ldy.w #$0008
	lda.w #SPFarrow+12-1
	sta.b r0
	jsr.w .t1
.rtl:								; return
	rtl

.t1:								; subroutine: if c1playernum,y >= 0 go to .t2, ...
	lda.w c1playernum,y
	bpl .t2
	rts

.t2:								; c1playernum,y >= 0: d0 = Xpos,y, d1 = Ypos,y, if sfhormode = 0 go to...
	tay
	lda.w Xpos,y
	sta.b d0
	lda.w Ypos,y
	sta.b d1
	lda.w sfhormode
	beq .t1x
	lda.b d1
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b d0
	lda.w Xpos,y
	sec
	sbc.w #$00C5
	sta.b d1
	bra .7

.t1x:								; sfhormode = 0: d0 = d0 - Hpos, d1 = d1 - Vpos
	lda.b d0
	sec
	sbc.w Hpos
	sta.b d0
	lda.b d1
	sec
	sbc.w Vpos
	sta.b d1
.7:									; d2 = 0, if d0 - $0074 negative go to .1x, ...
	stz.b d2
	lda.b d0
	cmp.w #$0074
	bmi .1x
	lda.w #$0008
	sta.b d2
.1x:								; if d0 - $FF8D >= 0 go to .2, ...
	lda.b d0
	cmp.w #$FF8D
	bpl .2
	lda.w #$0004
	tsb.b d2
.2:									; if d1 - $0064 negative go to .3, ...
	lda.b d1
	cmp.w #$0064
	bmi .3
	inc.b d2
.3:									; if d1 - $FF9D >= 0 go to .4, ...
	lda.b d1
	cmp.w #$FF9D
	bpl .4
	inc.b d2
	inc.b d2
.4:									; if d2 = 0 go to .rts, ...
	ldx.b d2
	beq .rts
	lda.l jdtab8F,x
	and.w #$00FF
	asl a
	asl a
	asl a
	tax
	lda.l .8,x
	beq .5
	sta.b d0
.5:									; if .8+2,x = 0 go to .6, ...
	lda.l .8+2,x
	beq .6
	sta.b d1
.6:									; r0 = r0 + .8+4,x, r3 = .8+6,x, ora r3, ...
	lda.b r0
	clc
	adc.l .8+4,x
	sta.b r0
	lda.l .8+6,x
	sta.b r3
	lda.b d0
	clc
	adc.w #$0080
	tax
	lda.b d1
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.w #$0070
	tay
	lda.w #$2000
	ora.b r3
	jsl.l DrawSprite
.rts:								; return
	rts
.8:									; dw $0000,$0064,$0000,$0000, dw $0074,$0064,$0001,$0000, dw $0074,$000...
	dw $0000,$0064,$0000,$0000
	dw $0074,$0064,$0001,$0000
	dw $0074,$0000,$0002,$0000
	dw $0074,$FF9C,$0001,$8000
	dw $0000,$FF9C,$0000,$8000
	dw $FF8C,$FF9C,$0001,$C000
	dw $FF8C,$0000,$0002,$4000
	dw $FF8C,$0064,$0001,$4000
