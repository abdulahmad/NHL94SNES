; Packed ref window tiles for the horizontal rink (104), as 93S RefTilesHor

RefTilesHor:						; tiles packed for DecompressLZ that screen setups send to VRAM
	db $10,$FB
	db $00,$0D,$00
	incbin "../../../Extracted/data/gfx/RefTilesHor.chr.lz":5..1887
