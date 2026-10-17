; Title sample 12: the timpani of the title set, the instrument of TitleSong's timp track (sound $16)

SampleTimpTitle:					;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $1D,$52
	db $1D,$52
	incbin "../../../Extracted/data/sound/SampleTimpTitle.spc":4..7510
