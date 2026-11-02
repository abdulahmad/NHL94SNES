; d0 = the power play time left, from the penalty box times. a2 = the shorthanded team (the one
; with players in the box), a3 = the team on the power play.
; Called from updatepwrplay.
GetLowestPen:						; time left of the power play -> d0
	stz.b d0						; d0 = total
	stz.b d3						; d3 = previous penalty time
	lda.b a2						; a2 = shorthanded team
	beq .a							; team 0: list offset 0
	lda.w #$001A					; team 1 list starts at offset $1A
.a:									; list offset chosen
	sta.b a0						; a0 = index into tmboxlist
.top:								; walk the box list of team a2, adding up the steps between times
	ldy.b a0						; next list entry
	inc.b a0						; a0 advances
	lda.w tmboxlist,y				; entry in the low byte
	and.w #$00FF					; d2 = player
	sta.b d2
	bit.w #$0080					; bit 7 set = end of list
	bne .t1							; end: go to the power play team
	lda.b a2						; team
	beq .h0							; team 0: state table at 0
	lda.w #$0034					; team 1 state table is $34 bytes on
.h0:								; state table offset chosen
	clc								; index the player
	adc.b d2
	tay
	lda.w tmpdst,y					; player time
	sta.b d2						; keep it in d2
	bit.w #$4000					; bit 14: no running penalty clock
	bne .top						; untimed: next entry
	lda.b d2						; time minus the previous time
	sec								; minus the previous time
	sbc.b d3
	sta.b d2						; d2 = step
	clc								; total += step
	adc.b d0
	sta.b d0
	lda.b d2						; remember this time
	sta.b d3						; remember it
	bra .top						; next entry

.t1:								; second part: the power play team a3
	ldy.b a3						; a3 = power play team
	lda.w tmap,y					; players on ice
	cmp.w #$0006					; six on ice?
	beq .rtl						; yes: done, d0 stays as is
	lda.b d0						; total minus the last time
	sec
	sbc.b d3						; minus the last
	sta.b d0
	lda.b a3						; a3 = team
	beq .1							; team 0: list offset 0
	lda.w #$001A					; team 1 list starts at offset $1A
.1:									; list offset chosen
	sta.b a0						; a0 = index into tmboxlist
.loop:								; walk the box list of a3
	ldy.b a0
	lda.w tmboxlist,y				; next list entry
	inc.b a0
	and.w #$00FF					; d2 = player
	sta.b d2						; player
	bit.w #$0080					; bit 7 set = end of list
	bne .rtl						; end: return
	lda.b a3						; a3 = team
	beq .2							; team 0: state table at 0
	lda.w #$0034					; team 1 state table is $34 bytes on
.2:									; state table offset chosen
	clc
	adc.b d2
	tay								; index the player
	lda.w tmpdst,y					; player time
	bit.w #$4000					; bit 14: no running penalty clock
	bne .loop						; untimed: next entry
	lda.b d0						; total
	cmp.w tmpdst,y					; compare with his time
	bmi .rtl						; total is lower: return
	lda.b d0						; total plus the previous time
	clc								; total
	adc.b d3						; plus the last
	sta.b d0						; new total
.rtl:								; return
	rtl
