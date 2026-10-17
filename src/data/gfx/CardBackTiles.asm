; The player card screen frame tiles (linear 4bpp), drawn with CardBackMap

CardBackTiles:						;linear 4bpp background tiles packed for
									;DecompressPairs: a screen with EA SPORTS
	db $46,$FB
	db $00,$2C,$E0
	incbin "../../../Extracted/data/gfx/CardBackTiles.lin.pairs":5..4084
