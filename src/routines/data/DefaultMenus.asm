; Set the default menu choices at power on
;
; Copies the 8 default option words at .1 into the option block starting at OptPlayMode. Called from Opening.
DefaultMenus:						; set the default menus
	lda.w #$FFFF					; not a demo
	sta.l notdemo
	lda.w #OptPlayMode>>16			; a0 = OptPlayMode, the destination
	sta.b a0+2
	lda.w #OptPlayMode
	sta.b a0
	lda.w #.1>>16					; a1 = the defaults table at .1
	sta.b a1+2
	lda.w #.1
	sta.b a1
	ldy.w #$0000					; word index
	ldx.w #$0007					; 8 words
.loop:								; copy a word of the defaults
	lda.b [a1],y
	sta.b [a0],y
	iny
	iny
	dex
	bpl .loop						; next word
	rtl								; done
.1:									; the default option words
	dw $0000,$000B,$000A,$0001,$0000,$0000,$0000,$0001
