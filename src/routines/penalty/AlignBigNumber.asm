; Move printx left by the width of String [a1] in the big font after its first character (one column for a 1,
; else two), so printbig ends it at the old printx
AlignBigNumber:
	ldy.w #$0002
.loop:
	dec.w printx
	lda.b [a1],y
	and.w #$00FF
	cmp.w #$0031
	beq .1
	dec.w printx
.1:
	iny
	tya
	cmp.b [a1]
	bcc .loop
	rtl
