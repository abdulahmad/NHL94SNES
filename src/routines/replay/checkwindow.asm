; Move the view so the screen follows the puck
checkwindow:						; called from DoGameFrame, puckfaceoff2
	lda.w yc1						; previous view target y
	sta.b d2
	lda.w xc1						; previous view target x
	sta.b d3
	lda.w sflags					; sfslock: use xc1/yc1
	bit.w #sfslock
	bne .3							; locked: keep the old target
	ldx.w #$001C
	lda.w puckc
	bmi .2
	tax
	lda.w pfgoal,x					; carrier goes up: yleader up to 50, else down to -50
	beq .t1
	lda.w yleader
	adc.w impactstep
	sta.w yleader
	cmp.w #$0032
	bmi .2
	lda.w #$0032					; limit 50
	sta.w yleader
	bra .2

.t1:								; pfgoal,x = 0: yleader = yleader - impactstep, if plus go to .2, ...
	lda.w yleader					; going down: leader shrinks
	sec
	sbc.w impactstep
	sta.w yleader
	cmp.w #$FFCF
	bpl .2
	lda.w #$FFCE					; limit -50
	sta.w yleader
.2:									; if zero go to .1, ...
	lda.w Yvel,x					; y velocity / 128
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0100
	beq .1
	ora.w #$FE00
.1:									; adc Ypos,x, adc yleader, d2 = A, ...
	clc
	adc.w Ypos,x					; plus the object's y
	clc
	adc.w yleader					; plus yleader
	sta.b d2						; d2 = target y
	sta.w yc1						; remember it
	lda.w Xpos,x					; object x
	sta.b d3						; d3 = target x
	sta.w xc1						; remember it
.3:									; d0 = d2 - Vpos, if plus go to .t1x, ...
	lda.b d2						; |target - Vpos| > 10: scroll
	sec
	sbc.w Vpos						; distance from the current view
	sta.b d0
	cmp.w #$FFF7
	bpl .t1x
	lda.b d2
	sec
	sbc.w #$FFF6					; d1 = target - 10 (scrolling up)
	sta.b d1
	cmp.w #$FF39
	bpl .4
	lda.w #$FF39					; limit -199
	sta.b d1
	bra .4

.t1x:								; if d0 - $000B negative go to .5, ...
	lda.b d0
	cmp.w #$000B
	bmi .5
	lda.b d2
	sec
	sbc.w #$000A					; d1 = target + 10 (scrolling down)
	sta.b d1
	cmp.w #$0100
	bmi .4
	lda.w #$0100					; limit $100
	sta.b d1
.4:									; if zero go to .5, ...
	lda.b d1						; step toward d1
	sec
	sbc.w Vpos
	beq .5
	lsr a							; divide by 8
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .1x
	ora.w #$F000
.1x:								; if not zero go to .2x, ...
	cmp.w #$0000					; at least 1
	bne .2x
	inc a
.2x:								; adc Vpos, Vpos = A
	clc
	adc.w Vpos
	sta.w Vpos						; new vertical position
.5:									; d0 = d3 - Hpos, if plus go to .t1xx, ...
	lda.b d3						; |target - Hpos| > 40: scroll
	sec
	sbc.w Hpos						; distance from the current view
	sta.b d0
	cmp.w #$FFD8
	bpl .t1xx
	lda.b d3
	sec
	sbc.w #$FFD8					; d1 = target + 40 (scrolling left)
	sta.b d1
	cmp.w #$FFC4
	bpl .6
	lda.w #$FFC4					; limit -60
	sta.b d1
	bra .6

.t1xx:								; if d0 - $0029 negative go to .7, ...
	lda.b d0
	cmp.w #$0029
	bmi .7
	lda.b d3
	sec
	sbc.w #$0028					; d1 = target - 40 (scrolling right)
	sta.b d1
	cmp.w #$003D
	bmi .6
	lda.w #$003C					; limit 60
	sta.b d1
.6:									; if zero go to .7, ...
	lda.b d1
	sec
	sbc.w Hpos						; step toward d1
	beq .7
	lsr a
	lsr a
	lsr a							; divide by 8
	lsr a
	bit.w #$0800
	beq .1xx
	ora.w #$F000
.1xx:								; if not zero go to .2xx, ...
	cmp.w #$0000					; at least 1
	bne .2xx
	inc a
.2xx:								; adc Hpos, Hpos = A
	clc
	adc.w Hpos
	sta.w Hpos						; new horizontal position
.7:									; return
	rtl
