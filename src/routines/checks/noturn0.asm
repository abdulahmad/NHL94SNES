; The wanted direction needs no turn
;
; Takes player X; d0 = wanted minus facing (times 2), d2 = wanted direction. Entered from
; doplayeracc when the turn step is 0: skates, stops when moving against the facing or turns one step.
;
; Called from doplayeracc.
noturn0:							; direction needs no turn: skate, stop or turn one step
	lda.w #$0002					; d4 = 2, 6 skating backwards
	sta.b d4						; backwards?
	lda.w pfrev,x
	beq .1
	lda.w #$0006					; d4 = 6
	sta.b d4
	lda.b d0
	eor.w #$0008					; flip the direction
	sta.b d0
.1:									; d0: 0 = facing the wanted direction
	lda.b d0
	beq .t3							; facing the wanted way: .t3
	lda.w Xvel,x					; moving: stop if the direction is more than 90 degrees off
	sta.b d0
	lda.w Yvel,x					; Y velocity
	sta.b d1
	jsl.l vtoa						; vector to direction
	bit.w #$0008					; no direction?
	bne .t2							; yes: turn one step
	sec								; minus the facing
	sbc.w facedir,x
	clc
	adc.b d4						; plus d4
	and.w #$0007
	sta.b d0
	cmp.w #$0004					; 90 degrees or more off?
	bcs .t2							; yes: turn one step
	jmp.w dostop					; close: stop

.t2:								; turn one step (the way depends on attribute bit 3)
	inc.w facedir,x					; turn one step
	lda.w attribute,x				; attribute
	bit.w #$0800
	beq .1x
	dec.w facedir,x
	dec.w facedir,x
.1x:								; wrap the facing to 0-7
	lda.w facedir,x					; facing
	and.w #$0007
	sta.w facedir,x
	lda.w #SPAglide					; glide
	sta.b d1
	lda.w pfrev,x					; backwards?
	bne .t1
	jmp.w SetSPA

.t1:								; backwards: glide back, y = 1
	ldy.w #$0001
	lda.w #SPAglideback
	jml.l SetSPAFromA

.t3:								; skate: pf2aip flag in y
	ldy.w #$0001
	lda.w #SPAskateback				; no change: skate
	sta.b d1
	lda.w pfrev,x					; backwards?
	bne .2
	ldy.w #$0000
	lda.w #SPAskate					; skate
	sta.b d1
	lda.w pflags,x					; pflags $0004 (pflags2 bit 6): stumble
	bit.w #pf2inj					; injured?
	beq .1x2
	ldy.w #$0001
	lda.w #SPAstumble
	sta.b d1
.1x2:								; puck carrier?
	cpx.w puckc
	bne .2
	ldy.w #$0000
	lda.w #SPAskatewp
	sta.b d1
.2:									; start the animation unless one runs
	lda.w pf2aip,x					; animation in progress?
	bne revplayeracc				; yes: accelerate
	tya								; pf2aip = y
	sta.w pf2aip,x
	jsl.l SetSPA					; start animation d1

; Takes player X, d2 = direction. Flips d2 when X skates backwards and goes on to playeracc.
;
; Falls in from noturn0, also called from doplayeracc.
revplayeracc:						; accelerate: reverse the direction when skating backwards
	lda.w pfrev,x					; backwards?
	beq .1
	lda.b d2						; yes: d2 = opposite direction
	eor.w #$0004
	sta.b d2
.1:									; accelerate in direction d2
	jml.l playeracc					; accelerate toward d2
