; Put the player at the cursor in shooter row curitem; if that player is already in the list, the two swap
SetShooter:							; called from ShooterSelectList
	ldy.b d1
	phy
	lda.w #$0009
	sec
	sbc.w curplayer
	clc
	adc.w picktop
	and.w #$00FF
	sta.b d0
	lda.w #homeshooters>>16
	sta.b a1+2
	lda.w #homeshooters
	sta.b a1
	lda.b a2
	beq .1
	lda.w #awayshooters>>16
	sta.b a1+2
	lda.w #awayshooters
	sta.b a1
.1:									; d1 = [a1],y & $00FF
	ldy.w curitem
	sep #$20
	lda.b [a1],y
	rep #$20
	and.w #$00FF
	sta.b d1
	lda.b d0
	ldy.w #$0001
.loop:								; loop: if zero go to .t1, ...
	sep #$20
	cmp.b [a1],y
	rep #$20
	beq .t1
	iny
	cpy.w #$0007
	bmi .loop
	bra .2

.t1:								; [a1],y = d1
	lda.b d1
	sep #$20
	sta.b [a1],y
	rep #$20
.2:									; [a1],y = d0, d1 = pulled value, return
	ldy.w curitem
	lda.b d0
	sep #$20
	sta.b [a1],y
	rep #$20
	pla
	sta.b d1
	rtl
