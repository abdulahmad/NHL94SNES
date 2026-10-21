; The EA intro sprite set (two frames, the large E and A letters), unpacked to introbuf+$A40 and drawn by
; IntroSequence

EALogoSprites:						;a sprite set packed for DecompressHuffman: two frames, large E and A
									;letters (the EA logo, by its look)
	db $30,$FB
	db $00,$0D,$D0
	incbin "../../../Extracted/data/gfx/EALogoSprites.spr.huf":5..1805
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF
