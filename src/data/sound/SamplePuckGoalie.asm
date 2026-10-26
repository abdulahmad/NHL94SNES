; In-game sample 5: sound 6, the puck off the goalie (puckgoalie)

SamplePuckGoalie:					;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $0C,$8D
	db $0C,$8D
	incbin "../../../Extracted/data/sound/SamplePuckGoalie.spc":4..3217
