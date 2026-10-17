; The crowd meter bar with cracked glass (18 x 3), drawn when the level is past the 18 columns (the broken
; meter)

CrowdMeterBrokenMap:				;an 18 x 3 map packed for DecompressHuffman (width, height, , then the map
									;words)
			;   read in bank $9B
	db $30,$FB
	db $00,$00,$72
	incbin "../../../Extracted/data/gfx/CrowdMeterBrokenMap.map.huf":5..92
