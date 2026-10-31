; Instant replay
ReplayMode:							; called from PauseReplay
	lda.w SoundFadeSpeed			;wait for the sound fade
	bne ReplayMode					;still fading
	jsl.l SPCGameUpload				; upload the Game sample set
	lda.w #$0000
	sta.l Crowdlevel				;no crowd noise
	lda.w #$0800					;replay flag
	tsb.w sflags					;set it
	jsl.l ClrHor					; switch back from the horizontal rink to the vertical ice rink
	lda.w #$FFFF					;nothing dirty yet:
	sta.w textdirtylo				;low mark at the end
	stz.w textdirtyhi				;high mark at the start
	lda.l blankchar
	clc
	adc.l charofs					;in the text set
	ldx.w #$0400					;$400 words
	ldy.w #$0000					;from VRAM 0
	jsl.l FillVRAMSplit				; fill VRAM with the low bytes, then the high bytes
	lda.w #$FFFF
	sta.w replaylock				;no locked object
	sta.l replaypanel				;no panel
	lda.w #rinkmapbuf>>16
	sta.b p0+2
	lda.w #rinkmapbuf
	sta.b p0
	lda.w #$0020					;32 columns
	sta.b r7
	lda.w #$0055					;85 rows
	sta.b r7+2
	lda.w #$0008					;8 columns of view
	sta.b r4
	lda.w #$0008					;8 rows
	sta.b r4+2
	lda.w #$0000
	sta.w MapVRAM					;map at VRAM 0
	lda.w #$2000
	sta.b r3						;priority bit
	lda.l charofs
	ldx.w #$0002					;column 2
	ldy.w #$0002					;row 2
	jsl.l MapPartToVRAMOffset		; copy part of map [p0] into the screen map at column X, row Y
	lda.w recbpr
	pha								;keep the record pointer
	lda.w recbpr+2
	pha
	lda.w #$0020
	trb.w sflags					;clear the scroll lock
	lda.w Vpos
	pha								;keep the view
	lda.w Hpos
	pha
	lda.w recbpr
	cmp.w #replaystart				;pointer below the buffer?
	lda.w recbpr+2
	sbc.w #replaystart>>16
	bcs .1							;no
.loop:								; loop: recbpr+2 = $007E, recbpr = replaystart
	lda.w #replaystart>>16			;reset it to the start
	sta.w recbpr+2
	lda.w #replaystart
	sta.w recbpr
.1:									; if carry clear go to .loop, ...
	lda.w #replayend
	cmp.w recbpr					;past the end?
	lda.w #replayend>>16
	sbc.w recbpr+2
	bcc .loop						;yes: reset
	lda.w recbpr
	sec
	sbc.w #replaystart
	sta.b r2
	lda.w recbpr+2
	sbc.w #replaystart>>16
	sta.b r2+2
	lda.w #replaysize				;frame size
	sta.b r1
	jsl.l Div32U					;offset / frame size
	lda.b r2+2						;remainder?
	bne .loop						;misaligned: reset
	lda.w recbpr+2					;playback pointer = record pointer
	sta.b a4+2
	lda.w recbpr
	sta.b a4
	lda.w #$0000
	pha								;frame count
.loop2:								; loop: call suba4, if d7 != 0 go to .loop2, ...
	jsl.l suba4						;one frame back
	pla
	inc a							;count it
	pha
	lda.b d7						;reached the oldest?
	bne .loop2						;no
	pla
	lsr a							;halve the count
	pha								; 1,s = half the suba4 step count
.loop3:								; loop: if 1,s = 0 go to .t1, ...
	lda.b 1,s						;frames left
	beq .t1							;middle reached
	jsl.l adda4						; move the replay one frame forward
	pla								;one forward
	dec a
	pha
	bra .loop3

