; Check button: a speed burst in the facing direction, which costs energy
;
; Takes X = player. Does nothing while his animation is locked (pfalock). Energy is read with getpde; with
; OptLine nonzero a burst costs $CC energy. Speed = energy * $233 >> 16, added to Xvel/Yvel along facedir.
; Called from doinput.
burst:								; speed burst by player X
	lda.w pfalock,x					; animation locked?
	beq .t1							; no: go on
	rtl								; yes: no burst

.t1:								; d0 = energy of player X
	jsl.l getpde					; line changes option
	lda.l OptLine					; off: no energy cost
	beq .1							; line change on: pay for the burst
	lda.b d0
	sec
	sbc.w #$00CC					; minus $CC
	sta.b d0
	jsl.l setpde					; store the new energy
	lda.l OptLine					; automatic line changes?
	cmp.w #$0002
	bne .1							; no: use the energy left
	lda.w #$1000					; automatic: burst speed from a fixed $1000
	sta.b d0
.1:									; speed from d0
	lda.b d0
	ldx.w #$0233					; times $233 (fraction)
	jsl.l Mul16U					; 16 bit multiply
	ldx.b a3						; X = player (kept in a3)
	lda.b r2+2						; high word of the result
	sta.b burstspeed				; burst speed
	lda.w facedir,x					; facing
	asl a							; four bytes per direction
	asl a
	tay								; Y = table offset
	lda.w #dirtab>>16				; direction table
	sta.b a0+2
	lda.w #dirtab
	sta.b a0
	lda.b [a0],y					; x part of the direction
	iny								; next word
	iny
	tax								; X = x multiplier
	lda.b burstspeed
	jsl.l Mul8XS					; speed times the x multiplier
	ldx.b a3						; X = player
	clc
	adc.w Xvel,x					; add to the x velocity
	sta.w Xvel,x
	lda.b [a0],y					; y part of the direction
	tax								; X = y multiplier
	lda.b burstspeed
	jsl.l Mul8XS					; speed times the y multiplier
	ldx.b a3						; X = player
	clc
	adc.w Yvel,x					; add to the y velocity
	sta.w Yvel,x
	lda.w #SPAburst					; burst animation
	sta.w pfalock,x					; lock the animation
	jml.l SetSPAFromA				; start it
