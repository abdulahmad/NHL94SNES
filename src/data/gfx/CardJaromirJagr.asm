; Player photo: Jaromir Jagr (PlayerPhotoTable PIT 9; ASE 11)

CardJaromirJagr:		; a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardJaromirJagr.lin.huf":5..477
