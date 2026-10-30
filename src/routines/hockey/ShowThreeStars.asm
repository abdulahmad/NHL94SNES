; Stars of the Game
ShowThreeStars:						; called from InProgress
	phx
	phy
	stx.b xsave
	ldx.w #$0000
.loop:								; loop: X + 1, X + 1, if not zero go to .loop, ...
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
	bne .loop
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.loop2:								; loop: X + 1, X + 1, if not zero go to .loop2, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .loop2
	ldx.b xsave
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowStarsPos>>16
	sta.b a1+2
	lda.w #ShowStarsPos
	sta.b a1
	jsl.l print						; print ShowStarsPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0013					;19 wide
	sta.b d0
	lda.w #$0008					;8 high
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser					;clear the box area
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowStarsPos2>>16
	sta.b a1+2
	lda.w #ShowStarsPos2
	sta.b a1
	jsl.l print						; print ShowStarsPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0015					;21 wide
	sta.b d0
	lda.w #$0007					;7 high
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #StarsOfTheGame>>16
	sta.b a1+2
	lda.w #StarsOfTheGame
	sta.b a1
	jsl.l print						; print StarsOfTheGame
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l .t1						;pick the three stars
	lda.w #$0005
	sta.w printy					;row 5
	lda.w #$000D
	sta.w printx					;column 13
	stz.b d3						;home
	stz.b a2						;home team
	lda.w star1						;first star
	cmp.w #$001A					;visitors' player?
	bmi .1							;no
	sec
	sbc.w #$001A					;minus 26: roster slot
	sta.w star1						;in his team
	inc.b d3						;visitors
	lda.w #$0002
	sta.b a2						;visitors' team
.1:									; call printscores1_ps_name, printy = $0005, printx = $0011, ...
	jsl.l printscores1_ps_name				;team name
	lda.w #$0005
	sta.w printy					;row 5
	lda.w #$0011
	sta.w printx					;column 17
	lda.w star1
	sta.b d0						;first star
	jsl.l PlayerInitialName			; mesarea = the first initial
	jsl.l print						;print him
	inc.w printy					;next row
	lda.w #$000D
	sta.w printx					;column 13
	stz.b d3						;home
	stz.b a2						;home team
	lda.w star2						;second star
	cmp.w #$001A					;visitors' player?
	bmi .2							;no
	sec
	sbc.w #$001A					;minus 26
	sta.w star2						;in his team
	inc.b d3						;visitors
	lda.w #$0002
	sta.b a2						;visitors' team
.2:									; call printscores1_ps_name, printy = $0006, printx = $0011, ...
	jsl.l printscores1_ps_name				;team name
	lda.w #$0006
	sta.w printy					;row 6
	lda.w #$0011
	sta.w printx					;column 17
	lda.w star2
	sta.b d0						;second star
	jsl.l PlayerInitialName			; mesarea = the first initial
	jsl.l print						;print him
	inc.w printy					;next row
	lda.w #$000D
	sta.w printx					;column 13
	stz.b d3						;home
	stz.b a2						;home team
	lda.w star3						;third star
	cmp.w #$001A					;visitors' player?
	bmi .3							;no
	sec
	sbc.w #$001A					;minus 26
	sta.w star3						;in his team
	inc.b d3						;visitors
	lda.w #$0002
	sta.b a2						;visitors' team
.3:									; call printscores1_ps_name, printy = $0007, printx = $0011, ...
	jsl.l printscores1_ps_name				;team name
	lda.w #$0007
	sta.w printy					;row 7
	lda.w #$0011
	sta.w printx					;column 17
	lda.w star3
	sta.b d0						;third star
	jsl.l PlayerInitialName			; mesarea = the first initial
	jsl.l print						;print him
	stx.b xsave
	ldx.w #$0012					;10 words
.loop3:								; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla								;restore a0
	sta.b a0,x
	dex
	dex
	bpl .loop3
	ldx.b xsave
	stx.b xsave
	ldx.w #$0016					;12 words
.loop4:								; loop: d0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b d0,x						;restore d0
	dex
	dex
	bpl .loop4
	ldx.b xsave
	ply
	plx
	rtl

.t1:								; subroutine: star1score+2 = $0000, star1score = $0000, star2score+2 =...
	lda.w #$0000					;no scores yet
	sta.w star1score+2
	lda.w #$0000
	sta.w star1score
	lda.w #$0000
	sta.w star2score+2
	lda.w #$0000
	sta.w star2score
	lda.w #$0000
	sta.w star3score+2
	lda.w #$0000
	sta.w star3score
	lda.w #$FFFF					;no overtime scorer
	sta.w otgoalscorer
	lda.w #ScoreSum>>16
	sta.b a1+2						;scoring summary
	lda.w #ScoreSum-6				;last entry
	sta.b a1
	ldy.w #$0000
	lda.b [a1],y					;entry
	and.w #$F000					;type nibble
	xba
	lsr a
	lsr a
	lsr a							;down to bits 0-3
	lsr a
	lsr a
	lsr a
	cmp.w #$0003					;overtime goal?
	bne .1x							;no
	iny
	iny
	iny
	lda.b [a1],y
	and.w #$00FF					;the scorer
	sta.w otgoalscorer				;otgoalscorer
	dey
	lda.b [a1],y					;team nibble
	and.w #$00F0
	beq .1x							;home: as is
	lda.w otgoalscorer				;visitors' scorer
	clc
	adc.w #$001A					;plus 26
	sta.w otgoalscorer
