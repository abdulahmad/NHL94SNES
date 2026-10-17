; The 7 x 7 picture box map that LoadPictureMap unpacks for DrawMatchupPictures

PictureMap:							;a 7 x 7 map packed for DecompressLZ (width, height, , then the map words)
			;   read by a screen setup in bank $9D
	db $10,$FB
	db $00,$00,$68
	incbin "../../../Extracted/data/gfx/PictureMap.map.lz":5..37
