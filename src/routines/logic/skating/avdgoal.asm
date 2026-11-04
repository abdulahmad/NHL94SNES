; Do not skate through the goal: aim beside the net when the path crosses it
avdgoal:							; called from assgoalietopuck, skateto, skatetopuck
	phb								;save the bank
	phk								; data bank = program bank
	plb
	stz.b tmp2						;no crossing yet
	lda.w Xpos,x					;start x
	sta.b p0						;start x
	lda.w Ypos,x					;start y
	sta.b p0+2						;start y
	lda.b d0						;target x
	sta.b p1						;target x
	lda.b d1						;target y
	sta.b p1+2						;target y
	lda.w position,x				;position
	bne .t1							;skater?
	jmp.w .28						;goalie: own box

.t1:								; position,x != 0: call .27, r3 = $00E4, r3+2 = $011D, ...
	ldx.w #$00E5					;box near
	ldy.w #$011C					;box far
	jsr.w .27						;region codes for the top net
	ldx.w #$00E4					;box near y
	ldy.w #$011D					;box far y
	stx.b r3						;box
	sty.b r3+2						;box
	lda.w #$0108					;goal line y
	sta.b r6+2						;top goal line
	lda.w topgoalie					;top goalie
	sta.b r6						;top goalie
	lda.b tmp2						;crossing?
	bne .t2							;crossing the top net: fix the target
	ldx.w #$FEE4					;box near
	ldy.w #$FF1B					;box far
	jsr.w .27						;bottom net box
	ldx.w #$FEE3					;box far y
	ldy.w #$FF1C					;box near y
	stx.b r3						;box
	sty.b r3+2						;box
	lda.w #$FEF8					;goal line y
	sta.b r6+2						;bottom goal line
	lda.w botgoalie					;bottom goalie
	sta.b r6						;bottom goalie
	lda.b tmp2						;crossing the bottom net?
	bne .2							;crossing: fix the target
	ldx.b curobj					;player
	plb								;restore the bank
	rtl

.t2:								;crossing the bottom net: mirror to the top case
	lda.b r3						;near line
	ldy.b r3+2						;far line
	sty.b r3						;swap the box lines
	sta.b r3+2						;swap the box lines
	lda.b p0+2						;start y
	eor.w #$FFFF					;mirror start y
	inc a							;mirror start y
	sta.b p0+2						;mirror start y
	lda.b p1+2
	eor.w #$FFFF					;mirror target y
	inc a							;mirror target y
	sta.b p1+2						;mirror target y
	lda.b tmp0						;start code
	bit.w #$000A					;before or past?
	beq .1							;not before or past
	eor.w #$000A					;swap before / past
	sta.b tmp0
.1:									; if tmp1 bits $000A clear go to .2, ...
	lda.b tmp1						;target code
	bit.w #$000A					;target code
	beq .2							;before or past?
	eor.w #$000A					;swap before / past
	sta.b tmp1						;swap before / past
.2:									;pick the handler
	lda.b tmp1						;target code
	beq .t1x						;target code 0
	ldx.b tmp0						;start code
	jsr (.26,x)						;the handler for the start code
	ldx.b curobj					;player
	plb								;restore the bank
	rtl

.t1x:								;target code 0: the goal line check
	jsr.w .t2x						;goal line check
	ldx.b curobj					;player
	plb								;restore the bank
	rtl

.t2x:								;target code 0: only the goal line matters
	ldx.b curobj					;player
	lda.b p0+2						;start y
	cmp.w #$FEF8					;behind the goal line?
	bpl .t1xx						;start in front?
	lda.b p1+2
	cmp.w #$FEF8					;target y
	bmi .3							;target in front?
	bra .8							;target behind too: keep
									;aim beside the net
.t1xx:								;start behind the goal line
	lda.b p1+2						;target y
	cmp.w #$FEF8					;target in front?
	bmi .5							;target in front of the goal line
	ldy.b r6						;goalie of this end
	bmi .3							;no goalie: keep
	lda.b p0						;start x
	cmp.b p1						;start x against the target x
	bmi .4							;start left of the target
	cmp.w Xpos,y					;start right of the goalie?
	bmi .3							;right of the goalie: keep
	lda.b r3+2						;far line y
	sta.b d1						;along the far line
.3:									;keep it
	rts