.1x:								; a2 = 0, call GetPlayerCount, starplayerend = d0, ...
	stz.b a2						;home team
	jsl.l GetPlayerCount			; count the players of the team
	lda.b d0						;players
	sta.w starplayerend				;end of the home players
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	lda.b d0						;goalies
	sta.w stargoalieend				;end of the home goalies
	ldx.w #$0000					;first player
.12:								; if minus go to .t1x, ...
	phx
	cpx.w starplayerend				;past the last?
	bmi .t1x						;no: rate him
	jmp.w .16						;yes: next

.t1x:								; call .17, if minus go to .t2, ...
	jsl.l .17						;his score in d0
	lda.b d0+2						;high word
	sec
	sbc.w star1score+2				;minus the first star's
	bmi .t2							;lower?
	bvc .1xx						;no overflow: compare low
	bra .3x							;overflow: lower

.t2:								; if overflow clear go to .3x
	bvc .3x							;no overflow: lower
.1xx:								; if zero go to .2x, ...
	beq .2x							;equal: low word
	bmi .t1xx						;lower?
	bvs .2x							;overflow: lower
	bra .13							;higher: new first star

.t1xx:								; if overflow set go to .13
	bvs .13							;overflow: higher
.2x:								; if zero go to .3x, ...
	lda.b d0						;low word
	sec
	sbc.w star1score				;minus the first star's
	beq .3x							;not higher
	bmi .t1xxx						;lower?
	bvs .3x							;overflow: lower
	bra .13							;higher: new first star

.t1xxx:								; if overflow set go to .13
	bvs .13							;overflow: higher
.3x:								; if minus go to .t1xxxx, ...
	lda.b d0+2						;high word
	sec
	sbc.w star2score+2				;minus the second star's
	bmi .t1xxxx						;lower?
	bvc .4							;no overflow
	bra .6							;overflow: lower

.t1xxxx:							; if overflow clear go to .6
	bvc .6							;no overflow: lower
.4:									; if zero go to .5, ...
	beq .5							;equal: low word
	bmi .t1xxxxx					;lower?
	bvs .5							;overflow: lower
	bra .14							;higher: new second star

.t1xxxxx:							; if overflow set go to .14
	bvs .14							;overflow: higher
.5:									; if zero go to .6, ...
	lda.b d0						;low word
	sec
	sbc.w star2score				;minus the second star's
	beq .6							;not higher
	bmi .t1xxxxxx					;lower?
	bvs .6							;overflow: lower
	bra .14							;higher: new second star

.t1xxxxxx:							; if overflow set go to .14
	bvs .14							;overflow: higher
.6:									; if minus go to .8, ...
	lda.b d0+2						;high word
	sec
	sbc.w star3score+2				;minus the third star's
	bmi .8							;lower?
	bvc .9							;no overflow
.7:									; go to .16
	jmp.w .16						;not a star
.8:									; if overflow clear go to .7
	bvc .7							;no overflow: lower
.9:									; if zero go to .10, ...
	beq .10							;equal: low word
	bmi .t1xxxxxxx					;lower?
	bvs .10							;overflow: lower
	bra .15							;higher: new third star

.t1xxxxxxx:							; if overflow set go to .15
	bvs .15							;overflow: higher
.10:								; if zero go to .11, ...
	lda.b d0						;low word
	sec
	sbc.w star3score				;minus the third star's
	beq .11							;not higher
	bmi .t1xxxxxxxx					;lower?
	bvs .11							;overflow: lower
	bra .15							;higher: new third star

.t1xxxxxxxx:						; if overflow set go to .15
	bvs .15							;overflow: higher
.11:								; go to .16
	bra .16							;not a star
.13:								;new first star: the old one moves down
	lda.w star1						;old first star
	sta.w starswapplayer
	lda.w star1score+2				;and his score
	sta.w starswapscore+2
	lda.w star1score
	sta.w starswapscore
	stx.w star1						;new first star
	lda.b d0+2
	sta.w star1score+2				;his score
	lda.b d0
	sta.w star1score
	ldx.w starswapplayer			;old first star
	lda.w starswapscore+2
	sta.b d0+2						;compared next
	lda.w starswapscore
	sta.b d0
.14:								;new second star: the old one moves down
	lda.w star2						;old second star
	sta.w starswapplayer
	lda.w star2score+2				;and his score
	sta.w starswapscore+2
	lda.w star2score
	sta.w starswapscore
	stx.w star2						;new second star
	lda.b d0+2
	sta.w star2score+2				;his score
	lda.b d0
	sta.w star2score
	ldx.w starswapplayer			;old second star
	lda.w starswapscore+2
	sta.b d0+2						;compared next
	lda.w starswapscore
	sta.b d0
