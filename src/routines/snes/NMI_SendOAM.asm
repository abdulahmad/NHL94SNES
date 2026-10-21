; NMI: send the sprite table to OAM when it is ready and there is time
NMI_SendOAM:						; called from NMI_HookReturn
	stx.b DMAQueueHead
	rep #$20
	lda.b DMABudget
	cmp.w #$026E
	bcc NMI_Tick
	sep #$20
	lda.w OAMReady
	beq NMI_Tick
	stz.w OAMReady
	lda.b #$7E
	sta.w A1B0
	rep #$20
	lda.w #DMA_OAM
	sta.w DMAP0
	lda.w OAMShowBuf
	sta.w A1T0L
	lda.w #$0220
	sta.w DAS0L
	stz.w OAMADDL
	sep #$20
	lda.b #$01
	sta.w MDMAEN
NMI_Tick:							; called from NMI_HookReturn, NMI_SendOAM
	rep #$30
	lda.l vcountfrac
	clc
	adc.l vcountstep
	sta.l vcountfrac
	lda.b vcount
	adc.w #$0001
	sta.b vcount
	bcc .2
.1:									; increment vcount+2
	inc.b vcount+2
.2:									; if fadestep = 0 go to .7, ...
	lda.w fadestep
	beq .7
	bmi .4
	cmp.w #$0001
	bne .t1
	lda.w brightness
	cmp.w #$000F
	bcs .5
	lda.w STAT77
	bmi .7
	inc.w brightness
	bra .7

.t1:								; decrement fadestep, go to .7
	dec.w fadestep
	bra .7
.3:									; increment fadestep, go to .7
	inc.w fadestep
	bra .7
.4:									; if not zero go to .3, ...
	cmp.w #$FFFF
	bne .3
	lda.w STAT77
	bmi .7
	dec.w brightness
	bmi .1x
	bne .7
.1x:								; brightness = 0, go to .6
	stz.w brightness
	bra .6
.5:									; brightness >= $000F: brightness = $000F
	lda.w #$000F
	sta.w brightness
.6:									; fadestep = 0
	stz.w fadestep
.7:									; if FrameCountHold != 0 go to .1xx, ...
	rep #$20
	lda.w FrameCountHold
	bne .1xx
	inc.w FrameCount
.1xx:								; if FrameHookNext+1 = 0 go to .2x, ...
	sep #$10
	rep #$20
	ldx.w FrameHookNext+1
	beq .2x
	lda.w FrameHookNext
	sta.w FrameHook
	stz.w FrameHookNext
	ldx.w FrameHookNext+2
	stx.w FrameHook+2
.2x:								; go to [FrameHook]
	ldx.b #$80
	phx
	pea.w NMI_FrameHookReturn-1		; rtl from the hook lands on the next line
	jml.w [FrameHook]