.t1:								; 1,s = 0: replayHpos = Hpos, replayVpos = Vpos, call InitSprites, ...
	pla
	lda.w Hpos
	sta.w replayHpos				;replay camera x
	lda.w Vpos
	sta.w replayVpos				;replay camera y
	ldx.w #$0000					;sprite chars from 0
	ldy.w #$01C0					;sprite table base
	lda.w #$6000					;at VRAM $6000
	jsl.l InitSprites
	stz.w brightness				;dark
	lda.w #$000A
	sta.w fadestep					;fade speed
	ldx.w #BrightnessHook>>16
	lda.w #BrightnessHook
	jsl.l SetFrameHook				; run the routine at X:A as the frame hook of the next NMI
	jsl.l ScreenOn					;screen on
	jsl.l SprSort					; sort the objects by screen position
	jsl.l SpriteFrameStart
	jsl.l setvideo					; once per game frame: build the sprite table for the next vblank
	jsl.l SpriteFrameEnd
	lda.w #$0001					;step 1
	sta.b d7
	lda.w #$0002					;pause flag
	trb.w sflags3
	jmp.w .13						;show the first frame
.10:								; if replaylock >= 0 go to .t2, ...
	lda.w replaylock				;camera locked on a player?
	bpl .t2							;yes: follow him
	jmp.w .7						;no: free camera

.t2:								; replaylock >= 0: Xpos+camobj = Xpos,x, if plus go to .t1x, ...
	tax								;the locked player
	lda.w Xpos,x
	sta.w Xpos+camobj				;camera at his x
	cmp.w replayHpos				;right of the view?
	bpl .t1x
	lda.w replayHpos				;view - 4
	sec
	sbc.w #$0004					;at most 4 a frame
	cmp.w Xpos+camobj				;still further?
	bpl .2							;yes: step 4
.1x:								; falls through
	lda.w Xpos+camobj				;close: his x
.2:									; go to .5
	bra .5

.t1x:								; if minus go to .5, ...
	lda.w replayHpos				;view + 4
	clc
	adc.w #$0004					;step 4
	cmp.w Xpos+camobj				;still further?
	bmi .5							;yes: step 4
	lda.w Xpos+camobj				;close: his x
.5:									; if plus go to .1xx, ...
	cmp.w #$FFC0					;left limit?
	bpl .1xx
	lda.w #$FFC0					;clamp
.1xx:								; if minus go to .2x, ...
	cmp.w #$0040					;right limit?
	bmi .2x
	lda.w #$0040					;clamp
.2x:								; Hpos = A, replayHpos = A, Ypos+camobj = Ypos,x, ...
	sta.w Hpos						;view x
	sta.w replayHpos
	lda.w Ypos,x					;his y
	sta.w Ypos+camobj				;camera y
	cmp.w replayVpos				;above the view?
	bpl .t1xx
	lda.w replayVpos				;view - 4
	sec
	sbc.w #$0004					;step 4
	cmp.w Ypos+camobj				;still further?
	bpl .4							;yes: step 4
.3:									; falls through
	lda.w Ypos+camobj				;close: his y
.4:									; go to .6
	bra .6

.t1xx:								; if minus go to .6, ...
	lda.w replayVpos				;view + 4
	clc
	adc.w #$0004					;step 4
	cmp.w Ypos+camobj				;still further?
	bmi .6							;yes: step 4
	lda.w Ypos+camobj				;close: his y
.6:									; if plus go to .2xx
	cmp.w #$FF39					;top limit?
	bpl .2xx
.1xxx:								; falls through
	lda.w #$FF39					;clamp
.2xx:								; if minus go to .4x
	cmp.w #$0100					;bottom limit?
	bmi .4x
.3x:								; falls through
	lda.w #$0100					;clamp
.4x:								; Vpos = A, replayVpos = A, PadControlObj+$C = X / 2, ...
	sta.w Vpos						;view y
	sta.w replayVpos
	txa								;object
	lsr a							;/2
	sta.w PadControlObj+$C			;the locked player gets the marker
	jmp.w .12						;draw

