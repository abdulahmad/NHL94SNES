; Set the crowd noise volume from Crowdlevel
updatesound:						; called from periodicevents
	lda.l Crowdlevel
	cmp.w #$0380
	bcc .1
	lda.w #$0380
.1:									; adc #$0080, asl a, asl a, ...
	clc
	adc.w #$0080
	asl a							; times 8
	asl a
	asl a
	asl a
	sta.w VoiceGain+2
	phx
	tax
	lda.w #$0015
	jsl.l DivX8U					; X / A into A with the hardware divider
	plx
	clc
	adc.w #$0253
	sta.w VoicePitch+2
	lda.w VoiceGain+2
	cmp.w #$2733
	bcs .t1
	lda.w #$0100
	sta.w VoiceGain
	rtl

.t1:								; VoiceGain+2 >= $2733: sbc #$2600, asl a, asl a, ...
	sec
	sbc.w #$2600
	asl a
	asl a
	sta.w VoiceGain
	rtl
