; Mode 7 tiles (75, 8bpp) of the title puck, sent from mode 7 tile 128 (TitlePuckMap)

TitlePuckTiles:						; tiles packed for DecompressLZ that a screen setup sends to VRAM
	db $10,$FB
	db $00,$12,$C0
	incbin "../../../Extracted/data/gfx/TitlePuckTiles.chr.lz":5..1151
