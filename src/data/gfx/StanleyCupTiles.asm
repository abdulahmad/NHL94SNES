; The Stanley Cup tiles (58) of the playoff tree screen, drawn with StanleyCupMap in palette 3

StanleyCupTiles:					; packed for DecompressLZ, read by a screen setup
	db $10,$FB
	db $00,$07,$40
	incbin "../../../Extracted/data/gfx/StanleyCupTiles.lz":5..1422
