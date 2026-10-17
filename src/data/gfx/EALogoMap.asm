; Mode 7 byte map (128 x 128) of the EA SPORTS intro: SPORTS and ELECTRONIC ARTS over EALogoTiles

EALogoMap:							;a 128 x 128 map of bytes (width, height, , then a byte per entry) packed
									;for
			;   DecompressHuffman, copied to VRAM by a routine in bank $9F
	db $30,$FB
	db $00,$40,$06
	incbin "../../../Extracted/data/gfx/EALogoMap.map.huf":5..166
