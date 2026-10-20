; The goalie skates in direction d0, turning one step toward it
goalieacc:
	lda.w #SPAgready				; SPAgready (2)
	sta.b d1						; ready animation
	lda.b d0						; direction
	and.w #$000F					; 4 bits
	sta.b d0						; keep it
	cmp.w #$0008					; 8 = no direction
	bcc .t2
	ldy.w playerpad,x
	bpl .1
	cmp.w #$0009
	bne .2
.1:
	lda.w Xvel,x
	ora.w Yvel,x
	bne .t3
.2:
	lda.w pf2aip,x
org $9ED002
	bne .t1
	jml.l SetSPA

.t1:								; return
	rtl

.t2:								;d0 = wanted direction: step facedir one eighth toward it
	cpx.w puckc
	beq .t4
	lda.w asscur,x
	cmp.w #$000C
	beq .t4
	lda.w Ypos,x
	bit.w #$8000
	beq .1x
	eor.w #$FFFF
	inc a
.1x:
	cmp.w #$0098
	bcc .t4
	ldy.w playerpad,x
	bmi .2x
	lda.w SPA,x
	cmp.w #SPAgdive
	bcc .2x
	cmp.w #SPAinjury1
	bcc .t3
.2x:
	lda.b d0
	cmp.w facedir,x
	beq .3
	sta.b d2
	lda.w #SPAgready
	jsl.l SetSPAFromA
	jml.l playeracc

.t3:
	jmp.w StopNA

.t4:
	lda.w goalieturnwait,x
	bne .3
	lda.b d0
	sec
	sbc.w facedir,x					; difference to the facing
	sta.b d0						; d0 = difference
	beq .3
	eor.w #$FFFF					; negate
	inc a
	and.w #$0004					; one step (+1/-1) toward d0
	lsr a							; +1 or -1
	dec a
	clc								; plus the facing
	adc.w facedir,x
	and.w #$0007					; 0-7
	sta.b d0						; d0 = new direction
	sta.w facedir,x					; new facing
	lda.w #$0006
	sta.w goalieturnwait,x
.3:
	lda.w goalieturnwait,x
	beq .2xx
	sec
	sbc.w timestep
	bpl .1xx
	lda.w #$0000
.1xx:
	sta.w goalieturnwait,x
.2xx:
	lda.w goalieflags,x
	bit.w #$0002
	bne .t1x
	lda.w #SPAgready
	bra .4

.t1x:
	lda.w #SPAgskate
.4:
	jsl.l SetSPAFromA
	lda.w facedir,x
	sta.b d2						; skate that way
	jml.l playeracc					; d2 = facedir, bank $8F (d2 = direction)
