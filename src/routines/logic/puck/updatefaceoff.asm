; Step the puck drop animation
updatefaceoff:						; called from puckfaceoff2
	lda.w temp1,x					; animation timer
	beq .t2
	clc								; (temp1+6)/8 <= 2: drop frame 10-d0
	adc.w #$0006					; (timer + 6) / 8
	lsr a
	lsr a
	lsr a
	sta.b d0
	cmp.w #$0003
	bpl .rtl
	lda.b d0						; d0 = 10 - d0
	eor.w #$FFFF					; negate
	inc a
	clc
	adc.w #$000A
	sta.b d0
	sta.l fofdata
.rtl:								; return
	rtl

.t2:								; face off display off
	lda.w penshot
	bne .t1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #updatefaceoffPos>>16
	sta.b a1+2
	lda.w #updatefaceoffPos
	sta.b a1
	jsl.l print						; print updatefaceoffPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.l fodropx
	sec
	sbc.w #$002E					; minus the box x origin
	lsr a							; divide by 8
	lsr a
	lsr a
	bit.w #$1000					; sign extend
	beq .2
.1:									; ora #$E000
	ora.w #$E000
.2:									; printx = A, if zero go to .4
	sta.w printx					; print x
	lda.l fodropy
	sec
	sbc.w #$0044					; minus the box y origin
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .4
.3:									; ora #$E000
	ora.w #$E000
.4:									; printy = A, d0 = $000C, d1 = $000C + 1, ...
	sta.w printy					; print y
	lda.w #$000C					; box 12 wide
	sta.b d0
	inc a							; and 13 high
	sta.b d1
	bra .5

.t1:								; penshot != 0: printy = $0001, printx = $0006, d0 = $0014, ...
	lda.w #$0001
	sta.w printy
	lda.w #$0006
	sta.w printx
	lda.w #$0014
	sta.b d0
	lda.w #$0008
	sta.b d1
.5:									; d2 = blankchar, call eraser, FrameCount = 0, ...
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	stz.w FrameCount
	stz.w gameframes
	rtl
