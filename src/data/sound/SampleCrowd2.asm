; In-game sample 11: crowd noise, a looping sample (sounds $13 and $1C, queued with $12 at the faceoff and on
; leaving the pause; confirmed by listening)

SampleCrowd2:						;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $00,$12
	db $13,$EF
	incbin "../../../Extracted/data/sound/SampleCrowd2.spc":4..5107
