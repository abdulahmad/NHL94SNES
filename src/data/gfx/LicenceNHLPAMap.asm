; Mode 7 byte map (10 x 12) of the NHLPA logo over LicenceTiles, unpacked for the second licence zoom

LicenceNHLPAMap:					;packed for DecompressLZ: unpacked, three words (10, 12, 16) and then 10 x
									;12 bytes, a byte map. TitleScreen
			;   unpacks it to unpackbuf and later puts it over LicenceNHLMap at column 60, row 60
			;     (Mode7MapToVRAM)
	db $10,$FB
	db $00,$00,$7E
	incbin "../../../Extracted/data/gfx/LicenceNHLPAMap.lz":5..106
	db $FF,$FF,$FF,$FF,$FF
