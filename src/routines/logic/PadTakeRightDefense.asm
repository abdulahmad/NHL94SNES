; R button with defense control on: pad d4 takes the defenseman on the right of the screen (RD when the team
; shoots at the top goal, else LD)
PadTakeRightDefense:
	ldy.w #$0000
	cpx.w #$000C
	bcc .1
	ldy.w #$0002
.1:
	lda.w defcontrol,y
	bne .t1
	rtl

.t1:
	lda.w #$0002
	ldy.w pfgoal,x
	bne PadTakePosition
	lda.w #$0001
	bra PadTakePosition
