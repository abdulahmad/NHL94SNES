; Packed rink logo tiles (12; 93S has 14), sent after FaceOffTiles by setupice as 93S RinkLogoTiles

RinkLogoTiles:						; tiles packed for DecompressHuffman sent to VRAM by screen setups
	db $30,$FB
	db $00,$01,$80
	incbin "../../../Extracted/data/gfx/RinkLogoTiles.chr.huf":5..267
