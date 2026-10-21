; Switch to the horizontal rink (the scoreboard screen)
;
; Called from SaveRegsStartHL2, ReloadRink, Pausemode, chkprogress, ReplayMode and PeriodOver. Saves
; the d0 and a0 register blocks, halves the puck speed, blanks the screen, resets the scroll and the row
; counters, sorts the sprites and runs StatsReport. Restores the registers and returns with x = a3.
SetHor:								; switches to the horizontal rink
	stx.b xsave						; keep x
	ldx.w #$0000
.save:								; save d0 and the next 13 words
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .save
	ldx.b xsave						; restore x
	stx.b xsave						; X again for the second save
	ldx.w #$0000
.savea:								; save a0 and the next 13 words
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .savea
	ldx.b xsave						; restore x
	lda.w puckvx					; puck x speed
	pha
	asl a							; sign into carry
	pla
	ror a							; arithmetic shift right: half
	sta.w puckvx
	lda.w puckvy					; puck y speed
	pha
	asl a							; sign into carry
	pla
	ror a							; arithmetic shift right: half
	sta.w puckvy
	lda.w #$0001					; the rink blocks must be redrawn
	sta.l redrawblocks
	jsl.l forceblack				; blank the screen
	lda.w #$0001					; horizontal mode on
	sta.w sfhormode					; horizontal rink mode on
	stz.w Hscroll					; scroll x = 0
	lda.w #$FFFF					; scroll y = -1
	sta.w Vscroll					; scroll y = -1
	lda.w #$002E					; row to draw from
	sta.w Oldrow					; row to draw from
	stz.w vramrow					; VRAM row = 0
	jsl.l SprSort					; sort the sprites
	jsl.l StatsReport				; draw the stats screen
	stx.b xsave						; keep x
	ldx.w #$001A
.resta:								; pull back a0 and the next 13 words
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave						; restore x
	stx.b xsave						; X again for the second restore
	ldx.w #$001A
.restore:							; pull back d0 and the next 13 words
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave						; restore x
	ldx.b a3						; x = a3
	rtl
