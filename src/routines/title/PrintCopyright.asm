; Print the two copyright lines.
PrintCopyright:						; called from TitleScreen
	lda.w #CopyrightLines>>16
	sta.b a1+2
	lda.w #CopyrightLines
	sta.b a1
	lda.w #$0000
	ldx.w #$0080
	ldy.w #$00B8
	jsl.l PrintStringSprites		; draw string a1 as letter sprites at X / Y
	lda.w #CopyrightLines>>16
	sta.b a1+2
	lda.w #CopyrightLines+23
	sta.b a1
	lda.w #$0000
	ldx.w #$0080
	ldy.w #$00C8
	jsl.l PrintStringSprites		; draw string a1 as letter sprites at X / Y
	rts
