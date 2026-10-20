; Turn the playoff state into the password bits, with a checksum
WritePassBits:						; called from EncodePW, ResolveGames
	jsl.l ClrPassBits
	stz.b d7
	lda.l postarts
	sta.b d0
	lda.w #$0020
	sta.b d1
	jsl.l .t1
	lda.w bosgames
	sta.b d0
	lda.w #$0008
	sta.b d1
	jsl.l .t1
	lda.l playoffRoundIdx
	sta.b d0
	lda.w #$0004
	sta.b d1
	jsl.l .t1
	lda.l potreeteam
	sta.b d0
	lda.w #$0010
	sta.b d1
	jsl.l .t1
	lda.l pojoy
	sta.b d0
	lda.w #$0004
	sta.b d1
	jsl.l .t1
	lda.w WinBits
	sta.b d0
	lda.w #$4000
	sta.b d1
	jsl.l .t1
	lda.w #$0005
	sta.b d1
	lda.w #$0007
	sta.b d2
	stz.b a1
.loop:								; loop: d0 = gspotwins,x, call .t1, d0 = gspobwins,x, ...
	ldx.b a1
	lda.l gspotwins,x
	sta.b d0
	jsl.l .t1
	ldx.b a1
	lda.l gspobwins,x
	sta.b d0
	jsl.l .t1
	inc.b a1
	inc.b a1
	dec.b d2
	bpl .loop
	lda.b d7
	and.w #$01FF
	sta.b d0
	lda.w #$0200
	sta.b d1
	jsl.l PushBits
	rtl

.t1:								; subroutine: d7 = d7 + d0, go to PushBits
	lda.b d7
	clc
	adc.b d0
	sta.b d7
	jml.l PushBits
