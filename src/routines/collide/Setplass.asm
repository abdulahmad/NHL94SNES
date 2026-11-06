; Set player X's first assignment from his position
Setplass:							; called from assbench, check4bench, forcepldata, releasepl
	lda.w position,x				; position
	sta.b d0
	bmi .t1
	lda.w #.1>>16
	sta.b a0+2
	lda.w #.1
	sta.b a0
	ldy.b d0						; index by position
	lda.b [a0],y
	and.w #$00FF					; assignment
	sta.b d0
	jml.l assreplace

.t1:								; return
	rtl
.1:									; agoalie, two D, W, C, W, C
	db agoalie,adefd,adefd,awingd,acenterd,awingd,acenterd
