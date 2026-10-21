; UpdateCrowdMeter into CurCrowdMeter; 110 dB or more sets CrowdLoud, and falling under 105 dB then calls
; LowerHotColdTable and clears it
CheckCrowdMeter:					; called from Gameloop
	lda.b d0
	pha
	jsl.l UpdateCrowdMeter			; d0 = the crowd meter: sroot + 65, at most 128
	lda.b d0
	sta.w CurCrowdMeter
	cmp.w #$0069
	bmi .t1
	cmp.w #$006E
	bmi .1
	lda.w #$0001
	sta.w CrowdLoud
	bra .1

.t1:								; if CrowdLoud = 0 go to .1, ...
	lda.w CrowdLoud
	beq .1
	jsl.l LowerHotColdTable			; lower the raised hot/cold bytes and count HotColdRaised down
	stz.w CrowdLoud
.1:									; d0 = pulled value, return
	pla
	sta.b d0
	rtl
