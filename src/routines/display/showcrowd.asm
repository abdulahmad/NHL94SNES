; Draw the crowd sprites
showcrowd:							; called from setvideo
	lda.w sflags					;flags
	and.w #$0800					;replay?
	beq .t1							;no
	lda.w replaynewframe			;new replay frame?
	bne .t1							;yes: draw
	rtl

.t1:								; call UpdateHatTrick, if HomeTeam != $0013 go to .2, ...
	jsl.l UpdateHatTrick			;hats
	ldx.w #$0022					;last crowd group
	lda.w HomeTeam					;home team
	cmp.w #$0013					;team $13?
	bne .2							;no
	lda.w crowdanim+$28				;its special group running?
	bne .1							;yes
	lda.w cursong					;song
	cmp.w #$0002					;song 2?
	bne .2							;no
.1:									; falls through
	ldx.w #$0028					;start from the special group
.2:									; r2 = X, if zero go to .1x, ...
	stx.b r2						;group
	cpx.w #$0000					;group 0?
	beq .1x
	cpx.w #$000A					;group 5?
	bne .t2							;no
.1x:								; if crowdanim+$28 = 0 go to .t2, ...
	lda.w crowdanim+$28				;special group running?
	beq .t2							;no
	jmp.w .5						;yes: skip these

.t2:								; p1 = long CrowdAnimTable,x, if crowdanim,x = 0 go to .t1x, ...
	lda.w #CrowdAnimTable>>16
	sta.b p1+2
	lda.l CrowdAnimTable,x			;group's data
	sta.b p1
	lda.w crowdanim,x				;running?
	beq .t1x						;no: start?
org $9BA000
	jmp.w .9						;yes: step it

.t1x:								; crowdanim,x = 0: if zero go to .5, ...
	cpx.w #$0026					;group $13?
	beq .5							;skip
	cpx.w #$0024					;group $12?
	beq .5							;skip
	cpx.w #$0022					;group $11 (top net)?
	beq .4							;puck check
	cpx.w #$0020					;group $10 (bottom net)?
	beq .6							;puck check
	cpx.w #$0028					;special group?
	beq .3							;start it
	ldy.w #$0008					;level needed
	lda.b [p1],y
	asl a							;x64
	asl a
	asl a
	asl a
	asl a
	asl a
	cmp.l Crowdlevel				;crowd loud enough?
	beq .1xx
	bcs .5							;no
.1xx:								; call RandomWord, and #$03F0, if not zero go to .5
	jsl.l RandomWord				;random
	and.w #$03F0					;1 in 64
	bne .5							;not yet
.3:									; crowdanim,x = $000A, crowdanimstep,x = 0, p0 = [p1],y, ...
	lda.w #$000A					;animation $A
	sta.w crowdanim,x				;start it
	tay								;entry $A
	stz.w crowdanimstep,x			;first step
	lda.b [p1],y					;its steps
	sta.b p0						;p0
	lda.w #CrowdAnimTable>>16
	sta.b p0+2
	bra .7
.4:									;puck height
	lda.w puckz						;high (26+)?
	cmp.w #$001A					;no
	bmi .5
	asl a							;x2
	adc.w puckz						;x3
	clc
	adc.w pucky						;plus y
	cmp.w #$FEB8					;over the glass?
	bpl .5							;no
	cmp.w #$FEB0					;behind the end?
	bmi .5							;no
	lda.w puckx						;puck x
	cmp.w #$FFF4					;right of it?
	bpl .5							;no
	cmp.w #$FFEC					;left of it?
	bmi .5							;no
	bra .3							;the fans react
.5:									; go to .8
	jmp.w .8
.6:									; if puckz - $001A negative go to .5, ...
	lda.w puckz						;puck height
	cmp.w #$001A					;high?
	bmi .5							;no
	asl a							;x2
	adc.w puckz						;x3
	clc
	adc.w pucky						;plus y
	cmp.w #$FE98					;over the far glass?
	bpl .5							;no
	cmp.w #$FE90					;behind it?
	bmi .5							;no
	lda.w puckx						;puck x
	cmp.w #$FFFD					;right of it?
	bpl .5							;no
	cmp.w #$FFF4					;left of it?
	bmi .5							;no
	bra .3							;the fans react
