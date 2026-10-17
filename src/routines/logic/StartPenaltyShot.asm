; Set a penalty shot pending for shooter BA_Sktr_SCnum: penshot = 1, the shooting team BA_Team (and its count
; tmPenShots), the shooter number (BA_Skater_Offset); the faceoff spot is saved (psfoxsave / psfoysave) and
; cleared
StartPenaltyShot:
	lda.w penshot
	bne .2
	lda.w BA_Sktr_SCnum
	cmp.w #$000C
	bmi .t1
	lda.w #$0002
	sta.w BA_Team
	inc.w tmPenShots+2
	bra .1

.t1:
	stz.w BA_Team
	inc.w tmPenShots
.1:
	phy
	lda.w BA_Team
	eor.w #$0002
	tay
	lda.w #$0001
	sta.w tmap,y
	ldy.w BA_Team
	lda.w #$0001
	sta.w tmap,y
	ply
	phx
	ldx.w BA_Sktr_SCnum
	lda.w pnum,x
	sta.w BA_Skater_Offset
	plx
	stz.w penshot
	inc.w penshot
	lda.l fox
	sta.w psfoxsave
	lda.l foy
	sta.w psfoysave
	lda.w #$0000
	sta.l fox
	lda.w #$0000
	sta.l foy
.2:
	rtl
