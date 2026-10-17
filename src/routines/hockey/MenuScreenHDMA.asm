; Start the window and COLDATA HDMA (channels 2 and 3) of the stats and menu screens
MenuScreenHDMA:
	sep #$20
	lda.b #$A0
	sta.w WOBJSEL
	lda.b #$40
	sta.w WH0
org $9DE002
	lda.b #$BF
	sta.w WH1
	lda.b #$10
	sta.w CGWSEL
	lda.b #$02
	sta.w CGADSUB
	lda.b #$E5
	sta.w COLDATA
	lda.b #$44
	sta.w DMAP2
	lda.b #$9D
	sta.w A1B2
	sta.w DASB2
	ldx.w #.2
	stx.w A1T2L
	lda.b #$26
	sta.w BBAD2
	lda.b #$40
	sta.w DMAP3
	lda.b #$9D
	sta.w A1B3
	sta.w DASB3
	ldx.w #.4
	stx.w A1T3L
	lda.b #$32
	sta.w BBAD3
	lda.b #$0C
	sta.w HDMAEN
	rep #$20
	rtl
.1:									; WH0-WH3 values for .2
	db $FF,$00,$FF,$00
	db $40,$BF,$FF,$00
.2:									;indirect HDMA table: line count, then the address of the values in this
									;bank; $00 ends it
	db $10 : dw .1
	db $20 : dw .1+4
	db $14 : dw .1
	db $00
.3:									; COLDATA values for .4
	db $EF,$E7,$E3,$E0
.4:									; indirect HDMA table, as .2
	db $0C : dw .3+3
	db $06 : dw .3+2
	db $1C : dw .3+1
	db $08 : dw .3
	db $14 : dw .3+3
	db $00