.7:									; crowdanimtime,x = [p1],y * 2 + [p1],y, if [p0],y negative go to .5, ...
	ldy.w #$0006
	lda.b [p1],y					;step time
	asl a
	adc.b [p1],y					;x3
	sta.w crowdanimtime,x			;timer
	ldy.w crowdanimstep,x			;step
	lda.b [p0],y					;tile set of the step
	bmi .5							;end: stop
	tax
	lda.b [p1]						;tiles per set
	jsl.l Mul8U						;times the set
	ldy.w #$0004					;first tile
	clc
	adc.b [p1],y					;plus it
	asl a
	asl a
	asl a
	asl a
	asl a							;x32 bytes
	clc
	adc.w #CrowdTiles
	sta.b p0						;source
	lda.w #CrowdTiles>>16
	sta.b p0+2
	ldy.w #$0002
	lda.b [p1],y					;VRAM tile
	asl a
	asl a
	asl a
	asl a							;x16
	clc
	adc.w #$1000					;plus the BG char base
	tay								;destination
	lda.b [p1]						;tiles
	asl a
	asl a
	asl a
	asl a
	asl a							;x32 bytes
	tax								;size
	jsl.l DMAToVRAM					;send the tiles
	ldx.b r2						;group
	cpx.w #$0028					;special group?
	bne .8							;no
	lda.w crowdanim+$26				;group $13 running?
	bne .8							;yes
	lda.w #$000A					;start $12 and $13 too
	sta.w crowdanim+$24
	sta.w crowdanim+$26
	stz.w crowdanimtime+$24
	stz.w crowdanimtime+$26
.8:									;group
	ldx.b r2						;previous
	dex
	dex
	bmi .t1xx						;next group
	jmp.w .2

.t1xx:								; X counted below 0: return
	rtl
.9:									; crowdanimtime,x = crowdanimtime,x - timestep, if plus go to .8, ...
	lda.w crowdanimtime,x			;timer
	sec
	sbc.w timestep					;minus the frame time
	sta.w crowdanimtime,x			;timer
	bpl .8							;not yet
	ldy.w crowdanim,x				;animation
	lda.b [p1],y					;its steps
	sta.b p0
	lda.w #CrowdAnimTable>>16
	sta.b p0+2
	ldy.w crowdanimstep,x			;step
	lda.b [p0],y					;this step
	bmi .t1xxx						;end
	iny
	iny
	lda.b [p0],y					;next step
	bmi .t1xxx						;end
	tya								;step
	sta.w crowdanimstep,x			;saved
	jmp.w .7						;show it

.t1xxx:								; if crowdanim,x != $000E go to .t2x, ...
	lda.w crowdanim,x				;animation
	cmp.w #$000E					;$E (one shot)?
	bne .t2x						;no
	stz.w crowdanim,x				;stop
	bra .8

.t2x:								;group $12?
	cpx.w #$0024
	beq .1xxx						;group $13?
	cpx.w #$0026					;no
	bne .t1xxxx
.1xxx:								; crowdanim,x = crowdanim+$28, go to .2x
	lda.w crowdanim+$28				;follow the special group
	sta.w crowdanim,x
	bra .2x

.t1xxxx:							;idle $C already?
	cmp.w #$000C					;yes
	beq .3x							;idle animation $C
	lda.w #$000C
	sta.w crowdanim,x
.2x:								; p0 = long [p1],y, crowdanimstep,x = 0, ...
	ldy.w crowdanim,x				;animation
	lda.b [p1],y					;its steps
	sta.b p0
	lda.w #CrowdAnimTable>>16
	sta.b p0+2
	stz.w crowdanimstep,x			;first step
	jmp.w .7
.3x:								; call RandomWord, and #$00C0, if not zero go to .2x, ...
	jsl.l RandomWord
	and.w #$00C0
	bne .2x
	lda.w #$000E
	sta.w crowdanim,x
	bra .2x
