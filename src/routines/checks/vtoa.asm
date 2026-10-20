; d0 = the direction (0-7, 8 = none) of the x / y distances d0 / d1.
;
; Takes d0 = dx and d1 = dy. Returns d0 = direction 0-7, or 8 when both are 0. Uses the sign
; of dx, the sign of dy and two slope tests (against twice the other axis) to build an index into
; the direction table.
;
; Called from many routines, among them Bcheck, FallDown, doplayeracc, noturn0, skateto and checkcheck.
vtoa:								; direction of the vector d0 / d1
	lda.b d0						; vector
	ora.b d1						; zero
	beq .nodir						; no direction
	stz.b d7+2						;the octant index (94G builds it in d2): sign
	;bits, then the two ratio bits
	lda.b d0						; dx
	bpl .0							; positive
	eor.w #$FFFF					; negate
	inc a
	sta.b d0
	inc.b d7+2
.0:									; y sign
	lda.b d1						; dy
	bpl .1							; positive
	eor.w #$FFFF					; negate
	inc a
	sta.b d1
	inc.b d7+2
	inc.b d7+2
.1:									; slope test: |dx| against 2|dy|
	lda.b d1						; bit 2: |dx| <= 2|dy|
	asl a							; 2|dy| >= |dx|
	cmp.b d0
	bcc .2
	lda.w #$0004					; set bit 2
	tsb.b d7+2
.2:									; slope test: |dy| against 2|dx|
	lda.b d0						; bit 3: |dy| <= 2|dx|
	asl a							; 2|dx| >= |dy|
	cmp.b d1
	bcc .3
	lda.w #$0008					; set bit 3
	tsb.b d7+2
.3:									; direction from the table
	phx
	ldx.b d7+2
	lda.l .dt,x						; direction
	plx								; restore X
	and.w #$00FF
	sta.b d0
	rtl
.nodir:								; 8 = no direction
	lda.w #$0008					; none
	sta.b d0
	rtl
.dt:								;direction for each sign/ratio combination
	db $01,$07,$03,$05,$00,$00,$04,$04,$02,$06,$02,$06,$01,$07,$03,$05
