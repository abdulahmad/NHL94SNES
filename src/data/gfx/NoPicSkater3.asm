; A generic skater photo, used for the skaters without their own

NoPicSkater3:		; a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman; the photo table points
			;   here for most players without a photo of their own
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/NoPicSkater3.lin.huf":5..379
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
