; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesPIT:					; packed tiles: format word, unpacked size (big-endian), then the stream
	db $30,$FB
	db $00,$02,$C0
	incbin "../../../Extracted/data/gfx/CenterIcePIT.lin.huf":5..180
	db $00,$FF,$FF,$FF,$FF
