; Draw a referee frame in the referee window
;
; d0 = referee frame number; frame $40 erases the referee window and clears the message (prefmes).
; Other frames are copied from RefsMap (the horizontal rink: RefsMapHor) into the text map, 8 rows
; of 7 words, and the dirty range of the text map is widened. All registers are kept.
; Called from checkob, SetPA, chkprogress, RefsMapHor and RefsMap.
PushRef:							; draws a referee frame
	phx								; keep the registers
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
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.b d0						; frame number
	cmp.w #$0040					; $40: erase the window
	bne .t1							; no: draw the frame
	jmp.w .t2						; yes: .t2

.t1:								; draw frame d0
	cmp.w #$0006					; frame 6 is the little offsides frame
	beq .1
	lda.w #$0001					; any other frame
	sta.l refwindow					; refwindow = 1
.1:
	lda.b d0						; frame offset
	ldx.w #$0070					; times $70 (a frame: 8 rows of 7 words)
	jsl.l Mul8U
	sta.b d0
	lda.w #RefsMap>>16				; a0 = RefsMap
	sta.b a0+2
	lda.w #RefsMap
	sta.b a0
	lda.w #$0084					; text map offset of the window
	sta.b tmp1
	lda.l refchars					; referee tile base
	ora.w #$2000					; with palette bits
	sta.b tmp0
	lda.w sfhormode					; horizontal rink?
	beq .2							; no
	lda.l refcharshor				; horizontal tile base
	sta.b tmp0
	lda.w #$03DA					; text map offset for the horizontal rink
	sta.b tmp1
	lda.w #RefsMapHor>>16			; a0 = RefsMapHor (+6)
	sta.b a0+2
	lda.w #RefsMapHor+6
	sta.b a0
.2:									; add the frame offset
	lda.b a0						; a0 = map + frame offset
	clc
	adc.b d0
	sta.b a0
	lda.w #$0008					; 8 rows
	sta.b tmp2
.loop:								; a row
	ldy.w #$0007					; 7 tiles per row
.loop2:								; a tile
	lda.b [a0]						; map word
	clc
	adc.b tmp0						; plus the tile base
	adc.l charofs					; plus the character offset
	ldx.b tmp1						; text map offset
	sta.l textmap,x					; store it
	txa								; text map word index
	lsr a
	cmp.w textdirtylo				; widen the dirty range: low
	bcs .3
	sta.w textdirtylo
.3:									; high
	cmp.w textdirtyhi
	bcc .4
	sta.w textdirtyhi
.4:									; next tile
	inc.b a0
	inc.b a0
	inc.b tmp1
	inc.b tmp1
	dey								; next tile of the row
	bne .loop2
	lda.b tmp1						; next row
	clc
	adc.w #$0032					; plus the row stride
	sta.b tmp1
	dec.b tmp2						; rows left
	bne .loop
	lda.w #$0200					; referee window changed
	tsb.w sflags
	bra .5							; done

.t2:								; erase the window
	lda.w #$0007					; erase size 7 x 8
	sta.b d0
	lda.w #$0008
	sta.b d1
	lda.l blankchar					; blank tile
	sta.b d2
	lda.w #$0002					; window at column 2, row 2
	sta.w printx
	sta.w printy
	lda.w sfhormode					; horizontal rink?
	beq .1x
	lda.w #$000D					; horizontal rink: column $0D
	sta.w printx
	lda.w #$000F					; row $0F
	sta.w printy
.1x:
	jsl.l eraser					; erase it
	lda.w #$0200					; referee window changed
	tsb.w sflags
	lda.w #$FFFF					; no message
	sta.b d0
	jsl.l prefmes					; clear the message
	lda.w #$0000					; refwindow = 0
	sta.l refwindow
.5:									; restore the registers
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
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
	plx
	rtl								; return
	padbyte $FF
	pad $9F8000
