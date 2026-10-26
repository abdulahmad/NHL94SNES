; Menu sample 15: the instrument of MenuSong's apower tracks (sounds $29-$2B)

SampleAPower:						;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $0D,$9B
	db $10,$8F
	incbin "../../../Extracted/data/sound/SampleAPower.spc":4..4243
