; Takes: listend. Called by ShowPlayerStats and SwapPlayerStatsTeam.
; Fill the stats row order with 0, 1, 2 ...
InitStatsOrder:						; statsorder[i] = i for the rows of the list
	lda.w #$0000					; first number
	ldy.w #$FFFF					; Y = -1
.loop:								; next row
	iny
	sep #$20
	sta.w statsorder,y				; store the byte
	rep #$20
	inc a
	cpy.w listend
	bcc .loop						; until Y reaches listend
	rtl
