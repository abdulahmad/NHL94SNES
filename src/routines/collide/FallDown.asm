; Player a2 falls or stumbles from a hit
FallDown:							; called from Bcheck, checkcheck, checkint, puckbody
	lda.w CwdExciteLvl				;crowd excitement
	clc
	adc.w #$000F					;plus 15
	bmi .1							;overflow: keep
	sta.w CwdExciteLvl				;crowd excitement +15
.1:									;the player falls
	ldy.b a2						;the player hit
	cpy.w #$0018					;a player?
	bcs .t1							;not a player: done
	lda.w SPA,y						;his animation
	cmp.w #SPAinjury1				;injured: done
	beq .t1
	cmp.w #SPAstumble				;already falling: done
	beq .t1							;stumbling?
	cmp.w #SPAfallfwd				;already falling: done
	beq .t1
	cmp.w #SPAfallback				;already falling: done
	beq .t1							;flipping?
	cmp.w #SPAflip					;already falling: done
	beq .t1
	lda.w #SPAstumble				;stumble
	sta.b d1						;stumble by default
	lda.w gmclock					;clock stopped?
	bne .t2							;clock stopped: fall
	lda.w stickhand,y				;stick handling
	cmp.w #$000C					;stick handling 12+?
	bcc .t2							;weak puck handler: fall
	lda.w nopuckb,y					;puck lockout
	bne .t2							;already cannot touch the puck: fall
	lda.w seed						;random roll
	and.w #$000F					;random 0-15
	adc.w #$000A					;plus 10
	sta.b d0						;random 10-25
	sec
	sbc.w impact,y					; minus the impact
	bmi .t2							;hit harder than the roll: fall
	lda.w #$003C					;60 frames
	sta.w nopuckb,y					;no puck for 60 frames
	jmp.w .21						;start the stumble

.t1:								; return
	rtl

.t2:								; if position,x = 0 go to .2, ...
	lda.w position,x
	beq .2
	stz.b a0
	lda.w pfteam,x
	beq .1x
	lda.w #$0002
	sta.b a0
.1x:								; if gmclock != 0 go to .2, ...
	lda.w gmclock
	bne .2
	ldy.b a0
	lda.w tmchecks,y				; team checks
	inc a
	sta.w tmchecks,y				; count it
.2:									; nopuck,y = $0078, d0 = Xpos,x - Xpos,y, d1 = Ypos,x - Ypos,y, ...
	ldy.b a2						; nopuck 120 for a2
	lda.w #$0078					; puck lockout 120
	sta.w nopuck,y
	lda.w Xpos,x					; direction from a2 to the hitter
	sec
	sbc.w Xpos,y					; minus x of a2
	sta.b d0
	lda.w Ypos,x					; y of the hitter
	sec
	sbc.w Ypos,y					; minus y of a2
	sta.b d1
	jsl.l vtoa						; vector to direction
	lda.w Xpos,y					;his x
	cmp.w #$0068					;right of $68?
	bpl .7							;near the right boards
	cmp.w #$FF98					;left of $-68?
	bmi .10							;near the left boards
	lda.w Ypos,y					;his y
	cmp.w #$0112					;past the front?
	bpl .5							;near the front boards
	cmp.w #$FEED					;behind the back?
	bmi .4							;near the back boards?
.3:									;open ice
	jmp.w .20						;open ice
.4:									;near the back boards
	jmp.w .17						;near the back boards
.5:									;near the front boards
	jmp.w .15						;near the front boards
.6:									;corner
	jmp.w .27						;corner: the corner fall
.7:									;near the right boards
	lda.w Ypos,y					;his y
	cmp.w #$00F0					;corner?
	bpl .6							;corner
	cmp.w #$FF0A					;corner?
	bmi .6							;corner
	lda.b d0						;direction to the hitter
	cmp.w #$0005					;directions 0-4?
	bcc .3							;not facing the boards: open ice
	lda.w #$0082					;right boards x
	sta.w Xpos,y					;against the right boards
	lda.w #$0000
	sta.w Xvel,y					;stop in x
