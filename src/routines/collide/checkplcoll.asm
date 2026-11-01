; Check object X against the objects near it in y
checkplcoll:						; called from checkcoll
	lda.w pflags,x
	bit.w #pf2npc					;no-clip?
	bne .rtl						;yes: no collisions
	cpx.w #$0018					;a player?
	bcc .t2							;yes: check
.rtl:								; return
	rtl

.t2:								; X's index in the sorted list
	lda.w OOlistpos,x				; d1 = position of X in OOlist
	sta.b d1						; X's index in the sorted list
.loop:								; loop: if d1 = $000F go to .t1, ...
	ldy.b d1						;list position
	cpy.w #$000F					;end of the list?
	beq .t1							;yes: look the other way
	lda.w OOlist+1,y				;next object up the list
	and.w #$00FF
	tay								;object Y
	lda.w Ylist,y					; its y
	sec
	sbc.b d3						; minus the y of X
	sec
	sbc.w #$000E					;minus 14
	bpl .t1							;too far in y: stop
	lda.w position,y				;on the ice?
	bmi .1							;no: skip
	lda.w Xpos,y					; its x
	sec
	sbc.b d2						; minus the x of X
	cmp.w #$FFF1					;within 15 left?
	bmi .1							;no: skip
	cmp.w #$000F					;within 15 right?
	bpl .1							;no: skip
	lda.w pflags,y					;no-clip
	and.w #$8000					;or
	ora.w pfnc,y					;no-collision flag
	bne .1							;set: skip
	cpy.w #$0018					;a player?
	bcs .1							;no: skip
	jsl.l .t3						;collide X with Y
.1:									; increment d1, go to .loop
	inc.b d1
	bra .loop

.t1:								; if OOlistpos,x = 0 go to .rtlx, ...
	lda.w OOlistpos,x				;list position
	beq .rtlx						;at the top: done
	sta.b d1
.loopx:								; loop: if plus go to .rtlx, ...
	ldy.b d1
	lda.w OOlist-1,y				; next object down the list
	and.w #$00FF
	tay
	lda.b d3
	sec
	sbc.w Ylist,y					; y of X minus its y
	sec
	sbc.w #$000E					;minus 14
	bpl .rtlx						;too far in y: done
	lda.w position,y				;on the ice?
	bmi .1x							;no: skip
	lda.w Xpos,y					; its x
	sec
	sbc.b d2						; minus the x of X
	cmp.w #$FFF1					;within 15 left?
	bmi .1x							;no: skip
	cmp.w #$000F					;within 15 right?
	bpl .1x							;no: skip
	lda.w pflags,y					;no-clip
	and.w #$8000
	ora.w pfnc,y					;or no-collision
	bne .1x							;set: skip
	cpy.w #$0018					;a player?
	bcs .1x							;no: skip
	jsl.l .t3						;collide X with Y
.1x:								; decrement d1, if d1 not yet 0 go to .loopx
	dec.b d1						;next
	bne .loopx
.rtlx:								; return
	rtl

.t3:								; subroutine: a2 = Y, d2 = Xpos,y - Xpos,x, d3 = Ypos,y - Ypos,x, ...
	lda.b d0
	pha								;keep the work registers
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d3
	pha
	lda.b d4
	pha
	lda.b d5
	pha
	sty.b a2						;other player
	lda.w Xpos,y
	sec
	sbc.w Xpos,x					;minus X's x
	sta.b d2						;dx
	lda.w Ypos,y
	sec
	sbc.w Ypos,x					;minus X's y
	sta.b d3						;dy
	ldy.b d2
	jsl.l ApproxLength				; A = the approximate length of the vector
	cmp.w #$0010					;touching (under 16)?
	bmi .t1x						;yes
	jmp.w .10						;no: done

.t1x:								; d0 = Xvel,x - Xvel,y, d1 = Yvel,x - Yvel,y, ora d1, ...
	ldy.b a2
	lda.w Xvel,x
	sec
	sbc.w Xvel,y					;relative x speed
	sta.b d0
	lda.w Yvel,x
	sec
	sbc.w Yvel,y					;relative y speed
	sta.b d1
	lda.b d0
	ora.b d1						;moving at all?
	bne .t2x						;yes
	jmp.w .10						;no: done

