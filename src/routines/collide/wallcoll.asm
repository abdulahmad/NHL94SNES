; Bounce object X off a wall
;
; Takes X = object that hit the wall and d0/d1 = cos/sin of the wall angle (stored in Wallcos/Wallsin). The
; speed is split into v1n (into the wall) and v1t (along it), both reduced, and rotated back into Xvel/Yvel.
; A hard puck hit pops the puck up and plays a sound; a fast player hit plays a board sound.
;
; Called from wallcollb (also as the bounce path) and from checkgoalp.
wallcoll:							; bounce object X off a wall
	lda.b d0
	sta.w Wallcos,x					; Wallcos = cos
	lda.b d1
	sta.w Wallsin,x					; Wallsin = sin
	lda.b d2						; save d2, d3, d1 and d0 (cos and sin stay on the stack)
	pha
	lda.b d3
	pha
	lda.b d1
	pha
	lda.b d0
	pha
	txy								; Y = object
	ldx.w Yvel,y					; Yvel * cos / 256 (A = cos)
	jsl.l Mul16x8S
	lda.b r2+1
	sta.b d0						; d0 = Yvel * cos
	ldx.w Xvel,y					; Xvel * sin / 256
	lda.b d1
	jsl.l Mul16x8S
	lda.b d0						; negate Yvel*cos - Xvel*sin
	sec
	sbc.b r2+1
	eor.w #$FFFF
	inc a
	sta.b d2						; d2 = v1n, the speed into the wall
	ldx.w Xvel,y					; Xvel * cos / 256
	lda.b r0+1,s
	jsl.l Mul16x8S
	lda.b r2+1
	sta.b d0
	ldx.w Yvel,y					; Yvel * sin / 256
	lda.b d1
	jsl.l Mul16x8S
	lda.b r2+1
	clc
	adc.b d0
	sta.b d3						; d3 = v1t = Xvel*cos + Yvel*sin, the speed along the wall
	tyx								; back to X
	cpx.w #$001C					; the puck?
	beq .t2
	jmp.w .6						; no: a player

.t2:								; puck: clear sflags bit $1000
	lda.w #$1000
	trb.w sflags
	lda.b d2						; moving into the wall?
	bmi .t1
	jmp.w .8						; no: moving away, no collision

.t1:								; puck: v1n / 4
	lsr a
	lsr a
	bit.w #$2000					; sign extend the shift
	beq .1
	ora.w #$C000
.1:									; keep v1n / 4
	sta.b d2
	sec
	sbc.w #$FC00					; v1n >= -$400: soft hit, no pop up
	bpl .3
	jsl.l RandomWord				; hard hit: random pop up speed
	and.w #$07FF
	eor.w #$FFFF
	inc a
	sta.w puckvz					; puckvz = minus a random 0-$7FF
	sta.b d0
	jsl.l puckflip					; flip the puck
	lda.w #$000A					; sound 10, or 4 if puckz is below $0B
	ldy.w puckz
	cpy.w #$000B
	bcs .2
	lda.w #$0004
.2:									; play the puck sound
	jsl.l PuckSfx
.3:									; reduce the tangent speed of the puck
	lda.b d3						; v1t / 64
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200					; sign extend the shift
	beq .4
	ora.w #$FC00
.4:									; d0 = v1t / 64
	sta.b d0
	pha								; half of it in d0+2
	asl a
	pla
	ror a
	sta.b d0+2
	lda.b d3						; v1t minus both
	sec
	sbc.b d0
org $9E9000
	sec
	sbc.b d0+2
	sta.b d3
	bra .7							; rotate back
.5:									; far jump to the end (no collision)
	jmp.w .8
.6:									; player: v1n
	lda.b d2
	sec
	sbc.w #$03E8					; v1n >= 1000: no collision
	bpl .5
	lda.b d2
	sec
	sbc.w #$F000					; v1n >= -$1000: no board sound
	bpl .1x
	lda.w impact,x
	sec
	sbc.w #$000A					; impact below 10: no board sound
	bmi .1x
	lda.w Xvel,x					; p0 = Xvel, p0+2 = Yvel
	sta.b p0
	lda.w Yvel,x
	sta.b p0+2
	lda.w #$000D					; play sound $0D (board hit)
	jsl.l sfx
.1x:								; player: v1n / 4
	lda.b d2
	lsr a
	lsr a
	bit.w #$2000					; sign extend the shift
	beq .2x
	ora.w #$C000
.2x:								; keep v1n / 4
	sta.b d2
	sec
	sbc.w #$FC7C					; v1n < -900: keep it
	bmi .7
	lda.w #$FC18					; else limit v1n to -1000
	sta.b d2
.7:									; rotate back into Xvel and Yvel
	lda.b r0+1,s					; cos * v1t / 256
	ldx.b d3
	jsl.l Mul16x8S
	lda.b r2+1
	sta.b tmp0
	lda.b r0+3,s					; sin * v1n / 256
	ldx.b d2
	jsl.l Mul16x8S
	lda.b tmp0						; Xvel = cos*v1t - sin*v1n
	sec
	sbc.b r2+1
	ldx.b a3
	sta.w Xvel,x
	lda.b r0+3,s					; sin * v1t / 256
	ldx.b d3
	jsl.l Mul16x8S
	lda.b r2+1
	sta.b d3
	lda.b r0+1,s					; cos * v1n / 256
	ldx.b d2
	jsl.l Mul16x8S
	lda.b r2+1						; Yvel = sin*v1t + cos*v1n
	clc
	adc.b d3
	ldx.b a3
	sta.w Yvel,x
	lda.w puckvz					; puck moving up keeps its Zvel
	bmi .8
	stz.w puckvz					; else puckvz = 0
.8:									; drop the stacked cos and sin
	pla								; restore d3 and d2
	pla
	pla
	sta.b d3
	pla
	sta.b d2
	cpx.w #$001C					; the puck?
	bne .rtl						; no: done
	lda.w puckc						; puck carrier set (not loose)?
	bpl .rtl						; yes: done
	jsl.l EndPenaltyShot			; loose puck: end the penalty shot
	stz.w breakaway					; clear breakaway and the one-timer
	stz.w onetimer
.rtl:								; return
	rtl