.8:									;pick the side by his flip
	lda.w attribute,y				;attribute
	bit.w #$0800					;sprite flipped?
	bne .12							;flipped: left wall
.9:									;right wall
	lda.w #SPAboardright			;boards animation: right wall
	bra .13
.10:								;near the left boards
	lda.w Ypos,y					;his y
	cmp.w #$00F0					;corner?
	bpl .6							;corner
	cmp.w #$FF0A					;corner?
	bmi .6							;corner
	lda.b d0						;direction to the hitter
	dec a							;direction - 1
	cmp.w #$0003					;directions 1-3?
	bcs .3							;not facing the boards: open ice
	lda.w #$FF7E					;left boards x
	sta.w Xpos,y					;against the left boards
	lda.w #$0000
	sta.w Xvel,y					;stop in x
	lda.w Ypos,y					;his y
	cmp.w #$0058					;along the boards?
	bpl .11							;high: boards fall
	cmp.w #$FFA8					;middle zone?
	bpl .14							;in the middle: right side check
.11:								;pick the side by his flip
	lda.w attribute,y				;attribute
	bit.w #$0800					;sprite flipped?
	bne .9							;flipped: right wall
.12:								;boards animation: left wall
	lda.w #SPAboardleft				;boards on his left
.13:								;into the boards
	ldx.b a2						;the falling player
	sta.w pfalock,x					;lock the animation
	jsl.l SetSPAUpdate				;start it
	lda.w CwdExciteLvl				;crowd excitement
	clc
	adc.w #$000A					;plus 10
	bmi .1xx						;overflow: keep
	sta.w CwdExciteLvl				;crowd excitement
.1xx:								;the faller's bench cheers
	stz.w benchcheer				;no bench cheer
	ldy.b a2
	lda.w pfteam,y					;his team
	beq .2x							;home?
	lda.w #$0002					;visitors' bench
.2x:								; adc #$0006, call StartBenchCheer, benchrounds = $0002, ...
	clc
	adc.w #$0006					;bench 6 or 8
	jsl.l StartBenchCheer			;that bench cheers
	lda.w #$0002
	sta.w benchrounds				;two rounds
	ldx.b a3
	ldy.b a2
	jmp.w .24						;finish
.14:								; go to .26
	jmp.w .26
.15:								;near the front boards
	lda.w Xpos,y					;his x
	cmp.w #$0050					;corner?
	bpl .19							;corner: open ice
	cmp.w #$FFB0					;corner?
	bmi .19							;corner: open ice
	lda.b d0						;direction to the hitter
	inc a
	inc a
	and.w #$0007					;mod 8
	cmp.w #$0005					;facing the boards?
	bcc .20							;not toward the boards: open ice fall
	lda.w #$0128					;front boards y
	sta.w Ypos,y					;against the front boards
	lda.w #$0000
	sta.w Yvel,y					;stop in y
.16:								; go to .13
	lda.w #SPAboardfront			;boards animation: front wall
	bra .13
.17:								;near the back boards
	lda.w Xpos,y					;his x
	cmp.w #$0050					;corner?
	bpl .19							;in the corner: open ice
	cmp.w #$FFB0					;corner?
	bmi .19							;in the corner: open ice
	lda.b d0						;direction to the hitter
	inc a
	and.w #$0007					;mod 8
	cmp.w #$0003					;facing the boards?
	bcs .20							;not toward the boards: open ice fall
	lda.w #$FED8					;back boards y
	sta.w Ypos,y					;against the back boards
	lda.w #$0000
	sta.w Yvel,y					;stop in y
.18:								; go to .13
	lda.w #SPAboardback				;boards animation: back wall
	jmp.w .13
.19:								; go to .27
	jmp.w .27
.20:								;open ice: fall, the hitter's bench cheers
	ldy.b a3						;hitter
	lda.w pfteam,y					;team of the hitter
	beq .1xxx						;home hitter?
	lda.w #$0002					;visitors' bench
