; The wanted direction needs no turn
noturn0:
	lda.w #$0002					; d4 = 2, 6 skating backwards
	sta.b d4						; backwards?
	lda.w pfrev,x
	beq .1
	lda.w #$0006					; d4 = 6
	sta.b d4
	lda.b d0
	eor.w #$0008					; flip the direction
	sta.b d0
.1:
	lda.b d0
	beq .t3
	lda.w Xvel,x					; moving: stop if the direction is more than 90 degrees off
	sta.b d0
	lda.w Yvel,x					; Y velocity
	sta.b d1
	jsl.l vtoa						; vector to direction
	bit.w #$0008					; no direction?
	bne .t2
	sec								; minus the facing
	sbc.w facedir,x
	clc
	adc.b d4						; plus d4
	and.w #$0007
	sta.b d0
	cmp.w #$0004					; 90 degrees or more off?
	bcs .t2
	jmp.w dostop

.t2:								; turn one step (the way depends on attribute bit 3)
	inc.w facedir,x					; turn one step
	lda.w attribute,x				; attribute
	bit.w #$0800
	beq .1x
	dec.w facedir,x
	dec.w facedir,x
.1x:
	lda.w facedir,x					; facing
	and.w #$0007
	sta.w facedir,x
	lda.w #SPAglide					; glide
	sta.b d1
	lda.w pfrev,x					; backwards?
	bne .t1
	jmp.w SetSPA

.t1:
	ldy.w #$0001
	lda.w #SPAglideback
	jml.l SetSPAFromA

.t3:
	ldy.w #$0001
	lda.w #SPAskateback				; no change: skate
	sta.b d1
	lda.w pfrev,x					; backwards?
	bne .2
	ldy.w #$0000
	lda.w #SPAskate					; skate
	sta.b d1
	lda.w pflags,x					; pflags $0004 (pflags2 bit 6): stumble
	bit.w #pf2inj					; injured?
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
