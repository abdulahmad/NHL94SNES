; d0 = the crowd meter: sroot(CwdExciteLvl * 4) + 65, at most 128; keeps CrowdPeak and the running average
; CrowdAvg
UpdateCrowdMeter:					; called from CheckCrowdMeter
	phx								;save x
	phy								;save y
	lda.w CwdExciteLvl				;crowd excitement
	asl a							;times 2
	asl a							;times 4
	stz.b d0+2						;high word 0
	sta.b d0						;low word
	jsl.l sroot						;square root
	lda.b d0						;square root
	clc
	adc.w #$0041					;plus 65
	cmp.w #$0080					;at most 128
	bcc .1							;below 128
	lda.w #$0080					;clamp to 128
.1:									;meter level
	sta.b d0						;meter
	cmp.w CrowdPeak					;peak?
	bmi .2							;not a new peak
	sta.w CrowdPeak					;new peak
.2:									;add to the sum
	lda.w CrowdMeterSum				;running sum
	clc
	adc.b d0						;plus this sample
	sta.w CrowdMeterSum				;running sum
	bcc .3							;no carry
	inc.w CrowdMeterSum+2			;carry into the high word
.3:									;average
	inc.w CrowdMeterCount			;one more sample
	lda.w CrowdMeterSum+2			;dividend high
	sta.b r2+2
	lda.w CrowdMeterSum				;dividend low
	sta.b r2
	lda.w CrowdMeterCount			;sample count
	sta.b r1						;divisor
	jsl.l Div32U					;sum / count
	lda.b r0						;quotient
	sta.w CrowdAvg					;running average
	ply								;restore y
	plx								;restore x
	rtl
