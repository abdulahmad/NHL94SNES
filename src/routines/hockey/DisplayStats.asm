; Print each team-stat name and both teams' numbers.
DisplayStats:						; called from StatsReport
	lda.w #statspage>>16
	sta.b p1+2
	lda.w #statspage
	sta.b p1
	ldx.w #$4D80
	lda.l smallfontchars
	clc
	adc.l printfontset
	jsl.l MemFill					; fill X bytes at [p1] with the word A
	lda.w #$0000
	sta.w printy
	lda.w #$0000
	sta.w curitem
	lda.w listcount
	sta.b d4
.loop:								; loop: call .t2, increment printy, increment printy, ...
	jsr.w .t2
	inc.w printy
	inc.w printy
	inc.w curitem
	dec.b d4
	bpl .loop
	rts

.t2:								; subroutine: printa = $2800, printx = $0009, d0 = curitem, ...
	lda.w #$2800
	sta.w printa
	lda.w #$0009
	sta.w printx
	lda.w curitem
	sta.b d0
	lda.w #TeamStatNames>>16
	sta.b a1+2
	lda.w #TeamStatNames
	sta.b a1
	lda.l OptPen
	bne .2
.1:									; a1 = TeamStatNamesNoPen, a1+2 = TeamStatNames>>16
	lda.w #TeamStatNames>>16
	sta.b a1+2
	lda.w #TeamStatNamesNoPen
org $9C9000
	sta.b a1
.2:									; call AdvanceStringPtr, call PrintToStatsPage, printa = $2400, ...
	jsl.l AdvanceStringPtr			; a1 = string d0 of the string list [a1]
	jsl.l PrintToStatsPage
	lda.w #$2400
	sta.w printa
	stz.b a2
	lda.w #$001C
	sta.w printx
	jsr.w .t1
	lda.w #$0002
	sta.b a2
	lda.w #$0007
	sta.w printx
	jsr.w .t1
	rts

.t1:								; subroutine: a0 = TeamStatSources, d0 = curitem
	lda.w #TeamStatSources>>16
	sta.b a0+2
	lda.w #TeamStatSources
	sta.b a0
	lda.w curitem
	sta.b d0
.3:									; if [a0] >= 0 go to .t2x, ...
	lda.b [a0]
	bpl .t2x
	jmp.w .8

.t2x:								; [a0] >= 0: and #$00F0, ora statpenrows, if zero go to .1x, ...
	and.w #$00F0
	ora.w statpenrows
	beq .1x
	dec.b d0
	bmi .t1x
.1x:								; a0 = a0 + $0006, go to .3
	lda.b a0
	clc
	adc.w #$0006
	sta.b a0
	bra .3

.t1x:								; d0 counted below 0: increment a0, increment a0, if not zero go to .t3...
	lda.b [a0]
	and.w #$000F
	inc.b a0
	inc.b a0
	cmp.w #$0001
	bne .t3
	jmp.w .5

.t3:								; if zero go to .t2xx, ...
	cmp.w #$0002
	beq .t2xx
	cmp.w #$0003
	bne .t1xx
	jmp.w .6

.t1xx:								; d0 = $0000,y, call PushNumber, go to .7
	lda.b [a0]
	clc
	adc.b a2
	tay
	lda.w $0000,y
	sta.b d0
	jsl.l PushNumber				; a1 = d0 as a decimal string, no leading zeros
	jmp.w .7

.t2xx:								; d0 = $0000,y, increment a0, increment a0, ...
	lda.b [a0]
	clc
	adc.b a2
	tay
	lda.w $0000,y
	sta.b d0
	inc.b a0
	inc.b a0
	lda.b [a0]
	clc
	adc.b a2
	tay
	lda.w $0000,y
	sta.b d1
	lda.b d0
	cmp.b d1
	bpl .t1xxx
	ldx.w #$0064
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	tax
	lda.b d1
	beq .4
	jsl.l DivX8U					; X / A into A with the hardware divider
	bra .4

.t1xxx:								; d0 - d1 >= 0: if d0 = 0 go to .4, ...
	lda.b d0
	beq .4
	lda.w #$0064
.4:									; d0 = A, call PushNumber, a3 = mesarea, ...
	sta.b d0
	jsl.l PushNumber				; a1 = d0 as a decimal string, no leading zeros
	lda.w #mesarea>>16
	sta.b a3+2
	lda.w #mesarea
	sta.b a3
	lda.w #$0002
	sta.b [a3]
	jsl.l appstring					; append string [a1] to string [a3]
	lda.w #StatPercent>>16
	sta.b a1+2
	lda.w #StatPercent
	sta.b a1
	jsl.l appstring					; append string [a1] to string [a3]
	lda.b a3+2
	sta.b a1+2
	lda.b a3
	sta.b a1
	bra .7
.5:									; increment a0, increment a0, d0 = $0000,y, ...
	lda.b [a0]
	inc.b a0
	inc.b a0
	clc
	adc.b a2
	tay
	lda.w $0000,y
	sta.b d0
	jsl.l PushNumber				; a1 = d0 as a decimal string, no leading zeros
	lda.b [a0]
	sta.b d1
	lda.w #mesarea>>16
	sta.b a3+2
	lda.w #mesarea
	sta.b a3
	lda.w #$0002
	sta.b [a3]
	jsl.l appstring					; append string [a1] to string [a3]
	lda.w #StatSlash>>16
	sta.b a1+2
	lda.w #StatSlash
	sta.b a1
	jsl.l appstring					; append string [a1] to string [a3]
	lda.b a2
	clc
	adc.b d1
	tay
	lda.w $0000,y
	sta.b d0
	jsl.l PushNumber				; a1 = d0 as a decimal string, no leading zeros
	jsl.l appstring					; append string [a1] to string [a3]
	lda.b a3+2
	sta.b a1+2
	lda.b a3
	sta.b a1
	bra .7
.6:									; d0 = $0000,y, call PushTime
	lda.b [a0]
	clc
	adc.b a2
	tay
	lda.w $0000,y
	sta.b d0
	jsl.l PushTime					; a1 = the time d0 as a minutes:seconds string
.7:									; printx = -([a1] + 1 / 2) + printx, call PrintToStatsPage
	lda.b [a1]
	inc a
	lsr a
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.w printx
	sta.w printx
	jsl.l PrintToStatsPage
.8:									; return
	rts
