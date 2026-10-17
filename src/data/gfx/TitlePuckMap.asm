; Mode 7 byte map (12 x 12) of the title puck; TitleScreen ORs $80 into it for TitlePuckTiles at tile 128

TitlePuckMap:						;a 12 x 12 map of bytes (width, height, , then a byte per entry) packed
									;for
			;   DecompressRLE, read by a screen setup in bank $9D
	incbin "../../../Extracted/data/gfx/TitlePuckMap.map.rle":0..121
