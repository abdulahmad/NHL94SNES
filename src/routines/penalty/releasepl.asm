; Player d0's penalty time is up: let him out of the box and put him on the ice
releasepl:							; called from updatepentime
	stx.b xsave
	ldx.w #$0000
.save:								; loop: X + 1, X + 1, if not zero go to .save, ...
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:								; loop: X + 1, X + 1, if not zero go to .savea, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
	ldx.b xsave
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.find:								; loop: X + 1, X + 1, if position,x >= 0 go to .find, ...
	inx
	inx
	lda.w position,x
	bpl .find
	lda.b d0
	lsr a
	sta.b d3
	ldy.b a2
	lda.w tmap,y
	sta.b d1
	inc a
	sta.w tmap,y
	lda.w #$0001
	tsb.w tmflags
	tsb.w tmflags+2
	lda.w #priolist>>16
	sta.b a0+2
	lda.w #priolist
	sta.b a0
	lda.w tmgoalie,y
	bpl .tmgoaliepos
	inc.b a0
.tmgoaliepos:						; position,x = [a0],y & $00FF, a3 = X, call Setplass, ...
	ldy.b d1
	lda.b [a0],y
	and.w #$00FF
	sta.w position,x
	stx.b a3
	jsl.l Setplass
	jsl.l setplayer
	lda.w pflags,x
	ora.w #$1000
	sta.w pflags,x
	stx.b xsave
	ldx.w #$000E
.resta:								; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$000E
.restore:							; loop: d0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
