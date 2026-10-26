; Streamed sound 4 (a goalie save in puckgoalie, and an injury in setInjuryType): a block that UpdateStreamSfx
; streams in

StreamSampleSave:					;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $20,$E8
	db $20,$E8
	incbin "../../../Extracted/data/sound/StreamSampleSave.spc":4..8428