.15:								;new third star
	stx.w star3
	lda.b d0+2						;his score
	sta.w star3score+2
	lda.b d0
	sta.w star3score
.16:								; X + 1, if starplayerend - $001A >= 0 go to .1xxx, ...
	plx								;this player
	inx
	lda.w starplayerend				;visitors reached?
	cmp.w #$001A					;yes
	bpl .1xxx
	cpx.w #$001A					;past the home roster?
	bmi .1xxx						;no
	lda.w #$0002					;visitors' team
	sta.b a2
	jsl.l GetPlayerCount			; count the players of the team
	lda.b d0						;players
	clc
	adc.w #$001A					;plus 26
	sta.w starplayerend				;end of the visitors
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	lda.b d0						;goalies
	clc
	adc.w #$001A					;plus 26
	sta.w stargoalieend				;end of the visitors' goalies
.1xxx:								; if plus go to .t1xxxxxxxxx, ...
	cpx.w #$0034					;both rosters done?
	bpl .t1xxxxxxxxx				;yes
	jmp.w .12						;no: next

.t1xxxxxxxxx:						; return
	rtl
.17:								; subroutine: a2 = 0, a1 = $0002, if minus go to .1xxxx, ...
	stz.b a2						;home team
	lda.w #$0002
	sta.b a1						;opponent visitors
	cpx.w #$001A					;visitors' player?
	bmi .1xxxx						;no
	lda.w #$0002					;visitors
	sta.b a2
	stz.b a1						;opponent home
.1xxxx:								; d0 = tmscore,y - tmscore,y, d0+2 = $0000 - $0000, if minus go to .t1x...
	ldy.b a2
	lda.w tmscore,y					;his team's score
	ldy.b a1
	sec
	sbc.w tmscore,y
	sta.b d0						;goal margin
	lda.w #$0000
	sbc.w #$0000
	sta.b d0+2						;score high word
	cpx.w stargoalieend				;a goalie?
	bmi .t1xxxxxxxxxx				;yes: goalie rating
	cpx.w otgoalscorer				;scored the overtime goal?
	bne .2xx						;no
	lda.w #$000B					;bonus $B71B0
	sta.b r2+2
	lda.w #$71B0
	sta.b r2
	jsr.w .18						;add it
.2xx:								; call Mul16U, call .18, call Mul16U, ...
	sep #$20
	lda.w tmgoals,x					;goals
	rep #$20
	and.w #$00FF
	phx								;keep X
	ldx.w #$2AF8					;x 11000
	jsl.l Mul16U
	plx
	jsr.w .18						;add it
	sep #$20
	lda.w tmassists,x				;assists
	rep #$20
	and.w #$00FF
	phx
	ldx.w #$2774					;x 10100
	jsl.l Mul16U
	plx
	jsr.w .18						;add it
	sep #$20
	lda.w tmpshots,x				;shots
	rep #$20
	and.w #$00FF
	phx
	ldx.w #$000A					;x 10
	jsl.l Mul16U
	plx
	jsr.w .18						;add it
	bra .3xx

.t1xxxxxxxxxx:						; call GetPeriodTime, call DivX8U, d1 = A, ...
	lda.b d0						;margin
	pha
	jsl.l GetPeriodTime				; d0 = the period length in seconds for the period length option
	lda.b d0						;period length
	phx
	ldx.w #$0028
	jsl.l DivX8U					;shot threshold
	plx
	sta.b d1						;d1
	pla
	sta.b d0						;margin back
	sep #$20
	lda.w tmpshots,x				;shots faced
	rep #$20
	and.w #$00FF
	cmp.b d1						;enough?
	bmi .3xx						;no: no goalie rating
	sta.b r1						;r1
	sep #$20
	lda.w tmgoals,x					;goals against
	rep #$20
	and.w #$00FF
	phx
	ldx.w #$0064					;x 100
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	sta.b r2						;r2
	jsl.l Div16U					;goals x 100 / shots
	plx
	lda.b r0
	cmp.w #$0003					;under 3%?
	bpl .3xx						;no: no bonus
	lda.w #$0000
	sta.b r2+2						;bonus 32000
	lda.w #$7D00
	sta.b r2
	jsr.w .18						;add it
	lda.b r0
	cmp.w #$0000					;shutout?
	bne .3xx						;no
	lda.w #$0001
	sta.b r2+2						;extra bonus 75000
	lda.w #$24F8
	sta.b r2
	jsr.w .18						;add it
.3xx:								; d0+2 = d0+2 * 2, d0+2 = d0+2 + $0000, d0 = d0 & $7FFF, ...
	lda.b d0+2						;score high word
	asl a							;x2
	sta.b d0+2
	lda.b d0
	asl a							;low word's top bit
	lda.b d0+2
	adc.w #$0000					;into the high word
	sta.b d0+2
	lda.b d0
	and.w #$7FFF					;15-bit low word
	sta.b d0						;compares as signed halves
	rtl
.18:								;d0:d0+2 += r2:r2+2
	lda.b d0
	clc
	adc.b r2
	sta.b d0
	lda.b d0+2
	adc.b r2+2
	sta.b d0+2
	rts
