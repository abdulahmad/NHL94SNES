; The crowd meter bar, unlit (18 x 3), drawn when the level fits in the 18 columns

CrowdMeterMap:						;an 18 x 3 map packed for DecompressRLE (width,
									;height, , then the map words)
			;   read in bank $9B
	incbin "../../../Extracted/data/gfx/CrowdMeterMap.map.rle":0..45
