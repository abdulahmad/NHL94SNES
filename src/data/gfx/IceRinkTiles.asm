; Packed rink tiles. The game unpacks them and sends them to VRAM, and the rink map is built from them.

IceRinkTiles:						; format word, unpacked size (big-endian), then the stream
	db $10,$FB
	db $00,$4C,$A0
	incbin "../../../Extracted/data/gfx/IceRink.chr.lz":5..11230
