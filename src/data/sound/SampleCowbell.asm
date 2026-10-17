; Title / menu sample 11: the cowbell, the instrument of TitleSong's cowbell track and MenuSong's crshbkwd/cow
; track (sound $15, $23)

SampleCowbell:						;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $06,$42
	db $06,$42
	incbin "../../../Extracted/data/sound/SampleCowbell.spc":4..1606
