; A sprite set of letters.

LetterSprites:						;the letters A to Z as a DrawSprite sprite set, not packed: frame offsets,
									;then the frames;
			;   a text routine in bank $9C draws words with it, one frame per letter
	incbin "../../../Extracted/data/gfx/LetterSprites.spr":0..5032
