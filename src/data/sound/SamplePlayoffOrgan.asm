; Menu sample 14: the organ of PlayoffSong's orgn tracks (sounds $1F, $2F)

SamplePlayoffOrgan:					;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $00,$09
	db $00,$1B
	incbin "../../../Extracted/data/sound/SamplePlayoffOrgan.spc":4..31
