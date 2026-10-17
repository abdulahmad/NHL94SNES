; The big font tiles (79; a bold outlined A-Z), sent after FramerTiles by setupice as 93S BigFontTiles

BigFontTiles:						; tiles packed for DecompressLZ that screen setups send to VRAM
	db $10,$FB
	db $00,$09,$E0
	incbin "../../../Extracted/data/gfx/BigFontTiles.chr.lz":5..1000
