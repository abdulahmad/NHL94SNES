; In-game sample 9: the puck off the glass (sound $A, which wallcoll plays instead of SamplePuckWall when the
; puck is high; confirmed by listening)

SamplePuckGlass:					; for SPCUploadBlock, as SamplePuckGoalie
	db $0B,$E2
	db $0B,$E2
	incbin "../../../Extracted/data/sound/SamplePuckGlass.spc":4..3046
