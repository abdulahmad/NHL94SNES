; The crowd meter colours and the rink palette

CrowdMeterPalette:					; CrowdMeterScreen loads the first 16 colours into palette 7
	incbin "../../../Extracted/data/gfx/Pals/CrowdMeterPalette.pal"
	; colours 16-127: no reader found
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
RinkPalette:						;the 128 rink colours (BG palettes 0-7): setupice copies them to palbuffer
									;and palbuffer+$100;
		; SetTeamColors then puts the team colours in palettes 2 and 3 (renders the rink map IceRinkMap)
	incbin "../../../Extracted/data/gfx/Pals/RinkPalette.pal"
