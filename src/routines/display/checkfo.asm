; Draw the face off sprites
checkfo:
	lda.w sfhormode
	bne .rtl
	lda.w penshot
	bne .rtl
	lda.w sflags
	bit.w #$0100
	beq .rtl
	bit.w #$0800
	bne .rtl
	stz.w sprvflip
	lda.w #$3000
	sta.w sprpriority
	ldx.w #$0000
.loop:
	lda.l fodropx
	sta.w sprx
	lda.l fodropy
	sta.w spry
	lda.l fofdata2,x
	clc
	adc.w #SPFfaceoff-1
	sta.w sprframe
	lda.l fofdata2+2,x
	and.w #$0800
	sta.w sprhflip
	lda.w #$0000
	cpx.w #$0004
	bne .1
	lda.w #$0200
.1:
	ora.w sprpriority
	sta.w sprattr
	phx
	jsl.l addframe
	plx
	inx
	inx
	inx
	inx
	cpx.w #$000C
	bne .loop
	lda.w #$2000
	sta.w sprpriority
.rtl:
	rtl
