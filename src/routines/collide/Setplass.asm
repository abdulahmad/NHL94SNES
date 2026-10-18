; Set player X's first assignment from his position
Setplass:
	lda.w position,x
	sta.b d0
	bmi .t1
	lda.w #$009F
	sta.b a0+2
	lda.w #.1
	sta.b a0
	ldy.b d0
	lda.b [a0],y
	and.w #$00FF
	sta.b d0
	jml.l assreplace

.t1:
	rtl
.1:
	db $07,$02,$02,$03,$05,$03,$05
