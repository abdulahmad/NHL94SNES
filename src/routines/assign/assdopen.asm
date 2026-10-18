; Assignment: put the player in the penalty box
assdopen:
	lda.w #$0010
	sta.b d0
	lda.w pfteam,x
	beq .1
	lda.w #$0001
	sta.b d0
.1:
	lda.w PBnum
	clc
	adc.b d0
	sta.w PBnum
	lda.w #$FFFF
	sta.w position,x
	lda.w sfhormode
	bne .t1
	lda.w #SPFPen+8					; sitting in the box (vertical rink)
	sta.w frame,x
	bra .2

.t1:
	lda.w #SPFPen+7					; sitting in the box (horizontal rink)
	sta.w frame,x
.2:
	rtl
