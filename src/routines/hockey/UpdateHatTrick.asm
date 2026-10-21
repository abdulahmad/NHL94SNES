; While hattrick is set (not in horizontal mode or a replay): launch and move the ten hat trick sprites on
; random arcs and draw them
UpdateHatTrick:						; called from showcrowd
	lda.w sfhormode					;horizontal rink?
	bne .rtl						;yes: no hats
	lda.w sflags					;flags
	and.w #$0800					;replay?
	bne .rtl						;yes: no hats
	lda.l hattrick					;hat trick on?
	bne .t1
.rtl:								; return
	rtl

.t1:								; hattrick != 0: falls through
	ldx.w #$0012					;last of 10 hats
.1:									; d4 = X, if hatstep,x = 0 go to .t3, ...
	stx.b d4
	lda.l hatstep,x					;hat state
	beq .t3							;not thrown yet
	jmp.w .7						;flying: move it

.t3:								; hatstep,x = 0: call RandomWord, and #$07C0, if zero go to .t1x, ...
	jsl.l RandomWord
	and.w #$07C0					;1 in 32 a frame
	beq .t1x						;throw it
	jmp.w .6						;not yet

.t1x:								; call RandomWord, and #$003F, d0 = A, ...
	jsl.l RandomWord
	and.w #$003F					;random 0-63
	sta.b d0						;d0
	lsr a							;half
	adc.b d0						;plus: x1.5
	clc
	adc.w #$0050					;plus 80
	asl a
	asl a
	asl a
	asl a							;x16
	sta.b d0						;landing x
	jsl.l RandomWord
	and.w #$003F					;random 0-63
	clc
	adc.w #$0060					;plus 96
	asl a
	asl a
	asl a
	asl a							;x16
	sta.b d1						;landing y
	jsl.l RandomWord
	and.w #$00FF					;random 0-255
	asl a
	asl a
	asl a
	asl a							;x16
	sta.l haty,x					;start y
	jsl.l RandomWord
	and.w #$003F					;random 0-63
	clc
	adc.w #$0078					;plus 120
	sta.b d2						;d2 = flight frames
	lda.b d1						;landing y
	sec
	sbc.l haty,x					;minus the start
	tax
	lda.b d2						;frames
	jsl.l DivX8S					;/ frames
	ldx.b d4
	sta.l hatvy,x					;y speed
	lda.b d0
	and.w #$0100					;which side?
	beq .t2							;left
	lda.w #$1100					;from the right edge
	sta.l hatx,x
	lda.b d0						;landing x
	sec
	sbc.w #$1100					;minus the start
	bra .2

.t2:								;from the left edge
	lda.w #$FF00
	sta.l hatx,x
	lda.b d0
	sec
	sbc.w #$FF00
.2:									;minus the start
	tax
	lda.b d2						;frames
	jsl.l DivX8S					;/ frames
	ldx.b d4
	sta.l hatvx,x					;x speed
	lda.b d2						;frames
	lsr a							;/4
	lsr a
	tax
	jsl.l Mul8U						;squared
	ldx.b d4
	sta.b d2						;d2
	asl a							;x2
	adc.b d2						;x3
	sta.l hatz,x					;start height
	jsl.l RandomWord				;random
	lsr a
	lsr a							;/4
	and.w #$0003					;0-3
	beq .1x							;0 stays 0
	dec a							;else 0-2
