; Once a second, count down the penalty box times. The clock-stopped flag chooses the path.
updatepentime:						; called from PenaltyManager
	lda.w #$0020					; clear flag $20
	trb.w sflags3
	lda.w gmclock					; clock stopped
	beq .t2
	jmp.w .4

.t2:								; gmclock = 0: if PenShotActive = 0 go to .t1, ...
	lda.w PenShotActive
	beq .t1
	jmp.w .4

.t1:								; PenShotActive = 0: Penaltytimer = Penaltytimer - d7, if plus go .4, ...
	lda.w Penaltytimer				; second countdown
	sec								; minus d7
	sbc.b d7
	sta.w Penaltytimer
	bpl .4							; not a second yet
	adc.w #$0018
	sta.w Penaltytimer
	lda.w #$0020					; set flag $20
	tsb.w sflags3
	jsl.l chkatop					; attack zone time
	jsl.l CountPowerPlayTime		; on a penalty clock tick
	stz.b a2						; team 0
	jsl.l .1						; do it
	lda.w #$0002					; team 1
	sta.b a2
.1:									; subroutine: if a2 = 0 go to .2, ...
	lda.b a2
	beq .2							; team 0
	lda.w #$001A					; team 1 list offset
.2:									; a0 = A, a1 = mesarea, d1 = $0002, ...
	sta.b a0						; a0 = list offset
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$0002					; two slots
	sta.b d1
	sta.b d3
.3:									; loop: increment a0, d0 = tmboxlist,y & $00FF, if not zero go to .5, ...
	ldy.b a0						; list byte
	lda.w tmboxlist,y
	inc.b a0						; next entry
	and.w #$00FF					; player number
	sta.b d0
	bit.w #$0080					; end marker
	bne .5
	lda.b a2
	beq .1x							; team
	lda.w #$0034					; away team offset
.1x:								; adc d0, if tmpdst,y bit $4000 set go to .6, ...
	clc
	adc.b d0
	tay
	lda.w tmpdst,y					; state
	bit.w #$4000					; coincidental penalty
	bne .6
	dec.b d1						; one slot less
	bmi .3							; no more slots
	lda.b d0
	sta.b [a1]						; store the player
	inc.b a1
	inc.b a1
	lda.w tmpdst,y					; state
	dec a							; one second less
	sta.w tmpdst,y
	bne .2x							; still in the box
	jsl.l RemovePlayerFromList		; removes a player from a box list
.2x:								; go to .3
	bra .3
.4:									; return
	rtl
.5:									; d0 = mesarea, if d1 = $0001 go to .2xx, ...
	lda.w mesarea					; first player
	sta.b d0
	lda.b d1
	cmp.w #$0001					; only one player
	beq .2xx
	lda.b d1						; slots left
	bne .t1x
	jsl.l .2xx						; check the first
	bra .1xx

.t1x:								; d1 != 0: if d1 != $FFFF go to .4
	lda.b d1
	cmp.w #$FFFF					; none left
	bne .4
.1xx:								; d0 = mesarea+2
	lda.w mesarea+2					; second player
	sta.b d0
org $9EC000
.2xx:								; subroutine: if a2 = 0 go to .1xxx, ...
	lda.b a2						; team
	beq .1xxx
	lda.w #$0034					; away team offset
.1xxx:								; adc d0, if tmpdst,y - $0006 >= 0 go to .4, ...
	clc
	adc.b d0
	tay
	lda.w tmpdst,y					; state
	cmp.w #$0006
	bpl .4
	lda.w tmpdst,y					; state
	bne .rtl						; time left
	jsl.l releasepl					; release him
.rtl:								; return
	rtl
.6:									; tmpdst,y bit $4000 set: decrement a, tmpdst,y = A, if not zero go to...
	dec a							; one second less
	sta.w tmpdst,y
	bit.w #$0800					; coincidental time over
	bne .t2x						; not yet
	jmp.w .3

.t2x:								; if not zero go to .t1xx, ...
	bit.w #$1000					; second part over
	bne .t1xx
	lda.w #$1000					; state
	sta.w tmpdst,y
	jml.l RemovePlayerFromList		; removes a player from a box list

.t1xx:								; tmpdst,y = $0000, go to RemovePlayerFromList
	lda.w #$0000
	sta.w tmpdst,y
	jml.l RemovePlayerFromList		; removes a player from a box list
