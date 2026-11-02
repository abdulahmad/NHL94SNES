; Build the player stats page in the stats page buffer, a row per player in the sorted order
FillPlayerStatsPage:				; called from SortPlayerStats
	lda.w #statspage>>16
	sta.b p1+2
	lda.w #statspage
	sta.b p1
	ldx.w #$4D80					;whole page
	lda.l smallfontchars			;blank tile
	clc
	adc.l printfontset				;of the print font
	jsl.l MemFill					; fill X bytes at [p1] with the word A
	ldy.w listtop					;first row shown
	tya
	dec a							;minus 1
	asl a							;2 text rows each
	sta.w printy					;row before the first
.1:									; increment printy, increment printy, if statcolumn = 0 go to .t1, ...
	inc.w printy					;2 rows
	inc.w printy					;per player
	sep #$20
	lda.w statsorder,y				;next in the sorted order
	rep #$20
	and.w #$00FF
	tax								;player
	lda.w statcolumn				;stat columns of skaters?
	beq .t1							;no: goalie columns
	jsl.l .3						;skater row
	bra .2

.t1:								; statcolumn = 0: call .4
	jsl.l .4
.2:									;next
	iny
	cpy.w listend					;last?
	beq .1
	bcc .1							;not yet
	rtl
.3:									;.3: skater row for player X: name, G, A, Pts, shots, PIM
	phy
	lda.b d1						;save d1
	pha
	lda.w #$FFFF					;normal palette
	jsl.l SetStatColumnPal
	lda.w #$0003					;column 3
	sta.w printx
	stx.b d0						;player
	jsl.l PlayerInitialName			;name
	jsl.l PrintToStatsPage			;print it
	stx.w statstemp					;player
	lda.b a2						;team
	beq .2x							;home: no offset
.1x:								; falls through
	lda.w #$001A					;visitors: $1A players on
.2x:								;plus the player
	clc
	adc.w statstemp					;stats index
	tax
	lda.w #$0001					;column 1 highlight
	jsl.l SetStatColumnPal
	lda.w #$0011					;column 17
	sta.w printx
	sep #$20
	lda.w tmgoals,x					;goals
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0002					;2 digits
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l PrintToStatsPage			;print
	lda.w #$0002					;column 2
	jsl.l SetStatColumnPal
	lda.w #$0014					;column 20
	sta.w printx
	sep #$20
	lda.w tmassists,x				;assists
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0002					;2 digits
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l PrintToStatsPage			;print
	lda.w #$0003					;column 3
	jsl.l SetStatColumnPal
	lda.w #$0017					;column 23
	sta.w printx
	sep #$20
	lda.w tmgoals,x					;goals
	rep #$20
	and.w #$00FF
	sta.b d0
	sep #$20
	lda.w tmassists,x				;plus assists
	rep #$20
	and.w #$00FF
	clc
	adc.b d0						;points
	sta.b d0
	lda.w #$0002					;2 digits
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l PrintToStatsPage			;print
	lda.w #$0004					;column 4
	jsl.l SetStatColumnPal
	lda.w #$001A					;column 26
	sta.w printx
	sep #$20
	lda.w tmpshots,x				;shots
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0002					;2 digits
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l PrintToStatsPage			;print
	lda.w #$0005					;column 5
	jsl.l SetStatColumnPal
	lda.w #$001D					;column 29
	sta.w printx
	sep #$20
	lda.w ppenmin,x					;penalty minutes
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0002					;2 digits
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l PrintToStatsPage			;print
	lda.w #$FFFF					;normal palette again
	jsl.l SetStatColumnPal
	pla								;restore d1
	sta.b d1
	ply
	rtl
.4:									;.4: goalie row for player X: name, goals against, shots against, save %
	phy
	lda.b d1						;save d1
	pha
	lda.w #$FFFF					;normal palette
	jsl.l SetStatColumnPal
	lda.w #$0003					;column 3
	sta.w printx
	stx.b d0						;player
	jsl.l PlayerInitialName			;name
	jsl.l PrintToStatsPage			;print it
	stx.w statstemp
	lda.b a2						;team
	beq .1xx						;home: no offset
	lda.w #$001A					;visitors: $1A players on
.1xx:								; adc statstemp, printx = $0012, d0 = tmgoals,x & $00FF, ...
	clc
	adc.w statstemp					;plus the player
	tax
	lda.w #$0012					;column 18
	sta.w printx
	sep #$20
	lda.w tmgoals,x					;goals against
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l PrintToStatsPage			;print
	lda.w #$0016					;column 22
	sta.w printx
	sep #$20
	lda.w tmpshots,x				;shots against
	rep #$20
	and.w #$00FF
	sta.b d0
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l PrintToStatsPage			;print
	lda.w #$001B					;column 27
	sta.w printx
	sep #$20
	lda.w tmgoals,x					;goals against
	rep #$20
	and.w #$00FF
	phx
	ldx.w #$0064					;100
	jsl.l Mul8XS					;x100
	sta.b r2						;dividend
	plx
	sep #$20
	lda.w tmpshots,x				;shots against
	rep #$20
	and.w #$00FF
	sta.b r1						;divisor
	cmp.w #$0000
	beq .t1x						;none: 0% saved
	jsl.l Div16U					;goals * 100 / shots
	lda.b r0						;quotient
	sta.b d0						;percent scored on
	bra .2xx

.t1x:								; d0 = $0064
	lda.w #$0064					;100
	sta.b d0
.2xx:								; d0 = $0064 - d0, d1 = $0003, call PushNumberWrap, ...
	lda.w #$0064					;100
	sec
	sbc.b d0						;minus scored on: save %
	sta.b d0
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l PrintToStatsPage			;print
	lda.w #$001E					;column 30
	sta.w printx
	lda.w #PercentSign>>16
	sta.b a1+2
	lda.w #PercentSign
	sta.b a1
	jsl.l PrintToStatsPage			;%
	pla								;restore d1
	sta.b d1
	ply
	rtl
