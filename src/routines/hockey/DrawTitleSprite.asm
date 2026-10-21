; Title: draw sprite A of the title set in titlesprbuf at its position from the .1 / .2 tables
DrawTitleSprite:					; called from DrawLicenceNHL, DrawLicenceNHLPA, RollCredits, TitleScreen
	sta.b r0
	asl a
	tax
	lda.w #titlesprbuf>>16
	sta.b p1+2
	lda.w #titlesprbuf
	sta.b p1
	lda.l .2,x
	tay
	lda.l .1,x
	tax
	lda.w #$3000
	jsl.l DrawSprite
	rts
.1:									; dw $0058,$0040,$0028,$0070,$0060,$0050,$0080,$0080,$0080,$0007,$00D0
	dw $0058,$0040,$0028,$0070,$0060,$0050,$0080,$0080,$0080,$0007,$00D0
.2:									; dw $0058,$0040,$0028,$0060,$0048,$0028,$0060,$0048,$0028,$00B0,$00B0
	dw $0058,$0040,$0028,$0060,$0048,$0028,$0060,$0048,$0028,$00B0,$00B0
