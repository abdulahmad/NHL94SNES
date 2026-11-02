; Read the next event of the track at $4C
ReadTrackEvent:						; called from StepTrack
	lda.b CurTrackPtr
	sta.b EventPtr
	jsr.w ReadVarLen
	lda.b [EventPtr]
	inc.b EventPtr
	tay
	sty.b EventCode
	cpy.b #$D9
	bcc .t3
	cpy.b #$E7
	bne .t1
	lda.b [EventPtr]
	and.w #$00FF
	sec
	adc.b EventPtr
	sta.b EventPtr
	jmp.w .2

.t1:								; if zero go to .2, ...
	cpy.b #$D9
	beq .2
	cpy.b #$DA
	beq .2
	cpy.b #$DB
	beq .2
	cpy.b #$E3
	beq .2
	cpy.b #$DC
	beq .1
	cpy.b #$EA
	beq .1
	cpy.b #$DD
	beq .1
	cpy.b #$DE
	beq .1
	cpy.b #$E2
	bne .t2
.1:									; increment EventPtr, EventData1 = [EventPtr], go to .2
	lda.b [EventPtr]
	inc.b EventPtr
	tay
	sty.b EventData1
	jmp.w .2

.t2:								; if not zero go to .t1x, ...
	cpy.b #$DF
	bne .t1x
	lda.b [EventPtr]
	inc.b EventPtr
	tay
	sty.b EventData1
	lda.b [EventPtr]
	inc.b EventPtr
	tay
	sty.b EventData2
	jmp.w .2

.t1x:								; if not zero go to .2, ...
	cpy.b #$E5
	bne .2
	lda.b [EventPtr]
	inc.b EventPtr
	inc.b EventPtr
	sta.b EventData2
	jmp.w .2

.t3:								; increment EventPtr, EventData1 = [EventPtr], call ReadVarLen, ...
	lda.b [EventPtr]
	inc.b EventPtr
	tay
	sty.b EventData1
	jsr.w ReadVarLen
	sta.b EventData2
.2:									; return
	rts
