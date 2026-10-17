; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesCGY:					; packed tiles: format word, unpacked size (big-endian), then the stream
	db $30,$FB
	db $00,$03,$40
	incbin "../../../Extracted/data/gfx/CenterIceCGY.lin.huf":5..191
	db $FF,$FF,$FF,$FF