.7:									; if zero go to .11, ...
	cmp.w #$FFFF					;camera off?
	beq .11							;yes: keep the view
	lda.w Xpos+camobj				;free camera x
	cmp.w replayHpos				;right of the view?
	bpl .t2x
	lda.w replayHpos				;view - 2
	sec
	sbc.w #$0002					;step 2
	cmp.w Xpos+camobj				;still further?
	bpl .1xxxx						;yes: step 2
	lda.w Xpos+camobj				;close: camera x
.1xxxx:								; go to .8
	bra .8

.t2x:								; Xpos+camobj - replayHpos >= 0: if minus go to .8, ...
	lda.w replayHpos				;view + 2
	clc
	adc.w #$0002					;step 2
	cmp.w Xpos+camobj				;still further?
	bmi .8							;yes: step 2
	lda.w Xpos+camobj				;close: camera x
.8:									; if plus go to .1xxxxx, ...
	cmp.w #$FFC0					;left limit?
	bpl .1xxxxx
	lda.w #$FFC0					;clamp
.1xxxxx:							; if minus go to .2xxx, ...
	cmp.w #$0040					;right limit?
	bmi .2xxx
	lda.w #$0040					;clamp
.2xxx:								; Hpos = A, replayHpos = A, compare Ypos+camobj with replayVpos
	sta.w Hpos						;view x
	sta.w replayHpos
	lda.w Ypos+camobj				;free camera y
	cmp.w replayVpos				;above the view?
	bpl .t1xxx
	lda.w replayVpos				;view - 2
	sec
	sbc.w #$0002					;step 2
	cmp.w Ypos+camobj				;still further?
	bpl .3xx						;yes: step 2
	lda.w Ypos+camobj				;close: camera y
.3xx:								; go to .9
	bra .9

.t1xxx:								; Ypos+camobj - replayVpos >= 0: if minus go to .9, ...
	lda.w replayVpos				;view + 2
	clc
	adc.w #$0002					;step 2
	cmp.w Ypos+camobj				;still further?
	bmi .9							;yes: step 2
	lda.w Ypos+camobj				;close: camera y
.9:									; if plus go to .2xxxx
	cmp.w #$FF39					;top limit?
	bpl .2xxxx
.1xxxxxx:							; falls through
	lda.w #$FF39					;clamp
.2xxxx:								; if minus go to .4xx
	cmp.w #$0100					;bottom limit?
	bmi .4xx
.3xxx:								; falls through
	lda.w #$0100					;clamp
.4xx:								; Vpos = A, replayVpos = A, go to .12
	sta.w Vpos						;view y
	sta.w replayVpos
	bra .12
.11:								;view as is
	lda.w Hpos
	sta.w replayHpos
	lda.w Vpos
	sta.w replayVpos
.12:								; timestep = d7, call SprSort, call SpriteFrameStart, ...
	lda.b d7						;frames per step
	sta.w timestep					;frame time
	jsl.l SprSort					; sort the objects by screen position
	jsl.l SpriteFrameStart
	jsl.l setvideo					; once per game frame: build the sprite table for the next vblank
	jsl.l SpriteFrameEnd
	stz.w replaynewframe			;frame drawn
.13:								; if d7 != 0 go to .2xxxxx
	ldx.b d7						;frames to wait
	bne .2xxxxx						;some
.1xxxxxxx:							; X + 1
	inx
.2xxxxx:							; call WaitFrames_Inc, call ReadPads, call ReadPausePad, ...
	ldy.w #$0000
	jsl.l WaitFrames_Inc			;wait them
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l ReadPausePad				; ReadjoyA for the controller that owns the pause menu
	lda.w #$0001					;step 1
	sta.b d7
	lda.b d0						;direction held
	bit.w #$0008					;held?
	beq .t2xx
	jmp.w .16						;no: buttons

.t2xx:								; d0 bits $0008 clear: d5 = A, d4 = $FFFF, d4+2 = $FFFF, ...
	sta.b d5						;d5 = direction
	lda.w #$FFFF
	sta.b d4						;best distance none
	sta.b d4+2						;best angle none
	sta.w replaylock				;unlock
	lda.w #$0016
	sta.b a0						;from the last player
