; Mode 7 byte map (10 x 12) of the NHL shield over LicenceTiles; TitleScreen puts it at column 60, row 60 (the first zoom)

LicenceNHLMap:		; three words (10, 12, 16), then a 10 x 12 byte map, one row per line; TitleScreen copies it
			;   to the mode 7 map (Mode7MapToVRAM), then LicenceNHLPAMap (bank $87) over it
	dw 10,12,16
	db $00,$01,$02,$03,$04,$05,$06,$07,$08,$00
	db $0D,$0E,$0F,$10,$11,$12,$13,$14,$15,$00
	db $1B,$1C,$1D,$1E,$1F,$20,$21,$21,$22,$23
	db $28,$29,$2A,$2B,$2C,$2D,$2E,$21,$2F,$30
	db $35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E
	db $43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C
	db $51,$21,$52,$53,$54,$55,$49,$56,$21,$57
	db $5D,$21,$21,$21,$5E,$5F,$60,$56,$21,$61
	db $69,$6A,$21,$21,$21,$6B,$6C,$6D,$6E,$6F
	db $78,$79,$7A,$21,$21,$21,$21,$7B,$7C,$7D
	db $00,$00,$87,$88,$89,$8A,$8B,$8C,$8D,$8E
	db $00,$00,$00,$00,$8F,$90,$00,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
