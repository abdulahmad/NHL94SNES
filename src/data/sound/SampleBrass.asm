; Title / menu sample 8: the brass, the instrument of the HORN tracks of TitleSong and the bsec (brass
; section) tracks of MenuSong and PlayoffSong

SampleBrass:						;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $15,$45
	db $24,$90
	incbin "../../../Extracted/data/sound/SampleBrass.spc":4..9364