.t2x:								; call Mul16x8S, d1+2 = r2+2, d1 = r2, ...
	lda.b d1
	pha
	lda.b d0
	pha
	lda.b d3
	ldx.b d1						;dy
	jsl.l Mul16x8S					;times the relative y speed
	lda.b r2+2
	sta.b d1+2
	lda.b r2
	sta.b d1
	lda.b d2						;dx
	ldx.b d0						;times the relative x speed
	jsl.l Mul16x8S
	ldx.b a3						;X
	lda.b r2
	clc
	adc.b d1						;plus
	sta.b d1						;closing speed (dot product)
	lda.b r2+2
	adc.b d1+2
	sta.b d1+2						;high word
	bpl .t1xx						;closing: collide
	jmp.w .11						;moving apart: done

.t1xx:								; if SPA,x < SPAHold2 go to .2, ...
	lda.w SPA,x						;X's animation
	cmp.w #SPAHold2					;a hold?
	bcc .2
	cmp.w #$F46B					;a hold?
	bcs .2
	stz.w pfalock,x					;X lets go
	stz.w pf2aip,x
	ldy.w impactp,x					;the one he held
	lda.w SPA,y						;his animation
	cmp.w #SPAHold2					;held too?
	bcc .1x2
	cmp.w #$F46B					;held too?
	bcs .1x2
	lda.w #$0000
	sta.w pfalock,y					;he is let go
	sta.w pf2aip,y
.1x2:								; falls through
	ldy.b a2						;other player
.2:									; if SPA,y < SPAHold2 go to .4, ...
	lda.w SPA,y						;Y's animation
	cmp.w #SPAHold2					;a hold?
	bcc .4
	cmp.w #$F46B					;a hold?
	bcs .4
	lda.w #$0000					;Y lets go
	sta.w pfalock,y
	sta.w pf2aip,y
	ldx.w impactp,y					;the one he held
	lda.w SPA,x						;his animation
	cmp.w #SPAHold2					;held too?
	bcc .3
	cmp.w #$F46B					;held too?
	bcs .3
	stz.w pfalock,x					;he is let go
	stz.w pf2aip,x
.3:									; falls through
	ldx.b a3						;X back
.4:									; d1 = d1+1, if pfteam,x = pfteam,y go to .9, ...
	lda.b d1+1						;closing speed / 256
	sta.b d1
	lda.w pfteam,x					;X's team
	cmp.w pfteam,y					;team mates?
	beq .9							;yes: no hit
	lda.b d1
	lsr a							;/16
	lsr a
	lsr a
	lsr a
	cmp.w #$0005					;at least 5
	bcs .5
	lda.w #$0005					;floor 5
.5:									; d4 = A, if SPA,x < SPAsweepchk go to .7, ...
	sta.b d4						;d4 = hit strength
	lda.w SPA,x						;X's animation
	cmp.w #SPAsweepchk				;sweep check?
	bcc .7							;no
	cmp.w #$F343					;sweep check?
	bcs .7							;no
.6:									; d4 = d4 / 2 + d4, go to .8
	lda.b d4						;strength
	lsr a							;half
	adc.b d4						;plus: x1.5
	sta.b d4
	bra .8
.7:									; if SPA,y < SPAsweepchk go to .8, ...
	lda.w SPA,y						;Y's animation
	cmp.w #SPAsweepchk				;sweep check?
	bcc .8
	cmp.w #$F343					;sweep check?
	bcc .6							;yes: x1.5
.8:									; impact,x = d4 + impact,x, impact,y = d4 + impact,y, impactp,y = X, ...
	lda.b d4						;strength
	clc
	adc.w impact,x					;plus X's impact
	sta.w impact,x					;impact,x
	lda.b d4						;strength
	clc
	adc.w impact,y					;plus Y's impact
	sta.w impact,y					;impact,y
	txa
	sta.w impactp,y					;Y was hit by X
	tya
	sta.w impactp,x					;X was hit by Y
	lda.b d4
	cmp.w #$0014					;hard hit (20+)?
	bcc .2x							;no: no sound
	cpx.w puckc						;X carries the puck?
	beq .1xx						;yes: sound
	cpy.w puckc						;Y carries the puck?
	bne .2x							;no: no sound
