; The overall rating of player d0 of team a2 from the attribute mask $B7, with the hot / cold table when
; $7E35F2 is set
; Takes: d0 = roster index of the player, a2 = team, d4+2 = mask of the attributes to include (bit 15 set
; = a weighted overall rating, otherwise one attribute), r2 = 0 for skaters, nonzero (16) for goalies
; (probably). Returns d0 = rating 0-100. Called from GetNameandAttrib, GetPlayerBaseRating, GetPlayerRating.
CalcAttrib:							; overall rating of a player from his attributes and hot / cold values
	lda.b d0						; r0 = player index * 12: his row in HotColdTable
	asl a
	adc.b d0
	asl a
	asl a
	sta.b r0
	stz.b d0+2						; clear the bank part of the count
	ldy.b a2						; visitors?
	beq .1
	lda.b r0						; second team: skip the 26 rows of the first
	clc
	adc.w #$0138
	sta.b r0
.1:									; team row offset set
	lda.w #$009C					; a0 = team data in the player bank
	sta.b a0+2
	lda.w tmdata,y					; team data pointer
	sta.b a0
	clc
	ldy.w #$0000					; add the offset of the player table
	adc.b [a0],y
	sta.b a0
	dec.b d0						; skip to the player: d0 more players
	bmi .2							; player index was 0: already there
.loop:								; each player: name length word, the name, 8 bytes of attributes
	lda.b a0
	clc
	adc.b [a0]
	adc.w #$0008
	sta.b a0
	dec.b d0
	bpl .loop
.2:									; a0 = end of the attributes of the player
	lda.b [a0]
	clc
	adc.b a0
	sta.b a0
	stz.b d0						; d0 = sum of weighted attributes, d1 = sum of hot / cold
	stz.b d1
	phx								; keep X
	lda.w #$0000					; start with bit 0 of the mask
.11:								; each attribute bit in turn
	sta.b d2
	asl a
	tax
	lda.l BitMaskTable,x			; mask bit for this attribute
	bit.b d4+2						; attribute selected in the mask?
	bne .t2
	jmp.w .12						; not selected: next

.t2:								; selected
	cpx.w #$000C					; attributes $0C and $1A (the 6th and the 13th) count in d0+2
	beq .1x
	cpx.w #$001A
	bne .2x
.1x:								; count the attribute
	inc.b d0+2						; count them; a nonzero count keeps the rating unclamped at the end
.2x:								; find the attribute nibble
	lda.w #$000F					; p1 = 15 - attribute number
	sec
	sbc.b d2
	sta.b p1						; nibble address: a0 - p1/2
	lsr a
	clc
	adc.b a0
	sta.b p0
	lda.b a0+2
	sta.b p0+2
	lda.b [p0]						; byte holding the attribute
	sta.b d3
	lda.b d2						; odd attribute numbers use the high nibble
	lsr a
	bcc .3
	lda.b d3						; the upper nibble
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d3
.3:									; the attribute value 0-15
	lda.b d3
	and.w #$000F
	sta.b d3
	lda.b p1						; p1 - 3, minus 1 more from 6 on: the column in the row
	dec a
	dec a
	dec a
	cmp.w #$0006					; index into HotColdTable
	bcc .4
	dec a
.4:									; row offset chosen
	clc
	adc.b r0
	tax								; X = row + column
	lda.l usehotcold				; hot / cold switched on?
	beq .5							; off: use 0 (r3+2 = 0 as it stands)
	lda.w HotColdTable,x			; hot / cold byte of the attribute
	and.w #$00FF
.5:									; hot / cold byte in r3+2
	sta.b r3+2						; keep the signed byte
	cmp.w #$0080					; $80 or more is negative
	bcc .6
	lda.w #$0100					; magnitude = $100 - byte
	sbc.b r3+2
.6:									; magnitude in r3
	sta.b r3						; r3 = magnitude * 3/4 (arithmetic shift, sign extended)
	asl a
	clc
	adc.b r3
	lsr a
	lsr a
	bit.w #$2000					; sign extend from 14 bits
	beq .7
	ora.w #$C000
