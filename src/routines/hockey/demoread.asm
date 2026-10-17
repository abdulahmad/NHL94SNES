; In the demo, Start pauses and any other button ends it (back through Restart); in mode 4 with controller
; sides, Start on any of them pauses from that pad
demoread:
	lda.l OptPlayMode
	cmp.w #$0004
	bne .2
	lda.w cont1team
	ora.w cont2team
	ora.w cont3team
	ora.w cont4team
	ora.w cont5team
	beq .2
	ldx.w #$0000
.1:
	phx
	lda.w cont1team,x
	beq .t1
	txa
	lsr a
	jsl.l ReadjoyA
	lda.b d3
	bit.w #$1000
	beq .t1
	pla
	jmp.w PauseFromPad

.t1:
	plx
	inx
	inx
	cpx.w #$000A
	bcc .1
	rtl
.2:
	lda.w cont1team
	ora.w cont2team
	ora.w cont3team
	ora.w cont4team
	ora.w cont5team
	bne .3
	jsl.l Readjoy1
	lda.b d1
	bit.w #$1000
	beq .t1x
	jmp.w startpause1

.t1x:
	lda.b d1
	bne .4
.3:
	rtl
.4:
	stz.w fadestep
	stz.w FrameByNumber
	jml.l Restart
