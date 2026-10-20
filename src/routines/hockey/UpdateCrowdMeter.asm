; d0 = the crowd meter: sroot(CwdExciteLvl * 4) + 65, at most 128; keeps CrowdPeak and the running average
; $19C6
UpdateCrowdMeter:					; called from CheckCrowdMeter
	phx
	phy
	lda.w CwdExciteLvl
	asl a
	asl a
	stz.b d0+2
	sta.b d0
	jsl.l sroot
	lda.b d0
	clc
	adc.w #$0041
	cmp.w #$0080
	bcc .1
	lda.w #$0080
.1:									; d0 = A, if minus go to .2, ...
	sta.b d0
	cmp.w CrowdPeak
	bmi .2
	sta.w CrowdPeak
.2:									; CrowdMeterSum = CrowdMeterSum + d0, if carry clear go to .3, ...
	lda.w CrowdMeterSum
	clc
	adc.b d0
	sta.w CrowdMeterSum
	bcc .3
	inc.w CrowdMeterSum+2
.3:									; increment CrowdMeterCount, r2+2 = CrowdMeterSum+2, r2 = CrowdMeterSum...
	inc.w CrowdMeterCount
	lda.w CrowdMeterSum+2
	sta.b r2+2
	lda.w CrowdMeterSum
	sta.b r2
	lda.w CrowdMeterCount
	sta.b r1
	jsl.l Div32U
	lda.b r0
	sta.w CrowdAvg
	ply
	plx
	rtl
