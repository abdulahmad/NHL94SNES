; The Stanley Cup map (6 x 13) of the playoff tree screen; PlayoffScreen pastes it in palette 3 over
; StanleyCupTiles

StanleyCupMap:						;a map packed for DecompressHuffman: width 6, height 13 and a word, then
									;the map words; read
	db $30,$FB
	db $00,$00,$A2
	incbin "../../../Extracted/data/gfx/StanleyCupMap.map.huf":5..101
