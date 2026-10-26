; Title / menu sample 0: the kick drum of the drums tracks (MenuSfxTable sounds 0 and 1, one pitch; confirmed
; by listening)

SampleKick:							; for SPCUploadBlock, as SampleAPower
	db $05,$46
	db $05,$46
	incbin "../../../Extracted/data/sound/SampleKick.spc":4..1354
	db $FF,$FF,$FF,$FF,$FF
