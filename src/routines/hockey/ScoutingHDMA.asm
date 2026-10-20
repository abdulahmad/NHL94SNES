; Start the window and COLDATA HDMA (channels 2 and 3) of the scouting report screen
ScoutingHDMA:						; Scouting screen windows and colour tint; takes nothing, returns nothing
	sep #$20						; 8-bit A for the PPU registers
	lda.b #$A0
	sta.w WOBJSEL					; OBJ and colour windows use windows 1 and 2
	lda.b #$0C
	sta.w WH0						; window 1 left edge
	lda.b #$B3
	sta.w WH1						; window 1 right edge
	lda.b #$10
	sta.w CGWSEL					; colour window: outside the windows
	lda.b #$02
	sta.w CGADSUB					; colour math: add the fixed colour
	lda.b #$E5
	sta.w COLDATA					; fixed colour (blue $E5)
	lda.b #$44
	sta.w DMAP2						; channel 2: indirect HDMA, two registers written (WH0-WH3)
	lda.b #$9D
	sta.w A1B2						; table bank
	sta.w DASB2
	ldx.w #.2						; table address
	stx.w A1T2L
	lda.b #$26
	sta.w BBAD2						; destination WH0
	lda.b #$40
	sta.w DMAP3						; channel 3: indirect HDMA, one register (COLDATA)
	lda.b #$9D
	sta.w A1B3						; table bank
	sta.w DASB3
	ldx.w #.4						; table address
	stx.w A1T3L
	lda.b #$32
	sta.w BBAD3						; destination COLDATA
	lda.b #$0C
	sta.w HDMAEN					; enable HDMA channels 2 and 3
	rep #$20						; back to 16-bit A
	rtl
.1:									; WH0-WH3 values (window 1 left, right, window 2 left, right) for .2
	db $FF,$00,$FF,$00
	db $0C,$B3,$FF,$00
.2:									; indirect HDMA table: line count, then the address of the values in this
									; bank; $00 ends it
	db $68 : dw .1
	db $58 : dw .1+4
	db $14 : dw .1
	db $00
.3:									; COLDATA values for .4
	db $E7,$E0
.4:									; indirect HDMA table, as .2
	db $6E : dw .3+1
	db $4C : dw .3
	db $14 : dw .3+1
	db $00
