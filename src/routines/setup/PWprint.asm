; Print the password (PassWord through PasstoText into mesarea), unless it is hidden (bit 7)
PWprint:							; called from PasswordRedraw, PlayoffScreen
	lda.l PassWord
	bit.w #$0080
	beq .t1
	jmp.w .1

.t1:								; PassWord bits $0080 clear: a2 = PasstoText, a1 = mesarea, a0 = PassWo...
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.b a2
	pha
	lda.b a2+2
	pha
	lda.w #PasstoText>>16
	sta.b a2+2
	lda.w #PasstoText
	sta.b a2
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #PassWord>>16
	sta.b a0+2
	lda.w #PassWord
	sta.b a0
	lda.w #$0012
	sta.b [a1]
	inc.b a1
	inc.b a1
	lda.w #$000F
	sta.b d1
.loop:								; loop: increment a0, [a1] = [a2],y, increment a1, ...
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	tay
	lda.b [a2],y
	sta.b [a1]
	inc.b a1
	dec.b d1
	bpl .loop
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	jsl.l print						; print mesarea
	pla
	sta.b a2+2
	pla
	sta.b a2
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
.1:									; return
	rtl