.1x:								; d2 = A, asl a, adc d2, ...
	sta.b d2						;kind
	asl a
	adc.b d2						;x3 frames
	sta.l hatkind,x					;hat kind
	lda.w #$0000
	sta.l hatvz						;no fall speed (only hat 0's slot)
	inc a							;step 1
	sta.l hatstep,x					;hat state
	lda.l .9,x						;frame time
	sta.l hattimer,x				;hat timer
.5:									; r0 = hatkind,x + hatstep,x + SPFhat-1-1, p1 = SpriteFrames, ...
	lda.l hatkind,x					;kind
	clc
	adc.l hatstep,x					;plus the step
	clc
	adc.w #SPFhat-1-1				;sprite
	sta.b r0
	lda.w #SpriteFrames>>16			;sprite frames
	sta.b p1+2
	lda.w #SpriteFrames
	sta.b p1
	lda.l hatz,x					;height
	lsr a							;/16
	lsr a
	lsr a
	lsr a
	eor.w #$FFFF					;negate
	inc a
	clc
	adc.l haty,x
	lsr a							;/16
	lsr a
	lsr a
	lsr a
	bit.w #$0800					;sign bit?
	beq .1xx
	ora.w #$F000					;sign extend
.1xx:								;screen y
	tay
	lda.l hatx,x					;x
	lsr a							;/16
	lsr a
	lsr a
	lsr a
	bit.w #$0800					;sign bit?
	beq .2x
	ora.w #$F000					;sign extend
.2x:								;screen x
	tax
	lda.w #$2000					;palette 0
	jsl.l DrawSprite				;draw the hat
	ldx.b d4						;hat
	lda.w #SPFhatshadow-1			;shadow sprite
	sta.b r0
	lda.l haty,x					;y
	lsr a							;/16
	lsr a
	lsr a
	lsr a
	bit.w #$0800					;sign bit?
	beq .3
	ora.w #$F000					;sign extend
.3:									;screen y
	tay
	lda.l hatx,x					;x
	lsr a							;/16
	lsr a
	lsr a
	lsr a
	bit.w #$0800					;sign bit?
	beq .4
	ora.w #$F000					;sign extend
.4:									;screen x
	tax
	lda.w #$2000					;palette 0
	jsl.l DrawSprite				;draw the shadow
.6:									; X - 1, X - 1, if X counted below 0 go to .t1xx, ...
	ldx.b d4						;hat
	dex
	dex
	bmi .t1xx						;all done
	jmp.w .1						;next hat

.t1xx:								; X counted below 0: return
	rtl
.7:									; if plus go to .t1xxx, ...
	lda.l hattimer,x				;timer
	sec
	sbc.w timestep					;minus the frame time
	bpl .t1xxx						;not yet
	clc
	adc.l .9,x						;plus the step time
	sta.l hattimer,x				;reload
	lda.l hatstep,x					;animation step
	inc a							;next
	cmp.w #$0004					;past 3?
	bne .1xxx						;no
	lda.w #$0001					;back to 1
.1xxx:								; hatstep,x = A, go to .8
	sta.l hatstep,x					;hat state
	bra .8

.t1xxx:								; hattimer,x = A
	sta.l hattimer,x				;timer
.8:									; if timestep = 0 go to .1xxxx
	ldy.w timestep					;frames to step
	beq .1xxxx						;none
.loop:								; loop: call .t3x, Y - 1, if Y not yet 0 go to .loop
	jsl.l .t3x						;one step of movement
	dey
	bne .loop						;all
.1xxxx:								;draw
	jmp.w .5

.t3x:								; subroutine: ora hatvy,x, if zero go to .rtlx, ...
	lda.l hatvx,x					;x speed
	ora.l hatvy,x					;or y speed
	beq .rtlx						;stopped: done
	lda.l hatx,x					;x
	clc
	adc.l hatvx,x					;plus the x speed
	sta.l hatx,x					;new x
	lda.l haty,x					;y
	clc
	adc.l hatvy,x					;plus the y speed
	sta.l haty,x					;new y
	lda.l hatz,x					;height
	beq .t2x						;landed
	lda.l hatvz,x					;fall speed
	lsr a							;/4
	lsr a
	bit.w #$2000					;sign bit?
	beq .1xxxxx
	ora.w #$C000					;sign extend
.1xxxxx:							; eor #$FFFF, increment a, adc hatz,x, ...
	eor.w #$FFFF					;negate
	inc a
	clc
	adc.l hatz,x					;plus the height
	bmi .t1xxxx						;below the ice
	sta.l hatz,x					;new height
	lda.l hatvz,x					;fall speed
	clc
	adc.w #$0006					;plus gravity 6
	sta.l hatvz,x					;faster
.rtlx:								; return
	rtl

.t1xxxx:							; hatz,x = $0000, return
	lda.w #$0000					;on the ice
	sta.l hatz,x
	rtl

.t2x:								; hatz,x = 0: hatvz,x = $0000, hatz,x = $0000, hattimer,x = $03E8, ...
	lda.w #$0000					;stop falling
	sta.l hatvz,x
	sta.l hatz,x					;on the ice
	lda.w #$03E8					;1000
	sta.l hattimer,x				;timer
	lda.l hatvx,x					;x speed
	cmp.w #$0010					;slow right?
	bcc .t1xxxxx
	cmp.w #$FFF0					;slow left?
	bcs .t1xxxxx					;yes
	lsr a							;/16
	lsr a
	lsr a
	lsr a
	bit.w #$0800					;sign bit?
	beq .1xxxxxx
	ora.w #$F000					;sign extend
.1xxxxxx:							; eor #$FFFF, increment a, adc hatvx,x, ...
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.l hatvx,x					;minus a sixteenth
	sta.l hatvx,x					;sliding x slows
	lda.l hatvy,x					;y speed
	lsr a							;/16
	lsr a
	lsr a
	lsr a
	bit.w #$0800					;sign bit?
	beq .2xx
	ora.w #$F000					;sign extend
.2xx:								; eor #$FFFF, increment a, adc hatvy,x, ...
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.l hatvy,x					;minus a sixteenth
	sta.l hatvy,x					;sliding y slows
	rtl

.t1xxxxx:							;slow: stop sliding
	lda.w #$0000
	sta.l hatvx,x
	sta.l hatvy,x
	rtl
.9:									;frames per animation step of each hat
	dw $0004,$0008,$0009,$000F,$000C,$000D,$000A,$0007,$000B,$000E
