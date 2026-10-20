; Set both teams' colours (SetTeamColors) and send the whole palette (palbuffer) to CGRAM
;
; Takes nothing, returns nothing. Called from SaveRegsStartHL2, ReloadRink and setupice.
setplayercolors:					; set the team colours and send the whole palette to CGRAM
	jsl.l SetTeamColors				; build the uniform palettes in palbuffer
	lda.w #palbuffer>>16			; p0 = palbuffer
	sta.b p0+2
	lda.w #palbuffer
	sta.b p0
	ldy.w #$0000					; from colour 0
	ldx.w #$0100					; all 256 colours
	jsl.l DMAToCGRAM				; palette to CGRAM
	rtl

; Set both teams' uniform colours in palbuffer (HomeUniformPalettes / AwayUniformPalettes) and the shared
; colours
;
; Takes nothing, returns nothing. Called from setplayercolors. Each uniform palette is 16 colours ($20 bytes),
; indexed by team number.
SetTeamColors:						; copy both teams' colours into palbuffer
	phx
	phy
	lda.w HomeTeam					; home team * $20: offset into HomeUniformPalettes
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #HomeUniformPalettes		; p0 = home uniform palette
	sta.b p0
	lda.w #HomeUniformPalettes>>16
	sta.b p0+2
	lda.w #palbuffer>>16			; p1 = palbuffer + $180
	sta.b p1+2
	lda.w #palbuffer+$180
	sta.b p1
	ldx.w #$0020
	jsl.l MemCopy					; copy 16 colours
	lda.w #palbuffer>>16			; and again to palbuffer + $040
	sta.b p1+2
	lda.w #palbuffer+$040
	sta.b p1
	ldx.w #$0020
	jsl.l MemCopy					; copy 16 colours
	lda.w VisTeam					; visiting team * $20: offset into AwayUniformPalettes
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #AwayUniformPalettes		; p0 = away uniform palette
	sta.b p0
	lda.w #AwayUniformPalettes>>16
	sta.b p0+2
	lda.w #palbuffer>>16			; p1 = palbuffer + $1A0
	sta.b p1+2
	lda.w #palbuffer+$1A0
	sta.b p1
	ldx.w #$0020
	jsl.l MemCopy					; copy 16 colours
	lda.w #palbuffer>>16			; and again to palbuffer + $060
	sta.b p1+2
	lda.w #palbuffer+$060
	sta.b p1
	ldx.w #$0020
	jsl.l MemCopy					; copy 16 colours
	lda.w #PlayerMarkerPalette>>16	; p0 = PlayerMarkerPalette
	sta.b p0+2
	lda.w #PlayerMarkerPalette
	sta.b p0
	lda.w #palbuffer>>16			; p1 = palbuffer + $140
	sta.b p1+2
	lda.w #palbuffer+$140
	sta.b p1
	ldx.w #$0020
	jsl.l MemCopy					; copy 16 colours
	ply								; restore Y and X
	plx
	rtl