.loopx:								; loop: if position,y negative go to .4xxx, ...
	ldy.b a0
	lda.w position,y				;on the ice?
	bmi .4xxx						;no: skip
	lda.w Xpos,y
	sec
	sbc.w Xpos+camobj				;minus the camera x
	sta.b d0
	sta.b d2
	lda.w Ypos,y					;the camera
	sec
	sbc.w Ypos+camobj				;minus the camera y
	sta.b d1
	sta.b d3
	jsl.l vtoa						;direction from the camera
	cmp.w #$0008					;no direction?
	beq .4xxx						;yes: skip
	sec
	sbc.b d5						;minus the held direction
	beq .1xxxxxxxx					;straight ahead
	cmp.w #$0001					;one step off?
	beq .1xxxxxxxx
	cmp.w #$0007					;one step the other way?
	bne .4xxx						;no: skip
.1xxxxxxxx:							; if zero go to .2xxxxxx, ...
	lda.b d2
	lsr a							;dx / 8
	lsr a
	lsr a
	bit.w #$1000					;sign bit?
	beq .2xxxxxx
	ora.w #$E000					;sign extend
.2xxxxxx:							; call Mul8S, d0 = A, if zero go to .3xxxx, ...
	tax
	jsl.l Mul8S						;(dx/8)^2
	sta.b d0
	lda.b d3						;dy
	lsr a
	lsr a
	lsr a							;/8
	bit.w #$1000					;sign bit?
	beq .3xxxx
	ora.w #$E000					;sign extend
.3xxxx:								; call Mul8S, adc d0, if carry set go to .4xxx, ...
	tax
	jsl.l Mul8S						;(dy/8)^2
	clc
	adc.b d0						;squared distance
	cmp.b d4+2						;nearer than the best?
	bcs .4xxx						;no
	sta.b d4+2						;best distance
	lda.b a0
	sta.b d4						;best player
.4xxx:								; decrement a0, decrement a0, if a0 still >= 0 go to .loopx, ...
	dec.b a0
	dec.b a0						;next player
	bpl .loopx
	lda.b d4						;found one?
	bmi .t1xxxx						;no: move the free camera
	lda.b d4+2						;best distance
	cmp.w #$0002					;far (over 2)?
	bcs .t1xxxx						;yes: free camera
	lda.b d4
	sta.w replaylock				;lock on him
	lda.w #$001E					;30-frame step
	sta.b d7
	lda.w #$0020
	trb.w sflags					;unlock the scroll
	jmp.w .10

.t1xxxx:							; call ReadPausePad, replaylock = $FFFE, tsb sflags, ...
	phk								;data bank = program bank
	plb
	jsl.l ReadPausePad				; ReadjoyA for the controller that owns the pause menu
	lda.w #$FFFE					;free camera
	sta.w replaylock
	lda.w #$0020
	tsb.w sflags					;scroll lock on
	asl.b d0						;direction
	asl.b d0						;x4: word pair
	ldy.b d0
	lda.w .14,y						;x step
	adc.w Xpos+camobj				;plus the camera x
	sta.b d2						;new x
	ldx.w #camobj
	lda.w .14,y
	xba								;x step to a speed
	and.w #$FF00
	sta.w Xvel,x					;camera x speed
	lda.w .14+2,y					;y step
	clc
	adc.w Ypos+camobj				;plus the camera y
	sta.b d3						;new y
	lda.w .14+2,y
	xba
	and.w #$FF00					;y step to a speed
	sta.w Yvel,x					;camera y speed
	lda.b d2
	pha								;keep the new x
	lda.b d3
	pha								;and y
	stx.b a3						;camera object
	stz.w Wallcos,x					;no wall contact
	stz.w Wallsin,x
	lda.w #$0001
	sta.w wcradiusx					;tiny radius
	sta.w wcradiusy
	jsl.l checkwallcoll				;keep it inside the rink
	pla
	sta.b d3						;new y
	pla
	sta.b d2						;new x
	lda.w Wallsin,x
	ora.w Wallcos,x					;touched a wall?
	beq .4xxxx						;no
