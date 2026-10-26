; Title / menu sample 3: the crash played backwards, the instrument of the crshbkwd tracks of MenuSong and
; PlayoffSong (sound 4)

SampleCrashBack:					;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $0A,$B9
	db $0A,$B9
	incbin "../../../Extracted/data/sound/SampleCrashBack.spc":4..2749
