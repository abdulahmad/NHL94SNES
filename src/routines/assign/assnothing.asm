; A computer player stands still
assnothing:
	lda.w playerpad,x
	bpl .t1
	lda.w #$0008
	sta.b d0
	jml.l doplayeracc

.t1:
	rtl
