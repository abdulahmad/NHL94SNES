; Packed ref window tiles for the vertical rink (117), as 93S RefTiles

RefTiles:							; tiles packed for DecompressLZ that screen setups send to VRAM
	db $10,$FB
	db $00,$0E,$A0
	incbin "../../../Extracted/data/gfx/RefTiles.chr.lz":5..2272
