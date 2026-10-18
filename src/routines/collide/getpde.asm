; d0 = the energy of player X
getpde:
	lda.w pnum,x
	and.w #$00FF
	asl a
	sta.b d1
	lda.w pfteam,x
	beq .1
	lda.w #$0002
.1:
	sta.b a2
	beq .2
	lda.w #$0034
.2:
	adc.b d1
	tay
	lda.w tmpde,y
	sta.b d0
	rtl
