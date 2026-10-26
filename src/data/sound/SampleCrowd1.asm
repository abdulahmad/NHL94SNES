; In-game sample 17: crowd noise, a looping sample (sound $12, queued with $13 at the faceoff and on leaving
; the pause; confirmed by listening)

SampleCrowd1:						; for SPCUploadBlock, as SampleCrash
	db $00,$1B
	db $16,$02
	incbin "../../../Extracted/data/sound/SampleCrowd1.spc":4..5638
