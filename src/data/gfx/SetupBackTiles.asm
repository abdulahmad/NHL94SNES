; The SetupScreen background picture tiles (a hockey action photo), drawn with SetupBackMap

SetupBackTiles:						;background tiles packed for DecompressHuffman, unpacked by a screen
									;setup; the screen is not
			;   identified yet
	db $30,$FB
	db $00,$18,$80
	incbin "../../../Extracted/data/gfx/SetupBackTiles.chr.huf":5..4346
