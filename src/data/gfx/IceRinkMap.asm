; Graphics.

IceRinkMap:							;the rink map packed for DecompressLZ: three words (width 48, height 113,
									;the format word $0308
			;   no code reads), then the map words
			;   for IceRinkTiles
	db $10,$FB
	db $00,$2A,$66
	incbin "../../../Extracted/data/gfx/IceRink.map.lz":5..4407
