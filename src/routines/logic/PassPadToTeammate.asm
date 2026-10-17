; Pad d4 (of a penalized player X) takes the first teammate on the ice with no pad (PadTakePosition with his
; position)
PassPadToTeammate:
	ldy.w #$0000
	cpx.w #$000C
	bcc .1
	ldy.w #$000C
.1:
	lda.w playerpad,y
	bpl .2
	lda.w position,y
	bpl .t1
.2:
	iny
	iny
	bra .1

.t1:
	phx
	jsl.l PadTakePosition
	plx
	rtl
