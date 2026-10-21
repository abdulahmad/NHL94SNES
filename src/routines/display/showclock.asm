; Draw the game clock unless a replay is playing
showclock:							; called from setvideo
	lda.w sflags
	bit.w #sf2replay
	beq .t1
	jmp.w .t2

.t1:								; sflags bits sf2replay clear: mesarea = $0007, mesarea+2 = $0020, mesa...
	lda.w #$0007
	sta.w mesarea
	lda.w #$0020
	sta.w mesarea+2
	lda.w #$003A
	sta.w mesarea+4
	lda.w gameclock
	sta.b r2
	lda.w #$000A
	sta.b r1
	jsl.l Div16x8U
	lda.w RDMPYL
	clc
	adc.w #$0030
	sep #$20
	sta.w mesarea+6
	rep #$20
	lda.b r0
	sta.b r2
	lda.w #$0006
	sta.b r1
	jsl.l Div16x8U
	lda.w RDMPYL
	clc
	adc.w #$0030
	sep #$20
	sta.w mesarea+5
	rep #$20
	lda.b r0
	sta.b r2
	lda.w #$000A
	sta.b r1
	jsl.l Div16x8U
	lda.w RDMPYL
	clc
	adc.w #$0030
	sep #$20
	sta.w mesarea+3
	rep #$20
	lda.b r0
	beq .1
	clc
	adc.w #$0030
	sep #$20
	sta.w mesarea+2
	rep #$20
.1:									; printa = $2000, printx = $0003, printy = $0018, ...
	lda.w #$2000
	sta.w printa
	lda.w #$0003
	sta.w printx
	lda.w #$0018
	sta.w printy
	lda.w sfhormode
	beq .2
	lda.w #$000D
	sta.w printx
	lda.w #$000B
	sta.w printy
	lda.w gsp
	cmp.w #$0004
	beq .t2
.2:									; a1 = mesarea, go to print
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	jml.l print						; print mesarea

.t2:								; return
	rtl
