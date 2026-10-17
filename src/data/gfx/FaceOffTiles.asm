; Packed faceoff box tiles (55): setupice sends them as 93S setupice sends FaceOffTiles

FaceOffTiles:						; tiles packed for DecompressLZ that screen setups send to VRAM
	db $10,$FB
	db $00,$06,$E0
	incbin "../../../Extracted/data/gfx/FaceOffTiles.chr.lz":5..1022
