; A sprite set of letters.

SmallLetterSprites:					;the letters A to Z, the digits 0 to 9 and a full stop as a DrawSprite
									;sprite set, not packed;
			;   a text routine in bank $9C draws words with it, one frame per character
	incbin "../../../Extracted/data/gfx/SmallLetterSprites.spr":0..2405
