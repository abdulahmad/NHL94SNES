; The crowd meter bar tiles (linear 4bpp), drawn by ShowCrowdMeter with the CrowdMeter maps in palette 7

CrowdMeterTiles:					; linear 4bpp tiles packed for DecompressLZ, converted by 
	db $10,$FB
	db $00,$08,$A0
	incbin "../../../Extracted/data/gfx/CrowdMeterTiles.lin.lz":5..866
