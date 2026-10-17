; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesVAN:					; packed tiles: format word, unpacked size (big-endian), then the stream
	db $30,$FB
	db $00,$03,$20
	incbin "../../../Extracted/data/gfx/CenterIceVAN.lin.huf":5..387
	db $FF,$FF,$FF,$FF,$FF
