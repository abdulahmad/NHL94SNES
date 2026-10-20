; Set the period length and stop the clock
ResetClock:							; no input; gameclock, PerTimeTotal and gmclock are set
	jsl.l GetPeriodTime				; d0 = length of a period
	lda.w shootoutmode				; shootout?
	beq .t1							; no
	lda.w #$0019					; d0 = $19 for the shootout
	sta.b d0
	bra .1							; store it

.t1:								; normal game
	lda.w gsp						; game section (period) number
	cmp.w #$0003					; overtime (period 3 or more)?
	bmi .1							; no, use the period length
	lda.l OptPlayMode				; play mode option
	bne .1							; keep the period length
	lda.w #$012C					; overtime length 300
	sta.b d0
.1:									; store the time
	lda.b d0						; clock value
	sta.w gameclock					; current clock
	sta.w PerTimeTotal				; period total
	sta.w gmclock					; game clock copy
	rtl