.1xxxxxxxxx:						; xba, and #$00FF, if carry clear go to .2xxxxxxx, ...
	lda.w Wallsin,x
	asl a							;wall push x
	xba
	and.w #$00FF					;signed byte
	cmp.w #$0080					;negative?
	bcc .2xxxxxxx
	ora.w #$FF00					;sign extend
.2xxxxxxx:							; adc Xpos+camobj, d2 = A, xba, ...
	clc
	adc.w Xpos+camobj				;plus the camera x
	sta.b d2						;pushed x
	lda.w Wallcos,x
	asl a							;wall push y
	xba
	and.w #$00FF					;signed byte
	cmp.w #$0080					;negative?
	bcc .3xxxxx
	ora.w #$FF00					;sign extend
.3xxxxx:							; eor #$FFFF, increment a, adc Ypos+camobj, ...
	eor.w #$FFFF					;reversed
	inc a
	clc
	adc.w Ypos+camobj				;plus the camera y
	sta.b d3						;pushed y
.4xxxx:								; Xpos+camobj = d2, Hpos = d2, Ypos+camobj = d3, ...
	lda.b d2
	sta.w Xpos+camobj				;camera x
	sta.w Hpos						;view x
	lda.b d3
	sta.w Ypos+camobj				;camera y
	sta.w Vpos						;view y
	lda.w #$0010					;marker on object 8
	sta.w PadControlObj+$C			;marker object
	jmp.w .10						;draw
.14:								; x and y steps (words) for eight directions
	dw $0000,$0002, $0002,$0002, $0002,$0000, $0002,$FFFE	;x, y: down, down-right, right, up-right
	dw $0000,$FFFE, $FFFE,$FFFE, $FFFE,$0000, $FFFE,$0002	;up, up-left, left, down-left
.16:								; if replaylock != $FFFF go to .9x, ...
	lda.w replaylock				;camera mode
	cmp.w #$FFFF					;free camera?
	bne .9x							;no: buttons
	lda.w PadControlObj				;pad's object
	cmp.w #$000F					;none?
	beq .t1xxxxx					;yes: follow the puck
	asl a							;word index
	tax
	lda.w #$000F					;no marker
	sta.w PadControlObj+$C
	lda.w Xpos,x					;camera on his x
	sta.w Xpos+camobj
	lda.w Ypos,x					;and y
	sta.w Ypos+camobj
	bra .9x

.t1xxxxx:							; PadControlObj = $000F: PadControlObj+$C = $000F, if puckx - $FF78 >=...
	lda.w #$000F
	sta.w PadControlObj+$C			;no marker
	lda.w puckx						;puck x
	cmp.w #$FF78					;left of the boards?
	bpl .2xxxxxxxx
.1xxxxxxxxxx:						; falls through
	lda.w #$FF78					;clamp
.2xxxxxxxx:							; if minus go to .4xxxxx
	cmp.w #Sideline					;right of the boards?
	bmi .4xxxxx
.3xxxxxx:							; falls through
	lda.w #Sideline					;clamp
.4xxxxx:							; Xpos+camobj = A, if pucky - $FED4 >= 0 go to .6x
	sta.w Xpos+camobj				;camera x
	lda.w pucky						;puck y
	cmp.w #$FED4					;behind the back?
	bpl .6x
.5x:								; falls through
	lda.w #$FED4					;clamp
.6x:								; if minus go to .8x
	cmp.w #$012C					;behind the front?
	bmi .8x
.7x:								; falls through
	lda.w #$012C					;clamp
.8x:								; Ypos+camobj = A
	sta.w Ypos+camobj				;camera y
.9x:								; if d1 bits $8000 clear go to .2xxxxxxxxx, ...
	lda.b d1						;new presses
	bit.w #$8000					;B: play / pause
	beq .2xxxxxxxxx					;no
	lda.l replaypanel				;panel up?
	beq .1xxxxxxxxxxx				;no
	lda.l blankchar
	clc
	adc.l charofs					;in the text set
	ldx.w #$0180					;$180 words
	ldy.w #$0000					;from VRAM 0
	jsl.l FillVRAMSplit				;clear the panel
	jsl.l WaitFrame
	lda.w #$0000					;panel off
	sta.l replaypanel
