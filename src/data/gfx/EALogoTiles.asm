; Mode 7 tiles (185, 8bpp) of the EA SPORTS intro logo, unpacked to the high bytes of the mode 7 VRAM
; (EALogoMap)

EALogoTiles:						; packed for DecompressLZ, read by code; what it unpacks to is
	db $10,$FB
	db $00,$2E,$40
	incbin "../../../Extracted/data/gfx/EALogoTiles.lz":5..3170
