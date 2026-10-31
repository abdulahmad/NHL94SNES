; Close the line change box and redraw the scoreboard
;
; Takes a2 = team. Erases the box area (clearing sf3llcs when the box was in the lower half) and ends in
; printscores1. Called from lcfound and lineinput.
;
; After the jml there is a second routine that nothing calls (.t1): it saves d0-d7 and a1, builds a four cell
; bar from d0 in mesarea (d0 >> 7 capped at 31, 8 per cell), prints it mirrored, and restores everything.
lcfound_close:						; close the line change box and redraw the scoreboard
	jsl.l setlccords				; box position and size
	lda.w printy					; box y
	sec
	sbc.w #$000F					; compare with 15
	bmi .1							; upper half: the lower box flag was never set
	lda.w #$0001					; lower half: clear sf3llcs
	trb.w sflags3
.1:									; erase the area
	inc.b d1						; one more row
	lda.l blankchar					; blank tile
	sta.b d2
	lda.l fobox						; faceoff box on screen?
	bne .2							; yes: do not erase
	jsl.l eraser					; erase d0 x d1 with d2
.2:									; redraw the scoreboard
	jml.l printscores1				; print the scores (returns for us)

.t1:								; unreferenced routine
	stx.b xsave						; save X
	ldx.w #$0000
.loop:								; save d0-d7 on the stack
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010					; eight words
	bne .loop
	ldx.b xsave						; restore X
	lda.b a1						; save a1
	pha
	lda.b a1+2
	pha
	lda.w #$2000					; print attribute $20
	sta.w printa
	lda.b d0						; value to show
	lsr a							; divide by 128
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	cmp.w #$0020					; cap at 31
	bcc .1x
	lda.w #$001F
.1x:								; d0 = A, mesarea = $0006, d3 = $0003
	sta.b d0						; d0 = cell value
	ldy.w #$0002					; Y = first cell of mesarea
	lda.w #$0006					; string length 6
	sta.w mesarea
	lda.w #$0003					; four cells
	sta.b d3
.loop2:								; next cell
	lda.w #$FFFF					; -1: empty cell
	sta.b d2
	lda.b d0						; value left
	bmi .2x
	sta.b d2						; d2 = 0-7 for this cell
	cmp.w #$0008
	bcc .2x
	lda.w #$0007
	sta.b d2
.2x:								; cell tile number
	lda.b d2
	sec
	adc.b d1
	and.w #$00FF					; low byte
	bne .3							; tile 0 becomes $20 (blank)
	lda.w #$0020
.3:									; mesarea,y = A, Y + 1, d0 = d0 - $0008, ...
	sta.w mesarea,y					; store the cell
	iny
	lda.b d0						; remaining value minus 8
	sec
	sbc.w #$0008
	sta.b d0
	dec.b d3
	bpl .loop2						; all four cells
	lda.b d1						; d1 nonzero
	beq .4
	lda.w #$0C00					; other palette bits
	tsb.w printa
.4:									; print position
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w printx					; move left 11 columns
	sec
	sbc.w #$000B
	sta.w printx
	lda.w #$4000					; mirror bit
	tsb.w printa
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	sep #$20						; swap two cells and the order of the middle two
	lda.w mesarea+5
	ldy.w mesarea+2
	sty.w mesarea+5
	sta.w mesarea+2
	rep #$30						; back to 16 bit
	lda.w mesarea+3
	xba
	sta.w mesarea+3
	lda.w #$4000					; no mirror
	trb.w printa
	pla								; restore a1
	sta.b a1+2
	pla
	sta.b a1
	stx.b xsave						; restore d0-d7
	ldx.w #$000E
.loop3:								; pop loop
	pla
	sta.b d0,x
	dex
	dex
	bpl .loop3
	ldx.b xsave						; restore X
	rtl