.4:									; p0 - p1 negative: if plus go to .rts, ...
	cmp.w Xpos,y					;left of the goalie?
	bpl .rts						;start right of the goalie: keep
	lda.b r3+2						;far line y
	sta.b d1						;along the far line
.rts:								; return
	rts
.5:									;target in front of the goal line
	lda.b r3+2						;far line y
	sta.b d1						;along the far line
	bra .10							;keep the target clear of the goalie
.6:									; d0 = $FFCA, return
	lda.w #$FFCA					;left of the net
	sta.b d0						;aim left of the net
	rts
.7:									;start code 0
	lda.b p0+2						;start y
	cmp.w #$FEF8					;behind the goal line?
	bpl .9							;start behind the goal line
.8:									;start in front of the net: aim beside it
	lda.b p0						;start x
	cmp.w #$FFCB					;left of the box?
	bmi .6							;left of the box: aim left
	cmp.w #$0036					;right of the box?
	bpl .17							;right of the box: aim right
	lda.b r3
	sta.b d1						;near line y
	bra .12							;along the near line
.9:									;start behind the goal line
	lda.b p1+2						;target y
	cmp.w #$FEF8
	bpl .t1xxx						;target in front too?
	lda.b r6+2						;goal line
	sta.b d1						;aim at the goal line
	ldy.b r6						;goalie
	bmi .12							;no goalie: keep x
	lda.b p0
	cmp.w Xpos,y					;start left of the goalie?
	bmi .6							;left of the goalie
	bra .17							;right of the goalie

.t1xxx:								;both behind the goal line
	ldy.b r6						;goalie
	bmi .13							;no goalie: keep
.10:								;keep the target clear of the goalie
	lda.b p1						;target x
	sec
	sbc.w Xpos,y					;target x minus the goalie x
	pha								; 1,s = this x difference
	lda.b p0						;start x
	sec
	sbc.b p1						;start minus target
	eor.b 1,s						;start and target on the same side of the goalie?
	bpl .14							;same side: keep the target
	pla								;drop the saved difference
	lda.b p0						;start x
	cmp.w Xpos,y					;start right of the goalie?
	bpl .17							;start left: go right
	bra .23
.11:								;start code 2: along the far line
	lda.b r3+2						;along the far line
	sta.b d1						;far line
	lda.b tmp1
	and.w #$0008					;side bit 8?
	bne .13							;other side: keep x
.12:								;keep the target x outside the posts
	lda.b p1						;target x
	bpl .t1xxxx						;target right of centre
	cmp.w #$FFCB					;inside?
	bmi .13							;left of the left post: keep
	lda.w #$FFCA
	sta.b d0						;clamp to the left post
	rts

.t1xxxx:							; p1 >= 0: if plus go to .13, ...
	cmp.w #$0036					;past the right post?
	bpl .13							;right of the right post: keep
	lda.w #$0036					;inside: aim at the right post
	sta.b d0						;clamp to the right post
.13:								; return
	rts
.14:								;same side: keep the target
	pla								;drop the saved difference
	rts
.15:								;aim right unless coming from the left
	lda.b tmp1
	cmp.w #$0010					;from the left?
	bne .17
.16:								;aim along the far line
	lda.b r3+2						;far line y
	sta.b d1						;along the far line
	rts
.17:								; d0 = $0036, return
	lda.w #$0036					;aim right
	sta.b d0						;right of the net
	rts
.18:								;start before and right: aim right, or along the line
	lda.w #$0036					;aim right of the net
	sta.b d0
	lda.b tmp1						;target side bits
	and.w #$000A
	beq .16							;no side bits: along the far line
	rts
.19:								;aim right of the net
	lda.b tmp1
	cmp.w #$0010					;from the left?
	bne .17
.20:								; d1 = r3, return
	lda.b r3						;along the near line
	sta.b d1
	rts
.21:								;start code 4 (right): aim along the near line
	lda.b r3						;aim along the near line
	sta.b d1
	lda.b tmp1						;target before?
	and.w #$0002					;start past: keep x
	bne .12
	rts
.22:								;aim left unless coming from the right
	lda.b tmp1
	cmp.w #$0004					;start from the right?
	beq .20
.23:								; d0 = $FFCA, return
	lda.w #$FFCA					;aim left of the net
	sta.b d0
	rts
