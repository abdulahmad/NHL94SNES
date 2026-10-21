; Fill the other-scores rows, skipping this game.
FillOtherScores:					; called from ShowOtherScores
	lda.w #statspage>>16
	sta.b p1+2
	lda.w #statspage
	sta.b p1
	ldx.w #$4D80
	lda.l smallfontchars
	clc
	adc.l printfontset
	jsl.l MemFill
	lda.w listend
	cmp.w #$0001
	beq .4
	lda.w #$2400
	sta.w printa
	lda.w #$0000
	sta.w printy
	lda.b r0
	sta.w curitem
	stz.w otherskip
.2:									; if not zero go to .t1
	cmp.l gamenum
	bne .t1
.1:									; increment otherskip, go to .3
	inc.w otherskip
	bra .3

.t1:								; if curitem = listend go to .4, ...
	lda.w curitem
	cmp.w listend
	beq .4
	jsr.w PrintOtherScore
	inc.w printy
.3:									; curitem = curitem + 1, go to .2
	lda.w curitem
	inc a
	sta.w curitem
	bra .2
.4:									; return
	rtl
