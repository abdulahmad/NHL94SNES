; Unpack the matchup players' photos of team x (0 home, 2 visitors) into the $7F photo buffer, unless that
; team's are already there (phototeams)
;
; Takes x = team (0 home, 2 visitors). Called from setoptions, ScoutingReport and DrawPlayerPicture.
LoadMatchupPhotos:					; unpack the matchup player photos of team x
	stx.b a2						; a2 = team offset
	lda.w HomeTeam,x				; photos of this team already unpacked (phototeams)? then nothing to do
	cmp.l phototeams,x
	bne .t1
	rtl

.t1:								; save d0 and loop over the six matchup players (x = 10 down to 0)
	lda.b d0
	pha
	ldx.w #$000A
.1:									; player x/2 of the matchup list: d0 = his roster index; remember the team
	phx
	txa
	lsr a
	jsl.l GetMatchupPlayer
	ldx.b a2
	lda.w HomeTeam,x
	sta.l phototeams,x
	ldx.w #$001A					; photo table index = (team * $1A + d0) * 4
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
	lda.w #unpackbuf>>16			; unpack the photo to unpackbuf
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	stx.b r0
	lda.b r0+1,s					; recover x (the loop counter) for the destination offset
	tax
	lda.b a2						; buffer base $2D00 for visitors, $5100 for home
	beq .t1x
	lda.w #$2D00
	bra .2

.t1x:								; a2 = 0: falls through
	lda.w #$5100
.2:									; add the photo's offset (MatchupPhotoOffsets) and convert to planar tiles
	clc
	adc.l MatchupPhotoOffsets,x
	sta.b p1
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	jsl.l LinearToPlanar
	plx								; next player
	dex
	dex
	bpl .1
	pla								; restore d0
	sta.b d0
	rtl