.24:								;start before and left: aim left, or along the line
	lda.w #$FFCA					;aim left of the net
	sta.b d0
	lda.b tmp1						;target side bits
	and.w #$000A
	beq .16							;no side bits: aim along the near line
	rts
.25:								; if tmp1 = $0004 go to .16
	lda.b tmp1						;from the right side only
	cmp.w #$0004
	beq .16
.1x:								;aim left of the net
	lda.w #$FFCA					;aim left of the net
	sta.b d0
	rts
.26:								;the handlers by the start code
	dw .7,.11,.18,.15,.21,$0000,.19
	dw $0000,.24,.25,$0000,$0000,.22
.27:								;region codes of start and target against the net box
	stx.b r3						;box near y
	sty.b r3+2						;box far y
	stz.b tmp0						;start code
	stz.b tmp1						;target code
	ldx.b p0+2						;start y
	ldy.b p1+2						;target y
	cpx.b r3						;start before the box?
	bpl .4x							;start not before the box
	lda.w #$0008					;before = 8
	sta.b tmp0						;start before the box
	cpy.b r3						;target before the box?
	bpl .5x							;start before, target not: check x
.1xx:								; return
	rts
.2x:								; if minus go to .6x, ...
	cpy.b r3+2						;target past the box?
	bmi .6x
	lda.w #$0002					;past = 2
	sta.b tmp1						;target past the box
	bra .6x
.3x:								; p1 - $002C negative: if minus go to .7x, ...
	cpy.w #$002C
	bmi .7x
	lda.b tmp1
	ora.w #$0004
	sta.b tmp1
	bra .7x
.4x:								;start not before the box
	cpy.b r3						;target before the box?
	bpl .5x
	lda.w #$0008					;before = 8
	sta.b tmp1						;target before the box
.5x:								; if minus go to .2x, ...
	cpx.b r3+2						;start past the box?
	bmi .2x
	lda.w #$0002					;past = 2
	sta.b tmp0						;start past the box
	cpy.b r3+2						;both past the box: no crossing
	bpl .1xx
.6x:								;x codes: right of $2C = 4, left of -$2C = $10
	ldx.b p0						;start x
	ldy.b p1						;target x
	cpx.w #$002C					;start right of the net?
	bmi .3x
	lda.b tmp0
	ora.w #$0004					;start right of the net
	sta.b tmp0
	cpy.w #$002C					;target right of the net?
	bpl .1xx						;both right: no crossing
.7x:								; if plus go to .2xx, ...
	cpx.w #$FFD4					;start left of the net?
	bpl .2xx
	lda.b tmp0
	ora.w #$0010					;start left of the net
	sta.b tmp0
	cpy.w #$FFD4					;target left too?
	bmi .1xx						;start and target left: no crossing
.1xxx:								;x between the posts: the path can hit the net
	inc.b tmp2						;target between the posts: a crossing
	rts
.2xx:								; if plus go to .1xxx, ...
	cpy.w #$FFD4					;target left of the net too?
	bpl .1xxx						;target not left: crossing
	lda.b tmp1
	ora.w #$0010					;target left of the net
	sta.b tmp1
	inc.b tmp2						;both ends inside the box in x: a crossing
	rts
.28:								; call .48, r3 = $0101, r3+2 = $011D, ...
	ldx.w #$0102					;box near
	ldy.w #$011C					;box far
	jsr.w .48						;region codes for the top net
	ldx.w #$0101					;box near y
	ldy.w #$011D					;box far y
	stx.b r3						;box
	sty.b r3+2						;box
	lda.b tmp2						;crossing?
	bne .t1xxxxx					;crossing the top net: fix the target
	ldx.w #$FEE4					;box near
	ldy.w #$FEFE					;box far
	jsr.w .48						;bottom net box
	ldx.w #$FEE3					;box far y
	ldy.w #$FEFF					;box near y
	stx.b r3						;box
	sty.b r3+2						;box
	lda.b tmp2						;crossing the bottom net?
	bne .2xxx						;crossing: fix the target
	ldx.b curobj					;player
	plb								;restore the bank
	rtl