.1xxx:								;the hitter's bench
	inc a
	inc a
	jsl.l StartBenchCheer			;that bench cheers
	lda.w #$0002
	sta.w benchrounds				;two rounds
	lda.w #SPAfallback				; fall back
	sta.b d1
	ldy.b a2						; hit from the front: fall back
	lda.b d0						;direction to the hitter
	sec
	sbc.w facedir,y					;minus his facing
	inc a
	and.w #$0007					;mod 8
	cmp.w #$0003					; within 2 of the facing?
	bcc .21							;within one step: fall back
	lda.w #SPAfallfwd				; else fall forward
	sta.b d1						;fall forward
	lda.w facedir,y					;his facing
	and.w #$0003					;facing 0 or 4?
	bne .21							;not straight up or down: fall forward
	lda.w checking,x				; hitter's checking rating
	sec
	sbc.w #$000A					; minus 10
	bmi .21							;checking under 10: fall forward
	cpx.w #$0018
	bcs .21							;not a player: no flip
	lda.w #SPAflip					;big hit on a straight skater: flip
	sta.b d1						;flip
.21:								; pfalock,x = $0001, call SetSPA, if position,x != 0 go to .24, ...
	ldx.b a2						;the falling player
	lda.w #$0001					; pfalock
	sta.w pfalock,x
	jsl.l SetSPA					; start animation d1
	ldx.b a3
	lda.w position,x				;goalie hit?
	bne .24
	cpx.w #$0018					;(the test is not used)
	bcs .24
	bra .24
.22:								; go to CollisionSfx
	jmp.w CollisionSfx				; play the collision sound
.23:								; go to .25
	jmp.w .25
.24:								;crowd reaction, then the injury check on the carrier
	lda.l Crowdlevel				;crowd level
	clc
	adc.w #$012C
	sta.l Crowdlevel				;crowd +300
	lda.w #$002D					;45 frames
	sta.b crowdhold					;crowd hold 45
	lda.w puckc						;puck carrier
	sta.b d0						;carrier
	bmi .22							;loose puck: sound only
	cpy.b d0						;faller had the puck?
	bne .22							;not the carrier: sound only
	lda.w gmode						;game mode
	bit.w #gmhl						;highlight?
	bne .23							;highlight: no injury
	lda.l OptPlayMode				;play mode
	cmp.w #$0004					;shootout?
	beq .23							;shootout: no injury
	lda.w position,x				;position of the hitter
	beq .23							;goalie hitter: no injury
	lda.w SPA,y						;his animation
	cmp.w #SPAfallback				;fell back?
	bne .23							;not falling back: no injury
	lda.w facedir,y					;his facing
	and.w #$0003					;facing 0 or 4?
	bne .23							;not facing straight: no injury
	lda.w pflags,y					;flags
	bit.w #pf2pen					;caused a penalty?
	bne .23							;already injured: no
	lda.w #$0096					;150
	jsl.l randoma8					;random 0-149
	asl a							;random 0-298
	ldy.b a2						;faller
	sec
	sbc.w impact,y					;minus the impact
	bpl .23							;hit too small: no injury
	lda.w gmclock					;clock stopped?
	bne .23							;clock stopped: no injury
	lda.w position,y				;his position
	bmi .25							;no position: no injury
	beq .25							;goalie: no injury
	lda.w #$FFFF					;none
	sta.w puckc						;puck loose
	stz.w benchcheer				;no bench cheer
	ldy.b a2						;faller
	lda.w pfteam,y					;team
	beq .1xxxx						;home?
	lda.w #$0002					;visitors
.1xxxx:								; adc #$0006, call StartBenchCheer, call SetSPAFromA, ...
	clc
	adc.w #$0006					;bench 6 or 8
	jsl.l StartBenchCheer			;the faller's bench reacts
	ldx.b a2						;the faller
	lda.w #SPAinjury1				;injury animation
	jsl.l SetSPAFromA				;start it
	ldx.b a3						;hitter
	lda.w Xvel,x					;reverse the hitter's x speed
	eor.w #$FFFF					;reverse
	inc a
	cmp.w #$8000					;half
	ror a							;half
	sta.w Xvel,x					;hitter bounces back
	lda.w Yvel,x					;reverse the hitter's y speed
	eor.w #$FFFF					;reverse
	inc a
	cmp.w #$8000					;half
	ror a							;half
	sta.w Yvel,x					;hitter bounces back
	jsl.l setInjuryType				;pick the injury
	lda.w #$0004					;4
	sta.w InjCntDown				;injury countdown
	lda.w #$0016					;penalty $16
	sta.b d0						;penalty $16 (injury)
	lda.w CwdExciteLvl				;crowd excitement
	clc
	adc.w #$001E					;plus 30
	bmi .2xx						;overflow: keep
	sta.w CwdExciteLvl				;crowd excitement
