; Unpack IceRinkMap to rinkmapbuf and copy the home team's centre ice logo map (CenterIceTable+4) into its
; middle
BuildRinkMap:						; called from LoadCenterIce, ReloadRink
	lda.w #IceRinkMap>>16
	sta.b p0+2
	lda.w #IceRinkMap
	sta.b p0
	lda.w #rinkmapbuf>>16
	sta.b p1+2
	lda.w #rinkmapbuf
	sta.b p1
	jsl.l Decompress
	lda.w HomeTeam
	asl a
	asl a
	asl a
	tax
	lda.l CenterIceTable+4,x
	sta.b p0
	lda.l CenterIceTable+6,x
	sta.b p0+2
	lda.w #(rinkmapbuf+$10B6)>>16
	sta.b p1+2
	lda.w #rinkmapbuf+$10B6
	sec
	sbc.b [p0]
	sta.b p1
	lda.b [p0]
	asl a
	sta.b r3
	inc.b p0
	inc.b p0
	lda.b [p0]
	tay
	cmp.w #$0006
	bcc .1
	lda.b p1
	sec
	sbc.w #$0060
	sta.b p1
.1:									; p0 = p0 + $0004
	lda.b p0
	clc
	adc.w #$0004
	sta.b p0
.loop:								; loop: falls through
	ldx.w #$0000
.loop2:								; loop: [p1] = [p0] + centericechars + $1400, X + 1, X + 1, ...
	lda.b [p0]
	clc
	adc.l centericechars
	adc.w #$1400
	sta.b [p1]
	inx
	inx
	inc.b p0
	inc.b p0
	inc.b p1
	inc.b p1
	cpx.b r3
	bne .loop2
	lda.b p1
	clc
	adc.w #$0060
	sec
	sbc.b r3
	sta.b p1
	dey
	bne .loop
	rtl
