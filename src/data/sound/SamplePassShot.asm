; In-game sample 0: sounds 0 (dopass, a pass) and 1 (doshot, a shot); 94G SFXpass and SFXshotfh / SFXshotbh at
; those points

SamplePassShot:						; for SPCUploadBlock, as SampleCrash
	db $0D,$02
	db $0D,$02
	incbin "../../../Extracted/data/sound/SamplePassShot.spc":4..3334
	db $FF
