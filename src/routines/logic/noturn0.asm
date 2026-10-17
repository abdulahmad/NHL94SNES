; The wanted direction needs no turn
noturn0:
	lda.w #$0002
	sta.b d4
	lda.w pfrev,x
	beq .1
	lda.w #$0006
	sta.b d4
	lda.b d0
	eor.w #$0008
	sta.b d0
.1:
	lda.b d0
	beq .t3
	lda.w Xvel,x
	sta.b d0
	lda.w Yvel,x
	sta.b d1
	jsl.l vtoa
	bit.w #$0008
	bne .t2
	sec
	sbc.w facedir,x
	clc
	adc.b d4
	and.w #$0007
	sta.b d0
	cmp.w #$0004
	bcs .t2
	jmp.w dostop

.t2:
	inc.w facedir,x
	lda.w attribute,x
	bit.w #$0800
	beq .1x
	dec.w facedir,x
	dec.w facedir,x
.1x:
	lda.w facedir,x
	and.w #$0007
	sta.w facedir,x
	lda.w #SPAglide
	sta.b d1
	lda.w pfrev,x
	bne .t1
	jmp.w SetSPA

.t1:
	ldy.w #$0001
	lda.w #SPAglideback
	jml.l SetSPAFromA

.t3:
	ldy.w #$0001
	lda.w #SPAskateback
	sta.b d1
	lda.w pfrev,x
	bne .2
	ldy.w #$0000
	lda.w #SPAskate
	sta.b d1
	lda.w pflags,x
	bit.w #pf2inj
	beq .1x2
	ldy.w #$0001
	lda.w #SPAstumble
	sta.b d1
.1x2:
	cpx.w puckc
	bne .2
	ldy.w #$0000
	lda.w #SPAskatewp
	sta.b d1
.2:
	lda.w pf2aip,x
	bne revplayeracc
	tya
	sta.w pf2aip,x
	jsl.l SetSPA
revplayeracc:
	lda.w pfrev,x
	beq .1
	lda.b d2
	eor.w #$0004
	sta.b d2
.1:
	jml.l playeracc
