; Start the window and COLDATA HDMA (channels 2 and 3) of the scouting report screen
ScoutingHDMA:
	sep #$20
	lda.b #$A0
	sta.w WOBJSEL
	lda.b #$0C
	sta.w WH0
	lda.b #$B3
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
.1:									; WH0-WH3 values (window 1 left, right, window 2 left, right) for .2
	db $FF,$00,$FF,$00
	db $0C,$B3,$FF,$00
.2:									;indirect HDMA table: line count, then the address of the values in this
									;bank; $00 ends it
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
