; At the blue line: CheckBreakaway into $1E8B; a new breakaway queues sound 5, raises CwdExciteLvl by 20 and
; counts it for the team ($17C2)
StartBreakaway:						; called from ChkOffsides_blue, ChkOffsides_other
	jsl.l CheckBreakaway
	lda.w IsBreakaway
	sta.w breakaway
	beq .rtl
	lda.w penshot
	bne .1
	lda.w #$7000
	sta.b SfxVelocity
	lda.w #$0005
	jsl.l QueueSound
.1:									; if minus go to .2, ...
	lda.w CwdExciteLvl
	clc
	adc.w #$0014
	bmi .2
	sta.w CwdExciteLvl
.2:									; if puckc - $000C negative go to .3, ...
	phy
	ldy.w #$0000
	lda.w puckc
	cmp.w #$000C
	bmi .3
	ldy.w #$0002
.3:									; if penshot != 0 go to .4, ...
	lda.w penshot
	bne .4
	lda.w tmBreakaways,y
	inc a
	sta.w tmBreakaways,y
.4:									; falls through
	ply
.rtl:								; return
	rtl
