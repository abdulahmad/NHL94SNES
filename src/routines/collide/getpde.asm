; d0 = the energy of player X
getpde:
	lda.w pnum,x					; player number
	and.w #$00FF					; pnum low byte
	asl a
	sta.b d1						; d1 = number * 2
	lda.w pfteam,x
	beq .1
	lda.w #$0002
.1:
	sta.b a2
	beq .2
	lda.w #$0034
.2:
	adc.b d1
	tay								; index into the table
	lda.w tmpde,y					; energy
	sta.b d0						; d0 = energy
	rtl
