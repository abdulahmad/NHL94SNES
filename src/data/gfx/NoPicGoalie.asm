; The generic goalie photo: slot 1 (the backup goalie) of every team

NoPicGoalie:		; a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/NoPicGoalie.lin.huf":5..548
