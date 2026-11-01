; Draw the scoreboard: the period and score boxes on the vertical rink, or the period, teams and scores on the
; horizontal rink
printscores1:						; called from ClrHor, Goal, Intermission, Pausemode, StartHL2 and 4 more
	lda.b d0						;keep d0-d2
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
	stx.b xsave						; keep X
	ldx.w #$0000
.savea:								; loop: X + 1, X + 1, if not zero go to .savea, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
	ldx.b xsave						; restore X
	lda.w sfhormode					;horizontal rink?
	beq .v							;no: vertical boxes
	jmp.w .sbscreen					;yes: scoreboard

.v:									; sfhormode = 0: a1 = printscores1Pos, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos>>16
	sta.b a1+2
	lda.w #printscores1Pos
	sta.b a1
	jsl.l print						; print printscores1Pos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0009					;9 wide
	sta.b d0
	lda.w #$0005					;5 high
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	lda.l OptPlayMode				;play mode
	cmp.w #$0004					;shootout?
	beq .t2							;yes: round number
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos2>>16
	sta.b a1+2
	lda.w #printscores1Pos2
	sta.b a1
	jsl.l print						; print printscores1Pos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w gsp						;period
	sta.b d0						;d0
	cmp.w #$0004					;period 4?
	bne .noso						;no
	dec.w printx					;one column left
	inc.b d0						;overtime label
.noso:								; a1 = PerLabels, call Fprint, call EASNLogo, ...
	lda.w #PerLabels>>16
	sta.b a1+2
	lda.w #PerLabels
	sta.b a1
	jsl.l Fprint					;print the period
	jsl.l EASNLogo					;logo
	jsl.l updatepwrplay				;power play box
	bra .scores

.t2:								; OptPlayMode = $0004: a1 = RoundTxt, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #RoundTxt>>16
	sta.b a1+2
	lda.w #RoundTxt
	sta.b a1
	jsl.l print						; print RoundTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0006					;column 6
	sta.w printx
	lda.w shootoutround				;round
	sta.b d0
	lda.w #$0002					;2 digits
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l print						;print it
.scores:							; if sflags3 bits sf3llcs clear go to .boxes, ...
	lda.w sflags3					;flags
	bit.w #sf3llcs					;line change box up?
	beq .boxes						;no: score boxes
	jmp.w .ex						;yes: skip them

.boxes:								; sflags3 bits sf3llcs clear: a1 = printscores1Pos3, call print, a1 = p...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos3>>16
	sta.b a1+2
	lda.w #printscores1Pos3
	sta.b a1
	jsl.l print						; print printscores1Pos3
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0009					;9 wide
	sta.b d0
	lda.w #$0005					;5 high
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos4>>16
	sta.b a1+2
	lda.w #printscores1Pos4
	sta.b a1
	jsl.l print						; print printscores1Pos4
	pla
	sta.b a1
	pla
	sta.b a1+2
	stz.b d3						;team 0
	stz.b a2						;home
	jsl.l printscores1_ps			;home name and score
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos5>>16
	sta.b a1+2
	lda.w #printscores1Pos5
	sta.b a1
	jsl.l print						; print printscores1Pos5
	pla
	sta.b a1
	pla
	sta.b a1+2
	inc.b d3						;team 1
	inc.b a2
	inc.b a2						;visitors
	jsl.l printscores1_ps			;visitors' name and score
	stz.b a2						;home
	lda.w #$0002
	sta.b a3						;a3 = visitors
	lda.w gmode						;game mode
	bit.w #gmdir					;ends swapped?
	bne .ends						;yes
	stz.b a3						;visitors
	lda.w #$0002
	sta.b a2						;a2 = home
.ends:								; a1 = printscores1Pos6, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos6>>16
	sta.b a1+2
	lda.w #printscores1Pos6
	sta.b a1
	jsl.l print						; print printscores1Pos6
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l nullrtl89					; does nothing
	ldx.b a2						;swap a2 and a3
	lda.b a3
	sta.b a2
	stx.b a3
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos7>>16
	sta.b a1+2
	lda.w #printscores1Pos7
	sta.b a1
	jsl.l print						; print printscores1Pos7
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l nullrtl89					; does nothing
.ex:								; xsave = X
	stx.b xsave						; keep X
	ldx.w #$000E					;8 words
.resta:								; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla								;restore a0-a7
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave						; restore X
	pla								;restore d0-d2
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
	ldx.b a3						;current object
	rtl
.sbscreen:							; a1 = printscores1Pos8, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos8>>16
	sta.b a1+2
	lda.w #printscores1Pos8
	sta.b a1
	jsl.l print						; print printscores1Pos8
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l printscores1_per			;period
	lda.b d1						;keep d1
	pha
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos9>>16
	sta.b a1+2
	lda.w #printscores1Pos9
	sta.b a1
	jsl.l print						; print printscores1Pos9
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w tmscore					;home score
	sta.b d0
	jsl.l Mod100					;2 digits
	jsl.l PushNumber				;as text
	jsl.l AlignBigNumber			;right aligned
	jsl.l printbig					;big digits
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos10>>16
	sta.b a1+2
	lda.w #printscores1Pos10
	sta.b a1
	jsl.l print						; print printscores1Pos10
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w tmscore+2					;visitors' score
	sta.b d0
	jsl.l Mod100					;2 digits
	jsl.l PushNumber				;as text
	jsl.l AlignBigNumber			;right aligned
	jsl.l printbig					;big digits
	pla
	sta.b d1						;restore d1
	jmp.w .ex						;finish
