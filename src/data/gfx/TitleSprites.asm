; The title sprite set (DrawTitleSprite, unpacked to titlesprbuf): the N, H and L letters in three steps and
; the licence screen sprites

TitleSprites:						;a sprite set packed for DecompressHuffman: the N, H and L letters in
									;three steps each, the NHL
			;   shield, the NHLPA logo and the licence line of an opening screen
	db $30,$FB
	db $00,$29,$AF
	incbin "../../../Extracted/data/gfx/TitleSprites.spr.huf":5..5662
	db $00
