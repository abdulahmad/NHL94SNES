; The title logo pieces with the (R) mark (TitleScreen)

TitleLogoTiles:						;tiles packed for DecompressLZ, unpacked by a screen setup:
									;logo pieces with a (R) mark
	db $10,$FB
	db $00,$16,$E0
	incbin "../../../Extracted/data/gfx/TitleLogoTiles.chr.lz":5..3439
