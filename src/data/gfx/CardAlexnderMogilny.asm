; Player photo: Alexnder Mogilny (PlayerPhotoTable BUF 12; ASE 15)

CardAlexnderMogilny:		; a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardAlexnderMogilny.lin.huf":5..552
