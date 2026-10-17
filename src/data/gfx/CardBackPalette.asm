; The player card screen frame colours, loaded into palette 4 for CardBackMap

CardBackPalette:		; packed for DecompressLZ: unpacked, BGR555 colours. A screen setup in bank $9D unpacks it and loads
			;   its first 16 colours into colours $40-$4F
	db $10,$FB
	db $00,$01,$00
	incbin "../../../Extracted/data/gfx/Pals/CardBackPalette.pal.lz":5..45
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
