; A song MusicStart plays from the TeamSongs table: a header (the second byte is the tempo),
; the offsets of its tracks, then each track in a TRAK chunk (size byte, tag, track name,
; then the note stream the music player reads).
; 94G songs $48, $4B at the same TeamSongs slots: DAL 1, DAL 2, NYI 1.
; Title (the forum list of the 94G songs): Charge (94G: B-flat only, and C).

SongCharge:							; header, track offsets (a zero ends them), padding, then the tracks
	db $01,$78,$01,$00,$00,$00,$02,$00
	dw .left-SongCharge,.right-SongCharge,$0000
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $AA,"TRAK"
.left:
	db $00,$E7,$05,"left",$00
	db $00,$DC,$0B,$00,$96,$6E,$17,$29,$91,$6E,$15,$25,$93,$6E,$18,$22
	db $95,$6E,$15,$20,$96,$6E,$15,$21,$91,$6E,$13,$20,$93,$6E,$12,$1E
	db $95,$6E,$11,$1C,$96,$6E,$0F,$1C,$91,$6E,$0A,$1A,$93,$6E,$0A,$18
	db $95,$6E,$0B,$18,$96,$6E,$0A,$17,$91,$6E,$09,$15,$93,$6E,$0B,$14
	db $95,$6E,$0A,$14,$96,$6E,$0A,$13,$91,$6E,$09,$11,$93,$6E,$0A,$11
	db $95,$6E,$08,$0F,$96,$6E,$08,$0F,$91,$6E,$08,$0E,$93,$6E,$07,$0D
	db $95,$6E,$07,$0E,$96,$6E,$06,$0E,$91,$6E,$07,$0D,$93,$6E,$07,$0C
	db $95,$6E,$08,$0C,$96,$6E,$0B,$29,$A9,$6E,$09,$0E,$AE,$6E,$09,$0C
	db $B2,$6E,$09,$0D,$B5,$6E,$0C,$19,$B2,$6E,$0C,$0D,$B5,$6E,$45,$46
	db $D9,$00,$00,$00,$00,$00,$00,$00,$00,$79,$00,$00,$00
	db $AA,"TRAK"
.right:
	db $00,$E7,$06,"right",$00
	db $00,$DC,$0C,$00,$8A,$6E,$16,$29,$85,$6E,$17,$25,$87,$6E,$19,$22
	db $89,$6E,$13,$21,$8A,$6E,$13,$21,$85,$6E,$11,$1F,$87,$6E,$12,$1E
	db $89,$6E,$0F,$1C,$8A,$6E,$0E,$1C,$85,$6E,$0A,$1B,$87,$6E,$0B,$18
	db $89,$6E,$09,$17,$8A,$6E,$0B,$17,$85,$6E,$0A,$15,$87,$6E,$0A,$14
	db $89,$6E,$0A,$14,$8A,$6E,$0A,$13,$85,$6E,$09,$11,$87,$6E,$09,$10
	db $89,$6E,$09,$10,$8A,$6E,$08,$0F,$85,$6E,$08,$0F,$87,$6E,$07,$0C
	db $89,$6E,$07,$0E,$8A,$6E,$06,$0E,$85,$6E,$07,$0D,$87,$6E,$07,$0C
	db $89,$6E,$09,$0C,$8A,$6E,$0B,$29,$A9,$6E,$09,$0E,$AE,$6E,$09,$0C
	db $B2,$6E,$09,$0D,$B5,$6E,$0C,$19,$B2,$6E,$0C,$0D,$B5,$6E,$45,$46
	db $D9,$00,$00,$00,$00,$00,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
