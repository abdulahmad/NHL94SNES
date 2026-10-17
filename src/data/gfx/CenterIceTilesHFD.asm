; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesHFD:					; packed tiles: format word, unpacked size (big-endian), then the stream
	db $30,$FB
	db $00,$03,$A0
	incbin "../../../Extracted/data/gfx/CenterIceHFD.lin.huf":5..334
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
