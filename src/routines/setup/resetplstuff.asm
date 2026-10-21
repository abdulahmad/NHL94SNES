; Reset the team variables and the players on both teams
;
; Takes nothing, returns nothing; d0 to d2, the 16 bytes at a0 and X are kept. Called from puckfaceoff2 and
; SaveRegsStartHL2. Runs .t1 once for each team (a2 = team * 2).
resetplstuff:						; reset the players of both teams
	lda.b d0						; save d0, d1 and d2
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
	stx.b xsave						; save X
	ldx.w #$0000
.loop:								; push the 16 bytes at a0
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .loop
	ldx.b xsave						; X back
	stz.b a2						; team 0
	jsl.l .t1						; reset its players
	lda.w #$0002					; team 1
	sta.b a2
	jsl.l .t1						; reset its players
	stx.b xsave						; keep X
	ldx.w #$000E
.loop2:								; pull the 16 bytes back into a0
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop2
	ldx.b xsave						; X and d2, d1, d0 restored
	pla
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
	ldx.b a3						; X = a3
	rtl

.t1:								; reset the players of team a2 / 2
	ldy.b a2						; Y = team * 2
	lda.w tmflags,y					; clear team flag $0010
	and.w #$FFEF
	sta.w tmflags,y
	lda.w #$0005					; 6 players (d2 counts 5 to 0)
	sta.b d2
	ldx.w tmsort,y					; X = first player of the team (tmsort)
	stx.b a3
.1:									; next player
	stz.w pf2aip,x					; no animation in progress
	lda.w pflags,x					; pflags: clear bits $D000
	and.w #$2FFF
	sta.w pflags,x
	lda.w position,x				; player position
	bmi .3							; negative: not a skater slot, skip
	bne .t1x						; not 0:
	lda.w #SPAgready				; position 0: ready animation
	bra .2

.t1x:								; other positions: glide animation
	lda.w #SPAglide					; SPAglide
.2:									; start the animation
	jsl.l SetSPAFromA
	stz.w impact,x					; no impact, no puck collision block
	stz.w nopuck,x
	lda.w pflags,x					; pflags: clear bits $0009
	and.w #$FFF6
	sta.w pflags,x
	stz.w pfnc,x					; no collision mode, not backwards, not locked
	stz.w pfrev,x
	stz.w pfalock,x
.3:									; next player of the team
	inc.b a3						; a3 = next player (word index)
	inc.b a3
	ldx.b a3
	dec.b d2						; 6 players done?
	bpl .1
	rtl
