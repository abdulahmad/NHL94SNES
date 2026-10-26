; Title / menu sample 10: the orchestra hit, the instrument of the orch tracks of TitleSong, MenuSong and
; PlayoffSong (MenuSfxTable sound $13)

SampleOrch:							; for SPCUploadBlock, as SampleCrash
	db $17,$B2
	db $17,$B2
	incbin "../../../Extracted/data/sound/SampleOrch.spc":4..6070
