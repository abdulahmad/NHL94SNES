; Change the lines on the ice. Start opens the line menu.
EditLinesScreen:					; called from PauseEditLines
	jsl.l GetPauseTeam
	ldy.b a2
	lda.w tmline,y
	inc a
	sta.b d0
	sta.w SelectedPlayerIdx
	stz.w DispAttribCtr
	ldx.b a2
	lda.w HomeTeam,x
	sta.l setupvis
	lda.w #$FFFF
	sta.l setuphome
	jsl.l SetupScreen
	jsl.l DrawEditLinesTop
	lda.w #$0005
	sta.w lineslots
	dec a
	sta.w linecursor
	jsl.l PrintLineNames
	lda.w #$0005
	ldx.w #$0068
	jsl.l SetupBandIRQ
	jsl.l MenuScreenHDMA
	jsl.l ScreenOn
.3:									; call SendTextMap, call WaitFrame, call ReadPads, ...
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads
	jsl.l ReadPausePad
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$1000
	beq .t2
	jsr.w EditLinesMenu
	cmp.w #$0000
	beq .t1
	jmp.w EditLinesRtl

.t1:								; call PrintLineNames, go to .3
	jsl.l PrintLineNames
	bra .3

.t2:								; d1 bits $1000 clear: if not zero go to .t1x, ...
	bit.w #$8080
	bne .t1x
	jmp.w .t3

.t1x:								; call SelectLinePlayer, if minus go to .1, ...
	jsl.l SelectLinePlayer
	cmp.w #$0000
	bmi .1
	jsr.w SetLineSlot
.1:									; drawlinesback = $0001, call PrintLineNames, a1 = EditLinesScreenPos, ...
	lda.w #$0001
	sta.l drawlinesback
	jsl.l PrintLineNames
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #EditLinesScreenPos>>16
	sta.b a1+2
	lda.w #EditLinesScreenPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w SelectedPlayerIdx
	sta.b d0
	lda.w #LineMenuNames>>16
	sta.b a1+2
	lda.w #LineMenuNames
	sta.b a1
	lda.l OptLine
	bne .2
	lda.w #BestLineNames>>16
	sta.b a1+2
	lda.w #BestLineNames
	sta.b a1
.2:									; call AdvanceStringPtr, call print, call SendTextMap, ...
	jsl.l AdvanceStringPtr
	jsl.l print
	jsl.l SendTextMap
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #EditLinesScreenPos2>>16
	sta.b a1+2
	lda.w #EditLinesScreenPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jmp.w .5

.t3:								; d0 = 0, increment d0, if not zero go to .t2x, ...
	stz.b d0
	inc.b d0
	bit.w #$0100
	bne .t2x
	dec.b d0
	dec.b d0
	bit.w #$0200
	bne .t2x
	bit.w #$0400
	bne .1x
	inc.b d0
	inc.b d0
	bit.w #$0800
	beq .5
.1x:								; if minus go to .5, ...
	lda.b d0
	clc
	adc.w linecursor
	bmi .5
	cmp.w lineslots
	bpl .5
	sta.w linecursor
	jsl.l PrintLineNames
	jmp.w .5

.t2x:								; if OptLine = 0 go to .5, ...
	lda.l OptLine
	beq .5
	lda.b d0
	clc
	adc.w SelectedPlayerIdx
	dec a
	bmi .5
	cmp.w #$0007
	bcs .5
	inc a
	sta.w SelectedPlayerIdx
	cmp.w #$0006
	bmi .t1x2
	lda.w lineslots
	cmp.w #$0004
	beq .4
	dec.w lineslots
	lda.w linecursor
	beq .4
	dec.w linecursor
	bra .4

.t1x2:								; if lineslots = $0005 go to .4, ...
	lda.w lineslots
	cmp.w #$0005
	beq .4
	inc.w lineslots
	inc.w linecursor
.4:									; call PrintLineNames
	jsl.l PrintLineNames
.5:									; go to .3
	jmp.w .3
