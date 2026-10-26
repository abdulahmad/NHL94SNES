; The EA SPORTS voice of the intro, the only sample of IntroSampleList (identified by listening)

SampleEASportsVoice:				;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $3B,$22
	db $3B,$22
	incbin "../../../Extracted/data/sound/SampleEASportsVoice.spc":4..15142
