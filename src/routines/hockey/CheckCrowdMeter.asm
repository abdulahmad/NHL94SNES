; UpdateCrowdMeter into CurCrowdMeter; 110 dB or more sets CrowdLoud, and falling under 105 dB then calls
; LowerHotColdTable and clears it
CheckCrowdMeter:
	lda.b d0
	pha
	jsl.l UpdateCrowdMeter
	lda.b d0
	sta.w CurCrowdMeter
	cmp.w #$0069
	bmi .t1
	cmp.w #$006E
	bmi .1
	lda.w #$0001
	sta.w CrowdLoud
	bra .1

.t1:
	lda.w CrowdLoud
	beq .1
	jsl.l LowerHotColdTable
	stz.w CrowdLoud
.1:
	pla
	sta.b d0
	rtl
