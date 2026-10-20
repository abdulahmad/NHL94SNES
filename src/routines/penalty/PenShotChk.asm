; A = -1 when the player hit (a2) is the puck carrier on a breakaway (no penalty shot under way): a penalty
;
; Called from Bcheck, holdcheck and checkcheck. a2 = player hit. Returns A = -1 when he is the puck carrier,
; gmode bit $0010 is clear and CheckBreakaway says he is on a breakaway, else A = 0.
; shot instead of the penalty; else 0
PenShotChk:							; penalty shot check -> A
	lda.w gmode						; game mode
	bit.w #$0010					; flag $0010: highlight mode
	bne .t3							; set: no penalty shot
	lda.b a2						; player hit
	cmp.w puckc						; the puck carrier?
	bne .t3							; no: no penalty shot
	lda.w breakaway					; breakaway flag
	bne .t2							; set: check it again
	jmp.w .t3						; clear: no penalty shot

.t2:								; is it a breakaway now?
	jsl.l CheckBreakaway			; CheckBreakaway result
	lda.w IsBreakaway				; IsBreakaway
	sta.w breakaway					; breakaway flag = result
	bne .t1							; yes: penalty shot
	jmp.w .t3						; no: return 0

.t1:								; penalty shot
	lda.w #$FFFF					; A = -1
	bra .1

.t3:								; return 0
	lda.w #$0000					; A = 0
.1:									; the exit
	rtl								; return
