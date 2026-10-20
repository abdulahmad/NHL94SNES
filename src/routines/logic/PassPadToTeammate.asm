; Pad d4 (of a penalized player X) takes the first teammate on the ice with no pad (PadTakePosition with his
; position)
PassPadToTeammate:					; called from asspenalty
	ldy.w #$0000
	cpx.w #$000C
	bcc .1
	ldy.w #$000C
.1:									; loop: if playerpad,y >= 0 go to .2, ...
	lda.w playerpad,y
	bpl .2
	lda.w position,y
	bpl .t1
.2:									; Y + 1, Y + 1, go to .1
	iny
	iny
	bra .1

.t1:								; position,y >= 0: call PadTakePosition, return
	phx
	jsl.l PadTakePosition
	plx
	rtl
