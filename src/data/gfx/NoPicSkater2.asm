; A generic skater photo, used for the skaters without their own

NoPicSkater2:		; a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/NoPicSkater2.lin.huf":5..418
