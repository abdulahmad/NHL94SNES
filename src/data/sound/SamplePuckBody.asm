; In-game sample 7: sound 8, the puck off a body (puckbody; 94G SFXpuckbody)

SamplePuckBody:						;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $02,$F4
	db $02,$F4
	incbin "../../../Extracted/data/sound/SamplePuckBody.spc":4..760
