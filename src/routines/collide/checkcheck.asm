; Two players are in contact: check what happens each way
checkcheck:							; called from checkplcoll
	lda.b d4
	pha
	lda.b a2
	pha
	lda.b a3
org $9EA001
	pha
	jsl.l .cc
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
	jsl.l .cc
	pla
	sta.b a3
	pla
	sta.b a2
	pla
	sta.b d4
	ldx.b a3
.rtl:								; return
	rtl
.1:									; go to holdcheck
	jmp.w holdcheck
.cc:								;X is checking a2
	ldy.b a2						; a2 holding: holdcheck
	lda.w SPA,y
	cmp.w #SPAHold
	beq .1
	cmp.w #SPAhook
	beq .1
	cmp.w #SPAsweepchk
	bne .t1
	jmp.w Bcheck

.t1:								;X must be in the burst anim
	lda.w SPA,x
	cmp.w #SPAburst
	bne .rtl
	lda.w gmclock					; clock stopped: fight chance up
	beq .1x
	lda.w #$0100
	sta.w impact,x
	sta.w impact,y
.1x:								; d0 = Xpos,y - Xpos,x, d1 = Ypos,y - Ypos,x, call vtoa, ...
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa						; vector to direction
	lda.b d0
	sec
	sbc.w facedir,x
	and.w #$0007
	asl a
	tay
	lda.w #.4>>16
	sta.b a0+2
	lda.w #.4
	sta.b a0
	sta.w pf2aip,x
	cpy.w #$0000
	bne .3
	lda.w Xpos,x
	cmp.w #$0050
	bpl .t2
	cmp.w #$A057
	bmi .t2
	lda.w Ypos,x
	cmp.w #$00F8
	bpl .t2
	cmp.w #$FF08
	bpl .t2
	lda.w seed
	and.w #$00F0
	beq .3
	bra .2

.t2:								; if seed & $0030 = 0 go to .3
	lda.w seed
	and.w #$0030
	beq .3
.2:									; Y + 1, Y + 1, d0 = Y
	iny
	iny
	sty.b d0
.3:									; call SetSPAFromA, if position,y = 0 go to .t1x, ...
	lda.b [a0],y
	jsl.l SetSPAFromA
	ldy.b a2
	lda.w position,y
	beq .t1x
	lda.b d4
	sec
	sbc.w #$0020
	bmi .t1x
	lda.w #$0078
	sta.b d0
	lda.b d0
	sec
	sbc.w weight,x
	clc
	adc.w weight,y
	lsr a
	sec
	sbc.w impact,y
	beq .t2x
	bmi .t2x
	sta.b d0
	jsl.l randomd0					; random < checking: down
	lda.b d0
	sec
	sbc.w checking,x
	bmi .t2x
	jsl.l checkagr
	lda.b d0
	cmp.w #$0001
	bcs .t1x
	lda.w gmode
	bit.w #gmhl
	bne .t1x
	lda.w seed+1
	and.w #$0002
	clc
	adc.w #PenCharging
	sta.b d0
	jmp.w AddPenalty

.t1x:								; roll a penalty, then a2 falls
	rtl

.t2x:								; call checkagr, if d0 >= $0001 go to .1xx, ...
	jsl.l checkagr
	lda.b d0
	cmp.w #$0001
	bcs .1xx
	lda.w gmode
	bit.w #gmhl
	bne .1xx
	lda.w seed+1
	and.w #$0002
	clc
	adc.w #PenRoughing
	sta.b d0
	jsl.l AddPenalty
.1xx:								; call PenShotChk, if zero go to .2x, ...
	jsl.l PenShotChk
	beq .2x
	lda.w BA_Sktr_SCnum
	bpl .2x
	ldy.b a2
	sty.w BA_Sktr_SCnum
	lda.w playerpad,y
	sta.w pspad
	lda.w #PenShot
	sta.b d0
	jsl.l AddPenalty
.2x:								; go to FallDown
	jmp.w FallDown
.4:									; check animation by direction (93S .list, with a 94 animation first)
	dw SPAcrosscheck&$FFFF,SPAshoulderchkr&$FFFF,SPAhipchkr&$FFFF,SPAhipchkr&$FFFF,SPAhipchkr&$FFFF,SPAhipchkl&$FFFF,SPAhipchkl&$FFFF,SPAshoulderchkl&$FFFF