.t1xxxxx:							; tmp2 != 0: r3 = r3+2, r3+2 = r3, p0+2 = -(p0+2), ...
	lda.b r3						;near line
	ldy.b r3+2						;far line
	sty.b r3						;swap the box lines
	sta.b r3+2						;swap the box lines
	lda.b p0+2						;start y
	eor.w #$FFFF					; negate: two's complement
	inc a							;mirror start y
	sta.b p0+2						;mirror start y
	lda.b p1+2
	eor.w #$FFFF					; negate: two's complement
	inc a							;mirror target y
	sta.b p1+2						;mirror target y
	lda.b tmp0						;start code
	bit.w #$000A					;before or past?
	beq .1xxxx						;not before or past
	eor.w #$000A					;swap before / past
	sta.b tmp0
.1xxxx:								; if tmp1 bits $000A clear go to .2xxx, ...
	lda.b tmp1						;target code
	bit.w #$000A					;target code
	beq .2xxx						;before or past?
	eor.w #$000A					;swap before / past
	sta.b tmp1						;swap before / past
.2xxx:								; if tmp1 = 0 go to .t1xxxxxx, ...
	lda.b tmp1						;target code
	beq .t1xxxxxx					;target code 0
	ldx.b tmp0						;start code
	jsr (.47,x)						;the handler for the start code
	ldx.b curobj					;player
	plb								;restore the bank
	rtl

.t1xxxxxx:							; tmp1 = 0: call .t3, return
	jsr.w .t3
	ldx.b curobj					;player
	plb								;restore the bank
	rtl

.t3:								; subroutine: if p0+2 - $FEF8 >= 0 go to .t1xxxxxxx, ...
	ldx.b curobj					;player
	lda.b p0+2						;start y
	cmp.w #$FEF8					;behind the goal line?
	bpl .t1xxxxxxx					;start in front?
	lda.b p1+2
	cmp.w #$FEF8					;target y
	bmi .t2xx						;target in front?
	bra .31							;target behind too: keep

.t1xxxxxxx:							; p0+2 - $FEF8 >= 0: if p1+2 - $FEF8 >= 0 go to .t2xx, ...
	lda.b p1+2						;target y
	cmp.w #$FEF8					;target in front?
	bpl .t2xx
	bra .33

.t2xx:								; return
	rts

.t1xxxxxxxx:						; if plus go to .36, ...
	cmp.w Xpos,y					;left of the goalie?
	bpl .36							;start right of the goalie: keep
	lda.b r3+2						;far line y
	sta.b d1						;along the far line
	rts
.29:								; p0 - $FFDB negative: d0 = $FFDA, return
	lda.w #$FFDA					;left of the net
	sta.b d0						;aim left of the net
	rts
.30:								; if p0+2 - $FEF8 >= 0 go to .32
	lda.b p0+2						;start y
	cmp.w #$FEF8					;behind the goal line?
	bpl .32							;start behind the goal line
.31:								; if p0 - $FFDB negative go to .29, ...
	lda.b p0						;start x
	cmp.w #$FFDB					;left of the box?
	bmi .29							;left of the box: aim left
	cmp.w #$0026					;right of the box?
	bpl .39							;right of the box: aim right
	lda.b r3
	sta.b d1						;near line y
	bra .35							;along the near line
.32:								; p0+2 - $FEF8 >= 0: if tmp1 bit $0002 set go to .36
	lda.b tmp1
	bit.w #$0002
	bne .36
.33:								; d1 = r3+2, go to .35
	lda.b r3+2
	sta.b d1
	bra .35
.34:								; d1 = r3+2, if tmp1 & $0008 != 0 go to .36
	lda.b r3+2						;along the far line
	sta.b d1						;far line
	lda.b tmp1
	and.w #$0008					;side bit 8?
	bne .36							;other side: keep x
.35:								; if p1 >= 0 go to .t1xxxxxxxxx, ...
	lda.b p1						;target x
	bpl .t1xxxxxxxxx				;target right of centre
	cmp.w #$FFDB					;inside?
	bmi .36							;left of the left post: keep
	lda.w #$FFDA
	sta.b d0						;clamp to the left post
	rts

.t1xxxxxxxxx:						; p1 >= 0: if plus go to .36, ...
	cmp.w #$0026					;past the right post?
	bpl .36							;right of the right post: keep
	lda.w #$0026					;inside: aim at the right post
	sta.b d0						;clamp to the right post
.36:								; return
	rts
