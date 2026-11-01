; a2 holds or hooks X: both slow down, and a penalty may be called
holdcheck:							; called from checkcheck
	lda.w position,x
	beq .t1
	lda.w pfalock,x
	bne .t1
	ldy.b a2						; a2 is the holder
	lda.w Xpos,x					; x of X
	sec
	sbc.w Xpos,y					; minus the holder's x
	sta.b d0
	lda.w Ypos,x					; y of X
	sec
	sbc.w Ypos,y					; minus the holder's y
	sta.b d1
	jsl.l vtoa						; direction from a2 to X
	ldy.b a2						; holder
	lda.b d0
	sec
	sbc.w facedir,y
	inc a							; direction difference
	and.w #$0007
	cmp.w #$0003
	bcs .t1
	lda.w puckc
	cmp.b a3						; X?
	bne .t2
	lda.w #sfssdir					; puck not held anymore
	trb.w sflags					; X has the puck
	bra .t2

.t1:								; return
	rtl

.t2:								; facedir,y = d0, ror a, Xvel,x = A, ...
	lda.b d0
	sta.w facedir,y
	ldy.b a2
	lda.w Xvel,x					; x velocities
	clc
	adc.w Xvel,y					; added
	pha
	asl a
	pla
	ror a							; halved
	sta.w Xvel,x					; both take it
	sta.w Xvel,y
	lda.w Yvel,x					; y velocities
	clc
	adc.w Yvel,y					; added
	pha
	asl a
	pla
	ror a							; halved
	sta.w Yvel,x					; both take it
	sta.w Yvel,y
	tya
	sta.w impactp,x
	lda.w #SPAflail
	sta.w pfalock,x					; locked
	jsl.l SetSPAFromA				; start sprite animation A on object X
	ldx.b a2						; swap a2 and a3
	ldy.b a3
	sty.b a2
	stx.b a3
	tya
	sta.w impactp,x
	lda.w #SPAHold2
	sta.w pfalock,x
	ldy.w SPA,x
	cpy.w #SPAHold
	beq .1
	lda.w #SPAhook2
.1:									; call SetSPAFromA, call PenShotChk, if zero go to .t1x, ...
	jsl.l SetSPAFromA				; start sprite animation A on object X
	jsl.l PenShotChk				; penalty shot check -> A
	beq .t1x
	lda.w BA_Sktr_SCnum
	bpl .t1x
	ldy.b a2
	sty.w BA_Sktr_SCnum
	lda.w playerpad,y
	sta.w pspad
	lda.w #PenShot
	sta.b d0
	jsl.l AddPenalty				; call penalty d0 on player X
	bra .2

.t1x:								; call checkagr, if d0 >= $0001 go to .2, ...
	jsl.l checkagr					; penalty roll for player X: random below * 16
	lda.b d0
	cmp.w #$0001
	bcs .2
	lda.w #$0028
	sta.b d0
	lda.w SPA,x						; holding or hooking by the animation
	cmp.w #SPAHold2					; hold?
	beq .1x
	lda.w #PenHooking				; hooking penalty
	sta.b d0
.1x:								; call AddPenalty
	jsl.l AddPenalty				; call it
.2:									; a2 = a3, a3 = a2, collflag = $FFFF, ...
	ldx.b a2						; swap back
	ldy.b a3
	sty.b a2
	stx.b a3
	lda.w #$FFFF
	sta.w collflag
	rtl
