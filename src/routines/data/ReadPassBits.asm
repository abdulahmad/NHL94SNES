; Turn the password bits back into the playoff state
;
; Takes the password bits in passbits (SuperDiv takes the values out one by one, last written first). Sets the
; series scores, WinBits, pojoy, potreeteam, playoffRoundIdx, bosgames and postarts. A wrong checksum sets
; postarts to $FFFF (invalid password). Called from DecodePW and EncodePW.
ReadPassBits:						; password bits back into the playoff state
	lda.w #$0200					; checksum first (range 512)
	sta.b d0
	jsl.l SuperDiv					; take it from the password bits
	lda.b d0
	pha								; keep it for the end
	stz.b d7						; running sum of the values
	lda.w #$0007					; 8 series
	sta.b d2
	lda.w #$000E					; series index offset
	sta.b a1
.0:									; the 8 series scores, range 5
	ldx.b a1
	lda.l gsflags,x
	and.w #$FFFB					; clear the series over flag ($0004)
	sta.l gsflags,x
	lda.w #$0005					; range 5 wins
	sta.b d0
	jsl.l .sd						; read one value
	lda.b d0
	ldx.b a1
	sta.l gspobwins,x				; gspobwins
	cmp.w #$0004					; 4 wins: series over
	bne .nsf0
	lda.l gsflags,x
	ora.w #$0004
	sta.l gsflags,x
.nsf0:								; range 5 wins
	lda.w #$0005
	sta.b d0
	jsl.l .sd
	ldx.b a1
	lda.b d0
	sta.l gspotwins,x				; gspotwins
	cmp.w #$0004					; 4 wins: series over
	bne .nsf1
	lda.l gsflags,x
	ora.w #$0004
	sta.l gsflags,x
.nsf1:								; next series
	dec.b a1
	dec.b a1
	dec.b d2
	bpl .0
	lda.w #$4000					; range 2^14
	sta.b d0
	jsl.l .sd						; read the win bits
	lda.b d0
	sta.w WinBits					; WinBits
	lda.w #$0004					; range 4
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.l pojoy						; pojoy
	lda.w #$0010					; range 16
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.l potreeteam				; potreeteam
	lda.w #$0004					; range 4
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.l playoffRoundIdx			; playoffRoundIdx
	lda.w #$0008					; range 8
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.w bosgames					; bosgames
	lda.w #$0020					; range 32
	sta.b d0
	jsl.l .sd
	lda.b d0
	sta.l postarts					; postarts
	lda.b d7						; checksum so far, modulo 512
	and.w #$01FF
	sta.b tmp0
	pla								; the checksum from the password
	cmp.b tmp0						; compare
	beq .rtl
	lda.w #$FFFF					; bad password
	sta.l postarts					; mark it invalid
.rtl:								; return
	rtl
.sd:								;d0 = passbits mod d0, added to the checksum d7
	jsl.l SuperDiv
	lda.b d7
	clc
	adc.b d0
	sta.b d7
	rtl