.37:								; if tmp1 != $0010 go to .39
	lda.b tmp1
	cmp.w #$0010					;from the left?
	bne .39
.38:								; d1 = r3+2, return
	lda.b r3+2						;far line y
	sta.b d1						;along the far line
	rts
.39:								; d0 = $0026, return
	lda.w #$0026					;aim right
	sta.b d0						;right of the net
	rts
.40:								; d0 = $0026, if tmp1 & $000A = 0 go to .38, ...
	lda.w #$0026					;aim right of the net
	sta.b d0
	lda.b tmp1						;target side bits
	and.w #$000A
	beq .38							;no side bits: along the far line
	rts
.41:								; if tmp1 != $0010 go to .39
	lda.b tmp1
	cmp.w #$0010					;from the left?
	bne .39
.42:								; d1 = r3, return
	lda.b r3						;along the near line
	sta.b d1
	rts
.43:								; d1 = r3, if tmp1 & $0002 != 0 go to .35, ...
	lda.b r3						;aim along the near line
	sta.b d1
	lda.b tmp1						;target before?
	and.w #$0002					;start past: keep x
	bne .35
	rts
.44:								; if tmp1 = $0004 go to .42, ...
	lda.b tmp1
	cmp.w #$0004					;start from the right?
	beq .42
	lda.w #$FFDA					;aim left of the net
	sta.b d0
	rts
.45:								; d0 = $FFDA, if tmp1 & $000A = 0 go to .38, ...
	lda.w #$FFDA					;aim left of the net
	sta.b d0
	lda.b tmp1						;target side bits
	and.w #$000A
	beq .38							;no side bits: aim along the near line
	rts
.46:								; if tmp1 = $0004 go to .38, ...
	lda.b tmp1						;from the right side only
	cmp.w #$0004
	beq .38
	lda.w #$FFDA					;aim left of the net
	sta.b d0
	rts
.47:								; jump table for jsr (.47,x)
	dw .30,.34,.40,.37,.43,$0000,.41
	dw $0000,.45,.46,$0000,$0000,.44
.48:								; subroutine: r3 = X, r3+2 = Y, tmp0 = 0, ...
	stx.b r3						;box near y
	sty.b r3+2						;box far y
	stz.b tmp0						;start code
	stz.b tmp1						;target code
	ldx.b p0+2						;start y
	ldy.b p1+2						;target y
	cpx.b r3						;start before the box?
	bpl .4xx						;start not before the box
	lda.w #$0008					;before = 8
	sta.b tmp0						;start before the box
	cpy.b r3						;target before the box?
	bpl .5xx						;start before, target not: check x
.1xxxxx:							; return
	rts
.2xxxx:								; if minus go to .6xx, ...
	cpy.b r3+2
	bmi .6xx
	lda.w #$0002
	sta.b tmp1
	bra .6xx
.3xx:								; p1 - $0024 negative: if minus go to .7xx, ...
	cpy.w #$0024
	bmi .7xx
	lda.b tmp1
	ora.w #$0004
	sta.b tmp1
	bra .7xx
.4xx:								; p1+2 - r3 >= 0: if plus go to .5xx, ...
	cpy.b r3
	bpl .5xx
	lda.w #$0008
	sta.b tmp1
.5xx:								; if minus go to .2xxxx, ...
	cpx.b r3+2
	bmi .2xxxx
	lda.w #$0002
	sta.b tmp0
	cpy.b r3+2
	bpl .1xxxxx
.6xx:								; if p1 - $0024 negative go to .3xx, ...
	ldx.b p0
	ldy.b p1
	cpx.w #$0024
	bmi .3xx
	lda.b tmp0
	ora.w #$0004
	sta.b tmp0
	cpy.w #$0024
	bpl .1xxxxx
.7xx:								; if plus go to .2xxxxx, ...
	cpx.w #$FFDC
	bpl .2xxxxx
	lda.b tmp0
	ora.w #$0010
	sta.b tmp0
	cpy.w #$FFDC
	bmi .1xxxxx
.1xxxxxx:							; increment tmp2, return
	inc.b tmp2
	rts
.2xxxxx:							; if plus go to .1xxxxxx, ...
	cpy.w #$FFDC
	bpl .1xxxxxx
	lda.b tmp1
	ora.w #$0010
	sta.b tmp1
	inc.b tmp2
	rts
