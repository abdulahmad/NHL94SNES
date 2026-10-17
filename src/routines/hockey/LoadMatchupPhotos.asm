; Unpack the matchup players' photos of team x (0 home, 2 visitors) into the $7F photo buffer, unless that
; team's are already there ($7E346C)
LoadMatchupPhotos:
	stx.b a2
	lda.w HomeTeam,x
	cmp.l phototeams,x
	bne .t1
	rtl

.t1:
	lda.b d0
	pha
	ldx.w #$000A
.1:
	phx
	txa
	lsr a
	jsl.l GetMatchupPlayer
	ldx.b a2
	lda.w HomeTeam,x
	sta.l phototeams,x
	ldx.w #$001A
	jsl.l Mul8U
	clc
	adc.b d0
	asl a
	asl a
	tax
	lda.l PlayerPhotoTable,x
	sta.b p0
	lda.l PlayerPhotoTable+2,x
	sta.b p0+2
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	stx.b r0
	lda.b r0+1,s
	tax
	lda.b a2
	beq .t1x
	lda.w #$2D00
	bra .2

.t1x:
	lda.w #$5100
.2:
	clc
	adc.l MatchupPhotoOffsets,x
	sta.b p1
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	jsl.l LinearToPlanar
	plx
	dex
	dex
	bpl .1
	pla
	sta.b d0
	rtl
