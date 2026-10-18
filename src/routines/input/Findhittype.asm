; Swing type of player X for direction d0: forehand or backhand
Findhittype:
	lda.b d0
	eor.w #$FFFF
	inc a
	clc
	adc.w facedir,x
	and.w #$0007
	sta.b d0
	lda.w attribute,x
	bit.w #$0800
	beq .t1
	phx
	ldx.b d0
	lda.l .1,x
	plx
	and.w #$00FF
	rtl

.t1:
	phx
	ldx.b d0
	lda.l .1+3,x
	plx
	and.w #$00FF
	rtl
.1:
	db $00,$00,$00,$00,$01,$01,$01,$01,$00,$00,$00
