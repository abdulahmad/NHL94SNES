; Set the pass direction from player X's facing (passdir, sflags sfspdir), unless he is the goalie holding the
; puck behind the net
setpassmode:
	lda.w position,x
	bne .2
	lda.w puckx
	cmp.w #$FFF0
	bmi .2
	cmp.w #$0010
	bpl .2
	lda.w pucky
	cmp.w #$0108
	bpl .1
	cmp.w #$FEF8
	bpl .2
.1:
	cmp.w #$0110
	bcc .rtl
.2:
	lda.w facedir,x
	and.w #$0007
	sta.w passdir
	lda.w #sfspdir
	tsb.w sflags
.rtl:
	rtl