.2xx:								;the penalty
	lda.w position,x				;hitter's position
	bne .t2x						;goalie?
	jmp.w AddPenalty2				;goalie hit: the injury stoppage

.t2x:								;skater hit: roughing if penalties are on
	lda.l OptPen					;penalty option
	bne .t1x						;penalties on?
	jmp.w AddPenalty2				;penalties off: injury stop

.t1x:								;penalties on: roughing
	lda.w #PenRoughing2				;roughing
	sta.b d0
	jsl.l AddPenalty2				;call it
	jmp.w Stop4Pen					;stop play
.25:								;no injury: crowd reaction
	ldy.b a2						;the faller
	lda.w SPA,y						;his animation
	cmp.w #SPAstumble				;stumbling?
	beq .1xxxxx						;stumble: keeps the puck
	lda.w #$FFFF					;no puck carrier
	sta.w puckc						;puck loose
.1xxxxx:							;home player fell: groan
	ldy.b a2						;the faller
	lda.w pfteam,y					;team of the faller
	bne .t1xx						;visitors?
	lda.w #$0003					;sound 3
	jsl.l StreamSfx					;request it
	rtl

.t1xx:								;visitors fell: the crowd roars
	lda.l Crowdlevel				;crowd level
	clc
	adc.w #$0258
	sta.l Crowdlevel				;crowd +$258
	lda.w #$002D
	sta.b crowdhold					;crowd hold 45
	rtl
.26:								;hit at the bench: crowd +10
	lda.w CwdExciteLvl				;crowd excitement
	clc
	adc.w #$000A					;plus 10
	bmi .1xxxxxx					;overflow: keep
	sta.w CwdExciteLvl				;crowd excitement
.1xxxxxx:							;into the bench
	ldx.b a2						;the faller
	lda.w #$FF7E					;bench boards x
	sta.w Xpos,x					;against the bench boards
	lda.w #$0000
	sta.w Xvel,x					;stop in x
	lda.w attribute,x				;attribute
	bit.w #$0800
	bne .t1xxx						;flipped?
	lda.w #SPAbenchcheckl			;left
	bra .2xxx

.t1xxx:								;flipped: right
	lda.w #SPAbenchcheckr			;right
.2xxx:								;bench check animation
	sta.w pfalock,x					;lock the animation
	jsl.l SetSPAFromA				;start it
	ldx.b a3						;the hitter
	ldy.b a2						;the faller
	jmp.w .24						;finish
.27:								;hit in a corner: fall along the curve
	lda.b d0
	sta.b d5						;direction to the hitter
	lda.w Xpos,y
	sta.b d2						;his x
	lda.w Ypos,y
	sta.b d3						;his y
	ldx.w #$0048					;corner centre x $48
	ldy.w #$00EA					;corner centre y $EA
	lda.b d2						;his x
	bpl .1xxxxxxx					;right corner
	ldx.w #$FFB8					;left corner
.1xxxxxxx:							; if d3 >= 0 go to .2xxxx, ...
	lda.b d3						;his y
	bpl .2xxxx						;top corner
	ldy.w #$FF16					;bottom corner
.2xxxx:								; d0+2 = X, d1+2 = Y, d0 = d2 - d0+2, ...
	stx.b d0+2						;corner x
	sty.b d1+2						;corner y
	lda.b d2
	sec
	sbc.b d0+2						;dx to the corner centre
	sta.b d0
	lda.b d3
	sec
	sbc.b d1+2						;dy to the corner centre
	sta.b d1
	ldy.b d0
	jsl.l ApproxLength				;distance to the corner centre
	ldy.b a2
	sta.b d4						;distance
	cmp.w #$0014					;within 20 of the curve?
	bcs .t1xxxx						;off the curve: corner fall
	ldx.b a3						;hitter
	jmp.w .20						;open ice fall

