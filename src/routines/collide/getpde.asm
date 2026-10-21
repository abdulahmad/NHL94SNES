; d0 = the energy of player X
getpde:								; called from burst, makepde, playeracc
	lda.w pnum,x					; player number
	and.w #$00FF					; pnum low byte
	asl a
	sta.b d1						; d1 = number * 2
	lda.w pfteam,x					; player team
	beq .1							; team 0
	lda.w #$0002					; a2 = 2: away team
.1:									; a2 = A, if zero go to .2, ...
	sta.b a2						; a2 = team offset
	beq .2							; team 0: no offset
	lda.w #$0034					; away team entries start $34 bytes in
.2:									; adc d1, d0 = tmpde,y, return
	adc.b d1
	tay								; index into the table
	lda.w tmpde,y					; energy
	sta.b d0						; d0 = energy
	rtl
