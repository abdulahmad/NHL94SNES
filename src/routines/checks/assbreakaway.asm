; Assignment: the puck carrier on a breakaway (asstab $10): skate in on the goal and shoot; anyone else exits
assbreakaway:						; X = puck carrier; others and non-pad players exit (asstab $10)
	cpx.w puckc
	bne .1
	lda.w playerpad,x
	bmi .8
.1:									; go to assexit
	jmp.w assexit

.t1:								; bare return, not branched to in this file
	rtl
.2:									; gmclock != 0: call GlideBack, nopuck,x = $003C, go to assnothing
	jsl.l GlideBack
	lda.w #$003C
	sta.w nopuck,x
	jmp.w assnothing
.8:									; playerpad,x negative: if gmclock != 0 go to .2, ...
	lda.w gmclock
	bne .2
	lda.w Ypos,x
	sta.b d0
	ldy.w pfgoal,x
	bne .2x
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.2x:								; if pflags,x bits $0002 clear go to .1x, ...
	lda.w pflags,x
	bit.w #$0002
	beq .1x
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	stz.w sopathpoint
	lda.w seed
	and.w #$0003
	sta.w temp3,x
	jsr.w .11
.1x:								; if sopathnext negative go to .4, ...
	lda.w sopathnext
	bmi .4
	lda.b d0
	cmp.w sopathnext
	bmi .3
	jsr.w .9
	lda.w facedir,x
	sta.w sopathface
.3:									; d0 = sopathx, d1 = sopathy, if pfgoal,x != 0 go to .1xx, ...
	lda.w sopathx
	sta.b d0
	lda.w sopathy
	sta.b d1
	lda.w pfgoal,x
	bne .1xx
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.1xx:								; a0 = .nocallback, temp2,x = temp2,x - impactstep, go to skateto
	lda.w #.nocallback>>16
	sta.b a0+2
	lda.w #.nocallback
	sta.b a0
	lda.w temp2,x
	sec
	sbc.w impactstep
	sta.w temp2,x
	jml.l skateto
.4:									; sopathnext negative: if zero go to .3, ...
	lda.w facedir,x
	sec
	sbc.w sopathface
	beq .3
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .t1x
	jsl.l RandomWord
	and.w #$0F80
	bne .3
	bra .5

.t1x:								; facing 2+ steps off sopathface: random test with $0600
	jsl.l RandomWord
	and.w #$0600
	bne .3
.5:									; call RandomWord, and #$0001, increment a, ...
	jsl.l RandomWord
	and.w #$0001
	inc a
	inc a
	sta.b d0
	ldy.w sopathside
	bpl .1xxx
	lda.b d0
	clc
	adc.w #$0003
	sta.b d0
.1xxx:								; passdir = d0, passspeed = $0014, d0 = $0000 - Xpos,x, ...
	lda.b d0
	sta.w passdir
	lda.w #$0014
	sta.w passspeed
	lda.w #$0000
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w pfgoal,x
	bne .t1xx
	lda.w #$FEF8
	sec
	sbc.w Ypos,x
	sta.b d1
	bra .6

.t1xx:								; pfgoal set: shoot at y = $0108 - Ypos instead of $FEF8 - Ypos
	lda.w #$0108
	sec
	sbc.w Ypos,x
	sta.b d1
.6:									; call vtoa, call Findhittype, if zero go to .t1xxx, ...
	jsl.l vtoa
	jsl.l Findhittype
	beq .t1xxx
	lda.w #SPAonetimerb
	bra .7

.t1xxx:								; Findhittype gave 0: use SPAonetimerf instead of SPAonetimerb
	lda.w #SPAonetimerf
.7:									; call SetSPAFromA, call updateanim, SPAcnt,x = $0002, ...
	jsl.l SetSPAFromA
	jsl.l updateanim
	lda.w #$0002
	sta.w SPAcnt,x
	jsl.l doshot
	rtl
.nocallback:						; the skateto callback that does nothing
	rtl
.9:									; subroutine: a0 = long .10, d0 = [a0],y, ...
	lda.w sopathpoint
	asl a
	adc.w sopathpoint
	asl a
	tay
	lda.w #.10>>16
	sta.b a0+2
	lda.w #.10
	sta.b a0
	lda.b [a0],y
	sta.b d0
	lda.w sopathside
	bpl .1xxxx
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.1xxxx:								; sopathx = d0, Y + 1, Y + 1, ...
	lda.b d0
	sta.w sopathx
	iny
	iny
	lda.b [a0],y
	sta.w sopathy
	iny
	iny
	lda.b [a0],y
	sta.w sopathnext
	inc.w sopathpoint
	rts
.10:								; dw 40,120,74,-22,151,134,-22,224,177,44,227,-1
	dw 40,120,74,-22,151,134,-22,224,177,44,227,-1
.11:								; subroutine: if d0 - $002C >= 0 go to .4x, ...
	lda.b d0
	cmp.w #$002C
	bpl .4x
	jsl.l RandomWord
	and.w #$00C0
	beq .t1xxxx
	lda.w attribute,x
	bit.w #$0800
	bne .1xxxxx
	bra .2xx

.t1xxxx:							; random bits $00C0 are 0: roll another value, else decide by attribute
	jsl.l RandomWord
	and.w #$00F0
	sta.b d0
	lda.w #$007F
	sec
	sbc.b d0
	bmi .2xx
.1xxxxx:							; go to .3x
	lda.w #$002D
	bra .3x
.2xx:								; falls through
	lda.w #$FFD3
.3x:								; if pfgoal,x != 0 go to .2xxx
	ldy.w pfgoal,x
	bne .2xxx
.1xxxxxx:							; eor #$FFFF, increment a
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xxx:								; sopathside = A, sopathx = A, sopathy = $0028, ...
	sta.w sopathside
	sta.w sopathx
	lda.w #$0028
	sta.w sopathy
	lda.w #$001E
	sta.w sopathnext
	rts
.4x:								; d0 - $002C >= 0: if Xpos,x - $0020 >= 0 go to .8x, ...
	lda.w Xpos,x
	cmp.w #$0020
	bpl .8x
	cmp.w #$FFE0
	bmi .8x
	jsl.l RandomWord
	and.w #$00C0
	beq .t1xxxxx
	lda.w attribute,x
	bit.w #$0800
	bne .1xxxxxxx
	bra .5x

.t1xxxxx:							; random bits $00C0 are 0: roll another value, else decide by attribute
	jsl.l RandomWord
	and.w #$00F0
	sta.b d0
	lda.w #$007F
	sec
	sbc.b d0
	bmi .5x
.1xxxxxxx:							; go to .6x
	lda.w #$002C
	bra .6x
.5x:								; falls through
	lda.w #$FFD4
.6x:								; if pfgoal,x != 0 go to .1xxxxxxxx, ...
	ldy.w pfgoal,x
	bne .1xxxxxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.1xxxxxxxx:							; sopathside = A, sopathx = A
	sta.w sopathside
	sta.w sopathx
.7x:								; sopathpoint = $0002, sopathy = $0097, sopathnext = $0086, ...
	lda.w #$0002
	sta.w sopathpoint
	lda.w #$0097
	sta.w sopathy
	lda.w #$0086
	sta.w sopathnext
	rts
.8x:								; sopathside = A, sopathx = 0, go to .7x
	sta.w sopathside
	stz.w sopathx
	bra .7x