.t1xxxx:							;push along the curve
	lda.b d0
	xba
	tax								;dx, high byte
	lda.b d4						;length
	jsl.l DivX8S					;dx / length
	lsr a
	lsr a							;scale
	bit.w #$2000
	beq .1xxxxxxxx
	ora.w #$C000					;sign extend
.1xxxxxxxx:							; d0 = A, if zero go to .2xxxxx, ...
	sta.b d0						;unit dx
	bit.w #$8000
	beq .2xxxxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xxxxx:							; d2+2 = A, xba, call DivX8S, ...
	sta.b d2+2						;|dx|
	lda.b d1
	xba
	tax								;dy, high byte
	lda.b d4						;length
	jsl.l DivX8S					;dy / length
	ldx.b a3
	lsr a							;scale
	lsr a
	bit.w #$2000
	beq .3x
	ora.w #$C000					;sign extend
.3x:								; d1 = A, if zero go to .4x, ...
	sta.b d1						;unit dy
	bit.w #$8000
	beq .4x
	eor.w #$FFFF					; negate: two's complement
	inc a
.4x:								; if carry set go to .30, ...
	cmp.b d2+2						;|dy| against |dx|
	bcs .30							;more in y: the end-boards case
	lda.b d0+2						;which corner side?
	bpl .29							;right corner
	lda.b d5						;direction to the hitter
	dec a							;direction - 1
	cmp.w #$0003					;directions 1-3?
	bcs .28							;not toward the curve: open ice
	lda.b d0
	clc
	adc.w #$0006					;plus 6
	clc
	adc.b d0+2						;plus the corner x
	sta.w Xpos,y					;pushed out of the corner in x
	lda.b d1
	clc
	adc.b d1+2						;plus the corner y
	sta.w Ypos,y					;on the curve in y
	lda.w #$0000
	sta.w Xvel,y
	sta.w Yvel,y					;stopped
	jmp.w .11						;left boards animation
.28:								; go to .20
	jmp.w .20
.29:								;right corner
	lda.b d5						;direction to the hitter
	cmp.w #$0005					;directions 0-4?
	bcc .28							;not toward the curve: open ice
	lda.b d0
	sec
	sbc.w #$0006					;minus 6
	clc
	adc.b d0+2
	sta.w Xpos,y					;on the curve in x
	lda.b d1
	clc
	adc.b d1+2
	sta.w Ypos,y					;on the curve in y
	lda.w #$0000
	sta.w Xvel,y
	sta.w Yvel,y					;stopped
	jmp.w .8						;right boards animation
.30:								;end-boards side of the corner
	lda.b d1+2						;corner y
	bpl .t1xxxxx					;front corner?
	lda.b d5						;direction to the hitter
	inc a
	and.w #$0007
	cmp.w #$0003					;directions 0-1, 7?
	bcs .28							;not toward the curve: open ice
	lda.b d0
	clc
	adc.b d0+2
	sta.w Xpos,y					;on the curve in x
	lda.b d1
	clc
	adc.b d1+2
	sta.w Ypos,y					;on the curve in y
	lda.w #$0000
	sta.w Xvel,y
	sta.w Yvel,y					;stopped
	jmp.w .18						;back boards animation

.t1xxxxx:							;front corner
	lda.b d5						;direction to the hitter
	inc a
	inc a
	and.w #$0007
	cmp.w #$0005					;directions 4-6?
	bcc .28							;not toward the curve: open ice
	lda.b d0
	clc
	adc.b d0+2
	sta.w Xpos,y					;on the curve in x
	lda.b d1
	clc
	adc.b d1+2
	sta.w Ypos,y					;on the curve in y
	lda.w #$0000
	sta.w Xvel,y
	sta.w Yvel,y					;stopped
	jmp.w .16						;front boards animation