.1xx:								; call CollisionSfx
	jsl.l CollisionSfx				;collision sound
.2x:								; call checkint, call checkcheck, d3 = pulled value, ...
	lda.b d1
	pha
	lda.b d2
	pha
	lda.b d3
	pha
	jsl.l checkint					;goalie contact
	jsl.l checkcheck				;check outcomes
	pla
	sta.b d3
	pla
	sta.b d2
	pla
	sta.b d1
.9:									; d4 = d1, d0 = pulled value, d1 = pulled value, ...
	lda.b d1						;closing speed
	sta.b d4						;d4
	pla
	sta.b d0						;relative x speed
	pla
	sta.b d1						;relative y speed
	lda.w collflag					;collision already handled?
	bpl .t1xxx						;no: bounce
	jmp.w .10						;yes: done

.t1xxx:								; collflag >= 0: call Mul16x8S, d1+2 = r2+2, d1 = r2, ...
	lda.b d2						;dx
	ldx.b d1						;times the relative y speed
	jsl.l Mul16x8S
	lda.b r2+2
	sta.b d1+2
	lda.b r2
	sta.b d1
	lda.b d3						;dy
	ldx.b d0						;times the relative x speed
	jsl.l Mul16x8S
	lda.b r2
	sec
	sbc.b d1						;minus
	sta.b d1						;cross product
	lda.b r2+2
	sbc.b d1+2
	sta.b d1+2
	lda.b d1+1						;/256
	sta.b d5						;d5 = sideways speed
	ldx.b a3
	lda.w weight,x					;X's weight
	clc
	adc.w #$008C					;plus 140
	sta.b d0						;d0
	ldy.b a2
	lda.w weight,y					;Y's weight
	clc
	adc.w #$008C					;plus 140
	sta.b d1
	lda.b d1						;sum
	clc
	adc.b d0						;plus X's
	sta.b d1						;d1 = total mass
	lda.b d0						;X's mass
	ldx.b d4						;times the closing speed
	jsl.l Mul16x8XS
	lda.b d1
	sta.b r1						;divided by
	jsl.l Div32S					;the total mass
	lda.b r0
	sta.b d0						;d0 = share of X
	sta.b d1						;d1
	lda.b d3
	ldx.b d5						;sideways speed
	jsl.l Mul16x8S					;times dy
	lda.b r2
	sta.b tmp0
	lda.b d2						;dx
	ldx.b d0						;times the share
	jsl.l Mul16x8S
	lda.b r2
	clc
	adc.b tmp0						;plus
	ldx.b a3
	clc
	adc.w Xvel,y					;X's new x speed
	sta.w Xvel,x
	lda.b d2						;dx
	ldx.b d5						;times the sideways speed
	jsl.l Mul16x8S
	lda.b r2
	sta.b tmp0
	lda.b d3						;dy
	ldx.b d0						;times the share
	jsl.l Mul16x8S
	lda.b r2
	sec
	sbc.b tmp0						;minus
	ldx.b a3
	clc
	adc.w Yvel,y					;plus Y's y speed
	sta.w Yvel,x					;X's new y speed
	lda.b d2						;dx
	ldx.b d1						;times the share
	jsl.l Mul16x8S
	lda.b r2
	clc
	adc.w Xvel,y					;plus Y's x speed
	sta.w Xvel,y					;Y's new x speed
	lda.b d3						;dy
	ldx.b d1						;times the share
	jsl.l Mul16x8S
	lda.b r2
	clc
	adc.w Yvel,y					;plus Y's y speed
	sta.w Yvel,y					;Y's new y speed
	ldx.b a3
	lda.w #$FFFF					;handled
	sta.w collflag					;once this frame
.10:								; d5 = pulled value, d4 = pulled value, d3 = pulled value, ...
	pla								;restore the work registers
	sta.b d5
	pla
	sta.b d4
	pla
	sta.b d3
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0
	rtl
.11:								; go to .10
	pla								;drop the pushed speeds
	pla
	bra .10