.1xxxxxxxxxxx:						; eor #$0002, sflags3 = A
	lda.w sflags3
	eor.w #$0002					;toggle play
	sta.w sflags3
.2xxxxxxxxx:						; if d3 bit $0020 set go to .t1xxxxxx, ...
	lda.b d3						;held buttons
	bit.w #$0020					;L: back
	bne .t1xxxxxx					;step back
	bit.w #$0050					;R or X: forward
	bne .t5							;step forward
	lda.b d1						;new presses
	bit.w #$2000					;select?
	bne .t3							;yes: unlock the camera
	bit.w #$1000					;start?
	bne .t2xxx						;yes: exit
	lda.b d3						;held
	bit.w #$0080					;A: fast forward?
	bne .t4							;yes
	bit.w #$4000					;Y: rewind?
	beq .12x						;no: play or pause
	jsl.l suba4						;two frames back
	jsl.l suba4						; move the replay one frame back
	bra .11x						;update

.t1xxxxxx:							; d3 bit $0020 set: call suba4, go to .10x
	jsl.l suba4						;one back
	ldx.w #$0006					;6 frames
	bra .10x						;slow

.t2xxx:								; go to .15
	jmp.w .15						;exit the replay

.t3:								; d1 bit $2000 set: replaylock = $FFFF, trb sflags, go to .13
	lda.w #$FFFF					;free camera
	sta.w replaylock
	lda.w #$0020					;unlock the scroll
	trb.w sflags
	jmp.w .13						;show it

.t4:								; d3 bit $0080 set: call adda4, call adda4, go to .11x
	jsl.l adda4						;two frames forward
	jsl.l adda4						; move the replay one frame forward
	bra .11x						;update

.t5:								; call adda4, if d3 bit $0010 set go to .10x, ...
	jsl.l adda4						;one forward
	ldx.w #$0006					;6 frames
	lda.b d3
	bit.w #$0010					;R held?
	bne .10x						;slow
	ldx.w #$000C					;X: 12 frames
.10x:								; call WaitFrames_Inc
	ldy.w #$0000
	jsl.l WaitFrames_Inc			;wait them
.11x:								; call SoundVoicesOff, d7 = $0001, trb sflags3, ...
	jsl.l SoundVoicesOff			;silence
	lda.w #$0001
	sta.b d7						;step 1
	lda.w #$0002
	trb.w sflags3					;pause
	jmp.w .10						;draw
.12x:								; if sflags3 bit $0002 set go to .t1xxxxxxx, ...
	lda.w sflags3					;playing?
	bit.w #$0002					;yes
	bne .t1xxxxxxx
	jmp.w .13						;paused: draw

.t1xxxxxxx:							; sflags3 bit $0002 set: call adda4, if d7 = 0 go to .11x, ...
	jsl.l adda4						;next frame
	lda.b d7
	beq .11x						;at the end: pause
	lda.w recsfx2					;recorded sound 2
	and.w #$00FF
	cmp.w #$00FF					;none?
	beq .13x						;yes
	cmp.w #$0016					;streamed?
	bcs .t2xxxx
	lda.w recsfxvol2				;its volume
	sta.b SfxVelocity
	lda.w recsfx2
	and.w #$00FF					;the sound
	jsl.l QueueSound				;queue it
	tay								;voice used
	sep #$20
	lda.w VoiceState,y				;voice state
	cmp.b #$02						;keyed on?
	bne .1xxxxxxxxxxxx				;no
	lda.b #$03						;sustain
	sta.w VoiceState,y
	rep #$20
	tya
	asl a
	tay
	lda.w recsfxpitch2				;recorded pitch
	sta.w VoicePitch,y				;restore it
