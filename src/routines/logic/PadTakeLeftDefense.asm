; L button with defense control on ($1C94): pad d4 takes the defenseman on the left of the screen (LD when the
; team shoots at the top goal, else RD), then PadTakePosition
PadTakeLeftDefense:
	ldy.w #$0000
	cpx.w #$000C
	bcc .1
	ldy.w #$0002
.1:
	lda.w defcontrol,y
	bne .t1
	rtl

.t1:
	lda.w #$0001
	ldy.w pfgoal,x
	bne PadTakePosition
	lda.w #$0002
PadTakePosition:
	sta.b d1
	phx
	ldy.b d4
	ldx.w #$0000
	lda.w cont1team,y
	cmp.w #$0001
	beq .1
	ldx.w #$000C
.1:
	lda.w #$0005
	sta.b d0
.loop:
	lda.w position,x
	cmp.b d1
	beq .t1
	inx
	inx
	dec.b d0
	bpl .loop
	bra .2

.t1:
	lda.w playerpad,x
	bpl .2
	lda.w pflags,x
	bit.w #$1000
	bne .2
	lda.w padinputdone,y
	inc a
	sta.w padinputdone,y
	stx.b d0
	jsl.l AssignPadPlayer
.2:
	plx
	rtl