.7:									; hot / cold value done
	sta.b r3
	lda.b r3+2						; original byte
	bit.w #$0080					; negative: negate r3
	beq .8
	lda.w #$0000
	sec
	sbc.b r3
	sta.b r3
.8:									; hot / cold value signed
	lda.b d4+2						; weighted mode (bit 15 set)?
	bmi .t3
	ldx.b p1						; single attribute mode
	lda.l .19,x						; weight of this attribute in the single mode table
	and.w #$00FF
	beq .t1							; zero: use the attribute alone
	lda.w #$0012					; attribute * 18 plus the hot / cold value
	ldx.b d3
	jsl.l Mul8U						; multiply
	clc
	adc.b r3
	bpl .9							; not below zero
	lda.w #$0000
.9:									; rating not below zero
	cmp.w #$0064					; clamp at 100
	bcc .10
	lda.w #$0064
.10:								; rating not above 100
	sta.b d0						; d0 = the one rating
	plx								; restore X
	jmp.w .17						; finish

.t1:								; attribute alone
	lda.b d3
	sta.b d0
	plx								; restore X
	jmp.w .17						; finish

.t3:								; weighted mode
	lda.b p1						; weight table: skater rows 0-15, goalie rows 16-31
	clc
	adc.b r2
	tax
	lda.l .18,x						; weight of this attribute
	ldx.b d3
	jsl.l Mul8U						; multiply by the attribute
	clc
	adc.b d0						; add to the sum d0
	sta.b d0
	lda.b r3						; hot / cold value
	ldy.b r2
	beq .1xx						; goalies count it twice
	asl a
.1xx:								; row sum doubled for goalies
	clc								; add to the sum d1
	adc.b d1
	sta.b d1
.12:								; next attribute bit
	lda.b d2
	inc a
	cmp.w #$000F
	bpl .t2x						; all 15 bits done
	jmp.w .11						; next

.t2x:								; hot / cold sum is positive?
	lda.b d1
	bpl .14							; negative: take its magnitude
	eor.w #$FFFF
	inc a
	ldx.b r2						; divide by 10 (skater) or 7 (goalie)
	bne .t1x
	tax
	lda.w #$000A
	bra .13

.t1x:								; goalie divisor
	tax
	lda.w #$0007					; goalie: 7
.13:								; divisor in A
	jsl.l DivX8U					; divide
	sec								; subtract from d0
	eor.w #$FFFF
	adc.b d0
	sta.b d0
	lda.b d0
	bpl .16							; not below zero
	stz.b d0
	lda.w #$0000
	bra .16
.14:								; positive hot / cold sum
	ldx.b r2						; divide by 10 (skater) or 7 (goalie)
	bne .t1xx
	tax
	lda.w #$000A
	bra .15

.t1xx:								; goalie divisor
	tax
	lda.w #$0007
.15:								; goalie: 7
	jsl.l DivX8U					; divide
	clc								; add to d0
	adc.b d0
	sta.b d0
	lda.b d0
	bpl .16							; not below zero
	stz.b d0
	lda.w #$0000
.16:								; d0 = rating
	sta.b d0
	plx								; restore X
	lda.b r2						; goalie?
	beq .17
	lsr.b d0						; goalies: halve the sum
.17:								; rating computed
	lda.b d0+2						; counted attributes $0C / $1A? then keep it as it is
	bne .rtl
	lda.b d0
	cmp.w #$0064					; clamp at 100
	bcc .1xxx
	lda.w #$0064
.1xxx:								; rating limited
	cmp.w #$0032					; under 50: compress (d0 / 2 + 25)
	bcs .2xx
	lsr a
	clc
	adc.w #$0019
.2xx:								; rating compressed
	sta.b d0						; return the rating
.rtl:								; return
	rtl								; return
.18:								; weights of the skater attributes (first 16 bytes), then goalie weights
	db $00,$00,$01,$02,$03,$03,$02,$01,$02,$01,$03,$02,$01,$01,$01,$01
	db $00,$00,$00,$09,$02,$02,$09,$09,$02,$02,$02,$02,$02,$02,$02,$02
.19:								; weights for the single attribute mode
	db $00,$00,$00,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01,$01,$01,$01