.1xxxxxxxxxxxx:						; go to .13x
	rep #$20
	bra .13x

.t2xxxx:							; sbc #$0015, call StreamSfx
	sec
	sbc.w #$0015					;stream number
	jsl.l StreamSfx					;stream it
.13x:								; if zero go to .14x, ...
	lda.w recsfx					;recorded sound 1
	and.w #$00FF
	cmp.w #$00FF					;none?
	beq .14x						;yes
	cmp.w #$0016					;streamed?
	bcs .t1xxxxxxxx
	lda.w recsfxvol					;its volume
	sta.b SfxVelocity
	lda.w recsfx
	and.w #$00FF					;the sound
	jsl.l QueueSound				;queue it
	tay								;voice used
	sep #$20
	lda.w VoiceState,y				;voice state
	cmp.b #$02						;keyed on?
	bne .1xxxxxxxxxxxxx				;no
org $9BB001
	lda.b #$03						;sustain
	sta.w VoiceState,y
	rep #$20
	tya
	asl a
	tay
	lda.w recsfxpitch				;recorded pitch
	sta.w VoicePitch,y				;restore it
.1xxxxxxxxxxxxx:					; go to .14x
	rep #$20
	bra .14x

.t1xxxxxxxx:						; sbc #$0015, call StreamSfx
	sec
	sbc.w #$0015					;stream number
	jsl.l StreamSfx					;stream it
.14x:								; go to .10
	jmp.w .10						;draw
.15:								; PadControlObj+$C = $000F, call SoundVoicesOff, Hpos = pulled value, ...
	lda.w #$000F					;no marker
	sta.w PadControlObj+$C
	jsl.l SoundVoicesOff			;silence
	pla
	sta.w Hpos						;restore the view
	pla
	sta.w Vpos
	pla
	sta.w recbpr+2					;and the record pointer
	pla
	sta.w recbpr
	lda.w #$0020
	trb.w sflags					;unlock the scroll
	lda.w recbpr+2
	sta.b a4+2						;at the live frame
	lda.w recbpr
	sta.b a4
	jsl.l RestoreReplayFrame		;restore it
	lda.w #$0800					;replay flag
	trb.w sflags					;clear it
	jsl.l SetHor					;horizontal rink back
	jsl.l SpriteFrameStart
	jsl.l setvideo					; once per game frame: build the sprite table for the next vblank
	jsl.l SpriteFrameEnd
	stz.w textdirtylo				;whole text map
	lda.w #$03FF					;dirty
	sta.w textdirtyhi
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l FadeOutSound				; start the sound fade out
.loopxx:							; loop: if brightness != 0 go to .loopxx, ...
	lda.w brightness				;wait for black
	bne .loopxx
	lda.w SoundFadeSpeed			;and the sound fade
	bne .loopxx
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	lda.w shootoutmode				;shootout?
	bne .1xxxxxxxxxxxxxx			;yes: no music
	lda.w replaymusic				;music before the replay?
	beq .1xxxxxxxxxxxxxx			;no
	jsl.l SPCMenuUpload				; upload the Menu sample set
	lda.l OptPlayMode				;play mode
	beq .t1xxxxxxxxx				;exhibition: menu song
	cmp.w #$0004					;shootout?
	beq .t1xxxxxxxxx
	lda.l playoffRoundIdx			;playoff round
	cmp.w #$0002					;before the finals?
	bcc .t1xxxxxxxxx
	lda.w #PlayoffSong>>16			;playoff song
	sta.b p0+2
	lda.w #PlayoffSong
	sta.b p0
	jsl.l MusicStart				; start the song at [p0]: tempo from its second byte
	jmp.w .1xxxxxxxxxxxxxx

.t1xxxxxxxxx:						; p0 = MenuSong, call MusicStart
	lda.w #MenuSong>>16				;menu song
	sta.b p0+2
	lda.w #MenuSong
	sta.b p0
	jsl.l MusicStart				; start the song at [p0]: tempo from its second byte
.1xxxxxxxxxxxxxx:					; return
	rtl
