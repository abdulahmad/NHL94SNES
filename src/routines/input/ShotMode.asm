; Pad input while shooting: aim with the pad and build shot power during the windup.
ShotMode:
	cpx.w puckc
	bne .off
	lda.w SPA,x
	cmp.w #SPAshotf
	bcc .off
	cmp.w #$F021
	bcs .off
	lda.w SPAnum,x
	cmp.w #$0018
	bcs doshot
	lda.b d0
	bit.w #$0008
	bne .ss0
	and.w #$0007
	sta.w passdir
.ss0:
	lda.w SPAnum,x
	cmp.w #$0010
	bcs .rts
	lda.w passspeed
	clc
	adc.b d7
	sta.w passspeed
	lda.b d2
	bit.w #cbut
	beq .rts
	lda.w #$001C
	sec
	sbc.w SPAnum,x
	sta.w SPAnum,x
	cmp.w #$0018
	bcc .rts
	lda.w #$0018
	sta.w SPAnum,x
	bra doshot
.off:
	lda.w #$0008
	trb.w sflags
.rts:
	rtl
