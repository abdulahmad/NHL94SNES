; Draw the crowd sprites
showcrowd:							; called from setvideo
	lda.w sflags
	and.w #$0800
	beq .t1
	lda.w replaynewframe
	bne .t1
	rtl

.t1:								; call UpdateHatTrick, if HomeTeam != $0013 go to .2, ...
	jsl.l UpdateHatTrick
	ldx.w #$0022
	lda.w HomeTeam
	cmp.w #$0013
	bne .2
	lda.w crowdanim+$28
	bne .1
	lda.w cursong
	cmp.w #$0002
	bne .2
.1:									; falls through
	ldx.w #$0028
.2:									; r2 = X, if zero go to .1x, ...
	stx.b r2
	cpx.w #$0000
	beq .1x
	cpx.w #$000A
	bne .t2
.1x:								; if crowdanim+$28 = 0 go to .t2, ...
	lda.w crowdanim+$28
	beq .t2
	jmp.w .5

.t2:								; p1 = long CrowdAnimTable,x, if crowdanim,x = 0 go to .t1x, ...
	lda.w #CrowdAnimTable>>16
	sta.b p1+2
	lda.l CrowdAnimTable,x
	sta.b p1
	lda.w crowdanim,x
	beq .t1x
org $9BA000
	jmp.w .9

.t1x:								; crowdanim,x = 0: if zero go to .5, ...
	cpx.w #$0026
	beq .5
	cpx.w #$0024
	beq .5
	cpx.w #$0022
	beq .4
	cpx.w #$0020
	beq .6
	cpx.w #$0028
	beq .3
	ldy.w #$0008
	lda.b [p1],y
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	cmp.l Crowdlevel
	beq .1xx
	bcs .5
.1xx:								; call RandomWord, and #$03F0, if not zero go to .5
	jsl.l RandomWord
	and.w #$03F0
	bne .5
.3:									; crowdanim,x = $000A, crowdanimstep,x = 0, p0 = [p1],y, ...
	lda.w #$000A
	sta.w crowdanim,x
	tay
	stz.w crowdanimstep,x
	lda.b [p1],y
	sta.b p0
	lda.w #CrowdAnimTable>>16
	sta.b p0+2
	bra .7
.4:									; if puckz - $001A negative go to .5, ...
	lda.w puckz
	cmp.w #$001A
	bmi .5
	asl a
	adc.w puckz
	clc
	adc.w pucky
	cmp.w #$FEB8
	bpl .5
	cmp.w #$FEB0
	bmi .5
	lda.w puckx
	cmp.w #$FFF4
	bpl .5
	cmp.w #$FFEC
	bmi .5
	bra .3
.5:									; go to .8
	jmp.w .8
.6:									; if puckz - $001A negative go to .5, ...
	lda.w puckz
	cmp.w #$001A
	bmi .5
	asl a
	adc.w puckz
	clc
	adc.w pucky
	cmp.w #$FE98
	bpl .5
	cmp.w #$FE90
	bmi .5
	lda.w puckx
	cmp.w #$FFFD
	bpl .5
	cmp.w #$FFF4
	bmi .5
	bra .3
.7:									; crowdanimtime,x = [p1],y * 2 + [p1],y, if [p0],y negative go to .5, ...
	ldy.w #$0006
	lda.b [p1],y
	asl a
	adc.b [p1],y
	sta.w crowdanimtime,x
	ldy.w crowdanimstep,x
	lda.b [p0],y
	bmi .5
	tax
	lda.b [p1]
	jsl.l Mul8U
	ldy.w #$0004
	clc
	adc.b [p1],y
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #CrowdTiles
	sta.b p0
	lda.w #CrowdTiles>>16
	sta.b p0+2
	ldy.w #$0002
	lda.b [p1],y
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$1000
	tay
	lda.b [p1]
	asl a
	asl a
	asl a
	asl a
	asl a
	tax
	jsl.l DMAToVRAM
	ldx.b r2
	cpx.w #$0028
	bne .8
	lda.w crowdanim+$26
	bne .8
	lda.w #$000A
	sta.w crowdanim+$24
	sta.w crowdanim+$26
	stz.w crowdanimtime+$24
	stz.w crowdanimtime+$26
.8:									; X - 1, X - 1, if X counted below 0 go to .t1xx, ...
	ldx.b r2
	dex
	dex
	bmi .t1xx
	jmp.w .2

.t1xx:								; X counted below 0: return
	rtl
.9:									; crowdanimtime,x = crowdanimtime,x - timestep, if plus go to .8, ...
	lda.w crowdanimtime,x
	sec
	sbc.w timestep
	sta.w crowdanimtime,x
	bpl .8
	ldy.w crowdanim,x
	lda.b [p1],y
	sta.b p0
	lda.w #CrowdAnimTable>>16
	sta.b p0+2
	ldy.w crowdanimstep,x
	lda.b [p0],y
	bmi .t1xxx
	iny
	iny
	lda.b [p0],y
	bmi .t1xxx
	tya
	sta.w crowdanimstep,x
	jmp.w .7

.t1xxx:								; if crowdanim,x != $000E go to .t2x, ...
	lda.w crowdanim,x
	cmp.w #$000E
	bne .t2x
	stz.w crowdanim,x
	bra .8

.t2x:								; crowdanim,x != $000E: if zero go to .1xxx, ...
	cpx.w #$0024
	beq .1xxx
	cpx.w #$0026
	bne .t1xxxx
.1xxx:								; crowdanim,x = crowdanim+$28, go to .2x
	lda.w crowdanim+$28
	sta.w crowdanim,x
	bra .2x

.t1xxxx:							; if zero go to .3x, ...
	cmp.w #$000C
	beq .3x
	lda.w #$000C
	sta.w crowdanim,x
.2x:								; p0 = long [p1],y, crowdanimstep,x = 0, ...
	ldy.w crowdanim,x
	lda.b [p1],y
	sta.b p0
	lda.w #CrowdAnimTable>>16
	sta.b p0+2
	stz.w crowdanimstep,x
	jmp.w .7
.3x:								; call RandomWord, and #$00C0, if not zero go to .2x, ...
	jsl.l RandomWord
	and.w #$00C0
	bne .2x
	lda.w #$000E
	sta.w crowdanim,x
	bra .2x
