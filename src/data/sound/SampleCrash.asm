; Title / menu sample 7: the crash cymbal, the instrument of the crash tracks of TitleSong, MenuSong and
; PlayoffSong

SampleCrash:						;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $19,$CE
	db $19,$CE
	incbin "../../../Extracted/data/sound/SampleCrash.spc":4..6610
