; The puck hits player a2: a fast high puck knocks him down, a slower one is caught
puckbody:							; called from checkpuckcoll_ccx
	lda.w puckz
	cmp.w #$0008
	bpl .t2
	lda.b d0
	and.w #$000F
	beq .t2
	jmp.w .3

.t2:								; call a2touchpuck, if puckz - $000E negative go to .t1, ...
	jsl.l a2touchpuck
	ldy.w puckz
	cmp.w #$000E
	bmi .t1
	lda.w #$0005
	jsl.l StreamSfx					; request streamed sound A
	bra .2

.t1:								; puckz - $000E negative: call PuckSfx
	lda.w #$0008
	jsl.l PuckSfx					; play sound A with half the puck velocity
.2:									; puckvz = 0, nopuck,y = $0008, d0 = Xpos,x - Xpos,y, ...
	stz.w puckvz
	ldy.b a2
	lda.w #$0008
	sta.w nopuck,y
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	bne .1
	tya
	jsl.l GetHot
.1:									; d2 = Xvel,x, d3 = Yvel,x, Xvel+1,x = d0, ...
	lda.w Xvel,x
	sta.b d2
	lda.w Yvel,x
	sta.b d3
	sep #$20						; puck velocity high bytes = offset
	lda.b d0
	sta.w Xvel+1,x
	lda.b d1
	sta.w Yvel+1,x
	rep #$30						; 16-bit registers
	jsl.l puckflip					; puckflip
	lda.w puckz
	cmp.w #$0008
	bmi .3
	lda.b d2
	tax
	jsl.l Mul16S
	lda.b r2+2
	sta.b d2+2
org $9EF000
	lda.b r2
	sta.b d2
	lda.b d3
	tax
	jsl.l Mul16S
	ldx.b a3
	lda.b r2
	clc
	adc.b d2
	sta.b d2
	lda.b r2+2
	adc.b d2+2
	sta.b d2+2
	cmp.w #$0900					; $3000^2
	bcc .4
	lda.w puckz
	cmp.w #$000C
	bmi .3
	jmp.w FallDown					; player a2 falls or stumbles from a hit
.3:									; return
	rtl
.4:									; if pfalock,y != 0 go to .3, ...
	ldy.b a2
	lda.w pfalock,y
	bne .3
	inc a
	sta.w pf2aip,y
	lda.w #SPAcatch
	ldx.b a2
	jsl.l SetSPAFromA				; start sprite animation A on object X
	ldx.b a3
	rtl
