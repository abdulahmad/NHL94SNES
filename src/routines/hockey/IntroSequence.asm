; The power-on sequence before the title: its own sample set (SPCIntroUpload) and song, a mode 7 picture with
; its frame hook, until it ends or a button
; Called from Opening; returns with the screen forced black.
;
; The animation is a state machine: .4 runs once per frame, d4 is the current state (index into the table
; .5), d4+2 the next state and d5 the state to go to after a zoom or fade. State routines work through
; jobs that .framehook performs in the next frame (the bits of introHookFlags).
IntroSequence:						; power-on animation, returns when it ends or a button is pressed
	stz.w brightness				; screen black, check the TV system, upload the intro sample set and song
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jsl.l CheckPAL					; set the frame time step for a 50 Hz console
	jsl.l SPCIntroUpload			; upload the Intro sample set
	sep #$20
	lda.b #$FF						; Mode 7 in use; sprites at $6000
	sta.w Mode7InUse
	rep #$30
	ldy.w #$01A0					;sprite table base
	lda.w #$6000
	ldx.w #$0000					;sprite chars from 0
	jsl.l InitSprites				; reset the DMA queue
	stz.b DMAQueueHead
	stz.b DMAQueueTail
	lda.w #.1						; p0 = the video register table (.1), set the registers with .33
	sta.b p0
	lda.w #.1>>16
	sta.b p0+2
	jsl.l .33						; .2 loads the palettes and graphics, .3 sets the start state
	jsr.w .2
	stz.b introHookFlags
	jsr.w .3
	stz.w fadestep
	stz.w brightness
	jsl.l SpriteFrameStart			; no pending jobs, fade and brightness 0, one empty sprite frame
	jsl.l SpriteFrameEnd
	ldx.w #.framehook>>16
	lda.w #.framehook
	jsl.l SetFrameHook				; run the routine at X:A as the frame hook of the next NMI
	jsl.l ScreenOn					; install the frame hook, screen on
	lda.w #$7000
	sta.b SfxVelocity				;sound volume
	ldx.w #$003C					;60 frames
.loop:								; wait 60 frames
	jsl.l WaitFrame
	dex
	bpl .loop
	ldx.w #.framehook>>16
	lda.w #.framehook
	jsl.l SetFrameHook				; run the routine at X:A as the frame hook of the next NMI
.loop2:								; run the state machine once per frame until it returns nonzero (the dead
									; DMA queue test below changes nothing)
	jsl.l RandomWord				;stir the random seed
	jsr.w .4						;one state step
	bne .t1							;finished?
	lda.b DMAQueueTail
	cmp.b DMAQueueHead
	beq .loop2
	bra .loop2

.t1:								; finished: screen black
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	rtl
.1:									; video register table read by .33: BGMODE 7, M7SEL $C0, TM $11, TS 0 and
									; the BG map and character bases
	db $07,$C0,$11,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
.2:									; load palettes, clear the work buffer and unpack the logo graphics
	sep #$20
	stz.w CGADD						; backdrop colour white
	lda.b #$FF						;white
	sta.w CGDATA					;low byte
	sta.w CGDATA					;high byte
	rep #$20
	lda.w #EALogoEPalette			; E logo palette to colours $30 and $B0, A logo palette to $40 and $C0
	sta.b p0
	lda.w #EALogoEPalette>>16
	sta.b p0+2
	ldy.w #$0030					;colour $30
	ldx.w #$0010					;16 bytes
	jsl.l DMAToCGRAM				; DMA X bytes of colours from [p0] to CGRAM at colour Y
	ldy.w #$00B0					;colour $B0 (sprites)
	ldx.w #$0010
	jsl.l DMAToCGRAM				; DMA X bytes of colours from [p0] to CGRAM at colour Y
	lda.w #EALogoAPalette
	sta.b p0
	lda.w #EALogoAPalette>>16
	sta.b p0+2
	ldy.w #$0040					;colour $40
	ldx.w #$0010
	jsl.l DMAToCGRAM				; DMA X bytes of colours from [p0] to CGRAM at colour Y
	ldy.w #$00C0					;colour $C0 (sprites)
	ldx.w #$0010
	jsl.l DMAToCGRAM				; DMA X bytes of colours from [p0] to CGRAM at colour Y
	lda.w #$FFFF					;white
	ldx.w #$000F					;16 colours
	ldy.w #$0020					;from colour $20
	jsl.l .31						; clear the work buffer (introbuf, $4000 bytes)
	lda.w #$FFFF					;white
	ldx.w #$000F					;16 colours
	ldy.w #$0010					;from colour $10
	jsl.l .31
	ldx.w #$0000
	lda.w #$0000					;zero
.loopx:								; next word
	sta.l introbuf,x				;clear
	inx
	inx
	cpx.w #$4000					; unpack EALogoTiles to introchars (introchars) and EALogoMap to introbuf
	bcc .loopx						;all $4000 bytes
	lda.w #EALogoTiles
	sta.b p0
	lda.w #EALogoTiles>>16
	sta.b p0+2
	lda.w #introchars
	sta.b p1
	lda.w #introchars>>16
	sta.b p1+2
	jsl.l Decompress				; unpack EALogoTiles
	lda.w #EALogoMap
	sta.b p0
	lda.w #EALogoMap>>16
	sta.b p0+2
	lda.w #introbuf
	sta.b p1
	lda.w #introbuf>>16				; send the map bytes (low) and tile bytes (high) to VRAM interleaved: the
									; Mode 7 layout
	sta.b p1+2
	jsl.l Decompress				; unpack EALogoMap
	stz.w VMADDL					;VRAM 0
	sep #$20
	lda.b #$80						;increment after the high byte
	sta.w VMAIN
	ldy.w #$4000					;$4000 pairs
	ldx.w #$0000
.loop2x:							; one map byte and one tile byte
	lda.l introbuf+6,x				;map byte
	sta.w VMDATAL					;low VRAM byte
	lda.l introchars,x				;tile byte
	sta.w VMDATAH					;high VRAM byte
	inx
	dey
	bne .loop2x						;all of them
	rep #$20
	ldx.w #$1C00					;from offset $1C00
	ldy.w #$0000					;into the copy
	sep #$20
.loop3:								; interleave the map and tile bytes at offset $1C00 into introbuf+$40 (the
									; copy .28 later sends to VRAM)
	lda.l introbuf,x				;map byte
	phx
	tyx
	sta.l introbuf+$40,x			;copy
	plx
	iny
	lda.l introchars,x				;tile byte
	phx
	tyx
	sta.l introbuf+$40,x			;copy
	plx
	inx
	iny
	cpy.w #$0A00					;$A00 bytes
	bmi .loop3						;until done
	rep #$20
	lda.w #EALogoSprites			; unpack EALogoSprites to introbuf+$A40 for DrawSprite
	sta.b p0
	lda.w #EALogoSprites>>16
	sta.b p0+2
	lda.w #introbuf+$A40
	sta.b p1
	lda.w #(introbuf+$A40)>>16
	sta.b p1+2
	jsl.l Decompress				; unpack EALogoSprites
	rts
.3:									; set up the start state
	lda.w #$0180					; BG1 scroll $180/$190, frame hook job $10 (send the scroll)
	sta.b introBG1H					;BG1 x
	sta.w BG1HScroll
	lda.w #$0190					;BG1 y
	sta.b introBG1V
	sta.w BG1VScroll
	lda.w #$0010					;send the scroll
	tsb.b introHookFlags			;frame hook job
	lda.w #$0003					; d4+2 = start state 3, d5+2 = 0, d6 = timeout (Vcount + $2D0), d7 =
									; earliest end (Vcount + $F0)
	sta.b d4+2
	stz.b d5+2
	lda.b Vcount					;frame count
	tax
	clc
	adc.w #$02D0					;plus $2D0
	sta.b d6						;timeout
	txa
	clc
	adc.w #$00F0					;plus $F0
	sta.b d7						;earliest end
	jsr.w .22						; Mode 7 registers
	rts
.4:									; state machine step: A = 1 to end the sequence, 0 to continue
	lda.b d4+2						; current state = next state
	sta.b d4
	lda.b d4						;state
	cmp.w #$000D					;state 13 (the end)?
	beq .1x							;yes
	lda.w PadRaw1					;any button?
	beq .1x							;(no skip test here)
.1x:								; pending hook jobs: wait
	lda.b introHookFlags
	beq .t1x						;jobs pending?
	jmp.w .20						;yes: wait

.t1x:								; jump to the state routine
	lda.b d4
	asl a							;word index
	tax
	jmp (.5,x)						;run the state
.5:									; jump table for jmp (.5,x)
	dw .6,.7,.8,.9,.10,.11,.12
	dw .13,.14,.15,.16,.17,.18,.19
.6:									; state 0: zoom in, matrix A and D grow by $C per frame until $100
	ldx.b d5+2						;skip flag
	bne .t1xx						;skipping: done
	lda.b introM7A					;matrix A
	clc
	adc.w #$000C					;grow by $C
	sta.b introM7A					;scale x
	sta.b introM7D					;scale y
	cmp.w #$0100					;full size?
	bpl .t1xx						;yes: done
	lda.w #$0040					;matrix job
	tsb.b introHookFlags			;request it
	bra .1xx

.t1xx:								; zoom done (or skipped): matrix back to $100, continue at state d5
	jsr.w .23						;matrix $100
	lda.w #$0040					;matrix job
	tsb.b introHookFlags			;request it
	lda.b d5						;state after the zoom
	sta.b d4+2						;next
.1xx:								; end of the step
	jmp.w .20
.7:									; state 1: fade the logo palette toward white, up to 3 steps per frame
	ldx.b d5+2						;skip flag
	bne .t1xxx						;skipping: done
	jsr.w .30						;fade one step
	bne .t1xxx						;all white?
	jsr.w .30						;step 2
	bne .t1xxx
	jsr.w .30						;step 3
	bne .t1xxx
	lda.w #$0008					;palette job
	tsb.b introHookFlags			;request it
	bra .1xxx

.t1xxx:								; all white (or skipped): reload the 16 colours from [p0], send them,
									; continue at d5
	lda.w #introbuf					;work buffer
	sta.b p1
	lda.w #introbuf>>16
	sta.b p1+2
	jsr.w .32						;reload the colours
	lda.w #$0008					;palette job
	tsb.b introHookFlags			;request it
	lda.b d5						;state after the fade
	sta.b d4+2						;next
.1xxx:								; end of the step
	jmp.w .20
.8:									; state 2: wait until Vcount reaches d6+2
	ldx.b d5+2						;skip flag
	bne .1xxxx						;skipping: go on
	lda.b Vcount					;frame count
	cmp.b d6+2						;time up?
	bmi .2x							;no: wait
.1xxxx:								; continue at state d5
	lda.b d5						;state after the wait
	sta.b d4+2						;next
.2x:								; end of the step
	jmp.w .20
.9:									; state 3: play sound 0 and start the E logo at matrix scale 1
	lda.b d5+2						;skip flag
	bne .t1xxxx						;skipping
	lda.w #$0000					;sound 0 (the E logo)
	jsl.l PlaySound					; play sound A at once
	jsr.w .24						;matrix start
	bra .2xx

.t1xxxx:							; matrix scale $100
	jsr.w .23
.2xx:								; block of the E logo map into the buffer (copy), send it, matrix update
	lda.w #EALogoEMap
	sta.b p0
	lda.w #EALogoEMap>>16
	sta.b p0+2
	jsl.l .26						;copy the map block
	lda.w #$00C0					;map and matrix jobs
	tsb.b introHookFlags			;request them
	lda.w #$0004					;state 4 next
	ldx.b d5+2						;skipping?
	bne .1xxxxx						;yes: straight to 4
	sta.b d5						;after the zoom
	lda.w #$0000					;zoom first
.1xxxxx:							; next state 0 (zoom) with d5 = 4, else state 4
	sta.b d4+2
	jmp.w .20
.10:								; state 4: draw sprite 0 at (x $38, y $2F), next state 9
	jsl.l SpriteFrameStart
	lda.w #introbuf+$A40			;logo sprites
	sta.b p1
	lda.w #(introbuf+$A40)>>16
	sta.b p1+2
	lda.w #$0000					;sprite 0
	sta.b r0
	lda.w #$0000					;no attributes
	ldx.w #$0038					;x $38
	ldy.w #$002F					;y $2F
	jsl.l DrawSprite				;draw it
	jsl.l SpriteFrameEnd
	lda.w #$0009					;state 9
	sta.b d4+2
	jmp.w .20
.11:								; state 5: A logo, as state 3 with EALogoAMap
	lda.b d5+2						;skip flag
	bne .t1xxxxx					;skipping
	jsr.w .24						;matrix start
	bra .2xxx

.t1xxxxx:							; matrix scale $100
	jsr.w .23
.2xxx:								; A logo map block into the buffer, send it, matrix update
	lda.w #EALogoAMap
	sta.b p0
	lda.w #EALogoAMap>>16
	sta.b p0+2
	jsl.l .26						;copy the map block
	lda.w #$00C0					;map and matrix jobs
	tsb.b introHookFlags			;request them
	lda.w #$0006					;state 6 next
	ldx.b d5+2						;skipping?
	bne .1xxxxxx					;yes: straight to 6
	sta.b d5						;after the zoom
	lda.w #$0000					;zoom first
.1xxxxxx:							; next state 0 (zoom) with d5 = 6, else state 6
	sta.b d4+2
	jmp.w .20
.12:								; state 6: draw sprites 0 and 1, next state 10
	jsl.l SpriteFrameStart
	lda.w #introbuf+$A40			;logo sprites
	sta.b p1
	lda.w #(introbuf+$A40)>>16
	sta.b p1+2
	lda.w #$0000					;sprite 0
	sta.b r0
	lda.w #$0000
	ldx.w #$0038					;x $38
	ldy.w #$002F					;y $2F
	jsl.l DrawSprite				;draw it
	lda.w #$0001					;sprite 1
	sta.b r0
	lda.w #$0000
	ldx.w #$0038					;x $38
	ldy.w #$002F					;y $2F
	jsl.l DrawSprite				;draw it
	jsl.l SpriteFrameEnd
	lda.w #$000A					;state 10
	sta.b d4+2
	jmp.w .20
.13:								; state 7: clear the map block, then set up the sports palette job
	lda.b d5+2						;skip flag
	bne .t1xxxxxx					;skipping
	jsr.w .24						;matrix start
	bra .2xxxx

.t1xxxxxx:							; matrix scale $100
	jsr.w .23
.2xxxx:								; clear the map block (.25), palette job: EALogoSportsPalette, 16 colours
									; from colour $20
	jsl.l .25						;clear the block
	lda.w #EALogoSportsPalette
	sta.b tmp2						;palette pointer
	lda.w #$009A					;bank $9A
	sta.b tmp3
	lda.w #$0020
	sta.b tmp0						;from colour $20
	lda.w #$0010
	sta.b tmp1						;16 colours
	lda.w #$00C8
	tsb.b introHookFlags			;palette, map and matrix jobs
	lda.w #$000B					;state $B next
	ldx.b d5+2						;skipping?
	bne .1xxxxxxx					;yes: straight to $B
	sta.b d5						;after the zoom
	lda.w #$0000					;zoom first
.1xxxxxxx:							; next state 0 (zoom) with d5 = $B, else state $B
	sta.b d4+2
	jmp.w .20
.14:								; state 8: text palette job (EALogoTextPalette, 16 colours from colour
									; $10), next state $D
	lda.w #EALogoTextPalette
	sta.b tmp2
	lda.w #$009A					;bank $9A
	sta.b tmp3
	lda.w #$0010
	sta.b tmp0						;colour $10
	lda.w #$0010
	sta.b tmp1						;16 colours
	lda.w #$0008					;palette job
	tsb.b introHookFlags			;request it
	lda.w #$000D					;state $D next
	sta.b d4+2
	jmp.w .20
.15:								; state 9: skipped: state 5; else prepare the E palette ($30) fade and go
									; to state 1 with d5 = 5
	lda.b d5+2
	beq .t1xxxxxxx					;not skipped: fade
.1xxxxxxxx:							; go to state 5
	lda.w #$0005
	sta.b d4+2
	jmp.w .20

.t1xxxxxxx:							; E palette to colours from $30, d5 = 5, fade in state 1
	lda.w #EALogoEPalette
	sta.b p0
	lda.w #EALogoEPalette>>16
	sta.b p0+2
	lda.w #$0030					;colour $30
	sta.b tmp0
	jsr.w .29						;set up the palette job
	lda.w #$0005					;after the fade: 5
	sta.b d5
	lda.w #$0001					;fade state
	sta.b d4+2
	jmp.w .20
.16:								; state 10: same for the A logo palette: skipped goes to state 7
	lda.b d5+2
	beq .t1xxxxxxxx
.1xxxxxxxxx:						; go to state 7
	lda.w #$0007
	sta.b d4+2
	jmp.w .20

.t1xxxxxxxx:						; A palette to colours from $40, d5 = 7, fade in state 1
	lda.w #EALogoAPalette
	sta.b p0
	lda.w #EALogoAPalette>>16
	sta.b p0+2
	lda.w #$0040					;colour $40
	sta.b tmp0
	jsr.w .29						;set up the palette job
	lda.w #$0007					;after the fade: 7
	sta.b d5
	lda.w #$0001					;fade state
	sta.b d4+2
	jmp.w .20
.17:								; state 11: go to state 8
	lda.w #$0008
	sta.b d4+2
	jmp.w .20

.t1xxxxxxxxx:						; sports palette fade setup (no branch reaches it): palette from $20, d5 =
									; $C, state 1
	lda.w #EALogoSportsPalette
	sta.b p0
	lda.w #EALogoSportsPalette>>16
	sta.b p0+2
	lda.w #$0020					;colour $20
	sta.b tmp0
	jsr.w .29						;set up the palette job
	lda.w #$000C					;after the fade: $C
	sta.b d5
	lda.w #$0001					;fade state
	sta.b d4+2
	jmp.w .20
.18:								; state 12: wait 30 frames in state 2, then go to state 8
	lda.b Vcount					;frame count
	clc
	adc.w #$001E					;plus 30
	sta.b d6+2						;wait until then
	lda.w #$0002					;wait state
	sta.b d4+2
	lda.w #$0008					;then state 8
	sta.b d5
	jmp.w .20
.19:								; state 13: end test: full brightness and d7 reached, then a button or the
									; d6 timeout ends
	lda.w brightness				;brightness
	cmp.w #$000F					;full?
	bne .20							;no: go on
	lda.b Vcount					;frame count
	cmp.b d7						;shown long enough?
	bmi .20							;no: go on
	lda.w PadRaw1					;any button?
	bne .t1xxxxxxxxxx				;yes: end
	lda.b Vcount					;frame count
	cmp.b d6						;timed out?
	bmi .20							;no: go on
	bra .t1xxxxxxxxxx

.t1xxxxxxxxxx:						; A = 1: end
	lda.w #$0001					;end
	bra .21
.20:								; A = 0: go on
	lda.w #$0000					;go on
.21:								; return
	rts
.22:								; set the Mode 7 centre (X $200, Y $200) and the matrix to $100 0 0 $100
	sep #$20
	lda.b #$00						;centre x low
	sta.w M7X
	lda.b #$02						;high: $200
	sta.w M7X
	lda.b #$00						;centre y low
	sta.w M7Y
	lda.b #$02						;high: $200
	sta.w M7Y
	stz.w M7A						;A low
	lda.b #$01
	sta.w M7A						;A high: $100
	stz.w M7B						;B = 0
	stz.w M7B
	stz.w M7C						;C = 0
	stz.w M7C
	stz.w M7D						;D low
	lda.b #$01
	sta.w M7D						;D high: $100
	rep #$20
	jsr.w .23						;keep $100 in the copies
	rts
.23:								; matrix A and D = $100 (normal size)
	lda.w #$0100					;normal size
	sta.b introM7A
	sta.b introM7D
	rts
.24:								; matrix A and D = 1 (smallest)
	lda.w #$0001					;smallest
	sta.b introM7A
	sta.b introM7D
	rts
.25:								; clear the 18 by 10 block of map bytes in the buffer (d1 = 0)
	stz.b d1
	jsr.w .27
	rtl
.26:								; copy the 18 by 10 block from the map at p0 (d1 = 1)
	lda.w #$0001
	sta.b d1
	jsr.w .27
	rtl
.27:								; 10 rows of 18 bytes at the low byte of the buffer's map words (row
									; stride 128 words)
	ldy.w #$0006					;map data after the header
	stz.b d0+2						;row 0
.loopxx:							; next row, x = buffer offset of its start
	lda.b d0+2
	asl a							;x128
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a							;row x 128
	clc
	adc.w #$0037					;plus column $37
	asl a							;word index
	tax
	stz.b d0						;column 0
	sep #$20
.loop2xx:							; one byte, copied or zero
	lda.b d1						;copy?
	beq .1xxxxxxxxxx				;no: zero
	lda.b [p0],y					;map byte
.1xxxxxxxxxx:						; store it in the buffer
	sta.l introbuf+$40,x			;low byte of the buffer word
	iny
	inx
	inx
	inc.b d0						;column
	lda.b d0
	cmp.b #$12						;18 columns?
	bmi .loop2xx					;no: next
	rep #$20
	inc.b d0+2						;next row
	lda.b d0+2
	cmp.w #$000A					;10 rows?
	bmi .loopxx						;no: next
	rts

.t1xxxxxxxxxxx:						; unreferenced entry: 16-bit registers, fall into .28
	rep #$30
.28:								; send the buffer to VRAM word $1C00 ($A00 bytes), keeping p0
	lda.b p0						;keep p0
	pha
	lda.b p0+2
	pha
	lda.w #introbuf+$40
	sta.b p0
	lda.w #(introbuf+$40)>>16
	sta.b p0+2
	ldx.w #$1C00					;VRAM $1C00
	lda.w #$0A00					;$A00 bytes
	jsl.l .t1xxxxxxxxxxxx			;send it
	pla
	sta.b p0+2						;restore p0
	pla
	sta.b p0
	rtl

.t1xxxxxxxxxxxx:					; DMA channel 0, A = byte count, x = VRAM address, source p0
	php
	sta.w DAS0L						;byte count
	lda.b p0
	sta.w A1T0L						;source address
	stx.w VMADDL					;VRAM address
	sep #$20
	lda.b p0+2
	sta.w A1B0						;source bank
	lda.b #$01
	sta.w DMAP0						;two registers, word writes
	lda.b #$18						;to VMDATA
	sta.w BBAD0
	lda.b #$01
	sta.w MDMAEN					;start channel 0
	rep #$30
	plp
	rtl
.29:								; palette job: copy 16 words from [p0] to the buffer, source tmp2/3 =
									; buffer, tmp1 = $10
	lda.w #introbuf
	sta.b p1
	lda.w #introbuf>>16
	sta.b p1+2
	jsr.w .32						;copy the palette
	lda.w #$0010
	sta.b tmp1						;16 colours
	lda.w #introbuf					;from the buffer
	sta.b tmp2
	lda.w #introbuf>>16
	sta.b tmp3
	rts
.30:								; one fade step on the 16 palette words in the buffer: every colour
									; component +1 up to 31, returns A = 1 if all are white
	ldx.w #$0000
	ldy.w #$0001					;all white so far
.loopxxx:							; next colour
	lda.l introbuf,x				;colour
	pha								;keep it
	and.w #$001F					;red
	cmp.w #$001F					;full?
	beq .1xxxxxxxxxxx				;yes
	clc
	adc.w #$0001					;+1
	and.w #$001F
.1xxxxxxxxxxx:						; red done
	sta.l introbuf,x				;red
	pla								;colour again
	pha
	and.w #$03E0					;green
	cmp.w #$03E0					;full?
	beq .2xxxxx						;yes
	clc
	adc.w #$0020					;+1
	and.w #$03E0
.2xxxxx:							; green done
	ora.l introbuf,x				;plus red
	sta.l introbuf,x				;stored
	pla
	and.w #$7C00					;blue
	cmp.w #$7C00					;full?
	beq .3x							;yes
	clc
	adc.w #$0400					;+1
	and.w #$7C00
.3x:								; blue done
	ora.l introbuf,x				;plus red and green
	sta.l introbuf,x				;stored
	and.w #$7FFF
	cmp.w #$7FFF					;white?
	beq .4x							;yes
	ldy.w #$0000					;not all white
.4x:								; not white yet: result 0
	inx
	inx
	cpx.w #$0020					;16 colours
	bmi .loopxxx					;until done
	tya								;result
	rts
.31:								; fill CGRAM from colour y with colour A, x + 1 entries
	sep #$30
	sty.w CGADD						;first colour
.loopxxxx:							; write one colour
	sta.w CGDATA					;low byte
	xba
	sta.w CGDATA					;high byte
	xba
	dex
	bpl .loopxxxx					;until done
	rep #$30
	rtl
.32:								; copy $20 bytes from [p0] to [p1]
	ldy.w #$0000
.loopxxxxx:							; copy a word
	lda.b [p0],y					;word
	sta.b [p1],y					;copied
	iny
	iny
	cpy.w #$0020					;$20 bytes
	bmi .loopxxxxx					;until done
	rts
.framehook:							; the frame hook of this sequence
	rep #$30
	lda.b introHookFlags			;jobs
	bit.w #$0080					;job $80: map block?
	beq .t1xxxxxxxxxxxxx			;no
	jsl.l .28						;send the map block
	lda.w #$0080					;done
	trb.b introHookFlags
	jmp.w .3xx						;then the scroll job

.t1xxxxxxxxxxxxx:					; job $08: send the palette in tmp2/3 (colour tmp0, count tmp1), and with
									; $200 the second one
	lda.b introHookFlags			;jobs
	bit.w #$0008					;job $08: palette?
	beq .3xx						;no
	lda.b p0						;keep p0
	pha
	lda.b p0+2
	pha
	lda.b tmp2						;palette source
	sta.b p0
	lda.b tmp3
	sta.b p0+2
	ldy.b tmp0						;first colour
	ldx.b tmp1						;count
	jsl.l DMAToCGRAM				;send it
	lda.b introHookFlags
	bit.w #$0200					;second palette?
	beq .2xxxxxx					;no
.1xxxxxxxxxxxx:						; second palette from introPal2Src
	lda.b introPal2Src
	sta.b p0
	lda.b introPal2Src+2
	sta.b p0+2
	ldy.b tmp4						;its colour
	ldx.b tmp5						;its count
	jsl.l DMAToCGRAM				;send it
.2xxxxxx:							; restore p0, clear the jobs
	pla
	sta.b p0+2						;restore p0
	pla
	sta.b p0
	lda.w #$0208					;palette jobs done
	trb.b introHookFlags
.3xx:								; job $10: set the BG1 scroll registers
	lda.b introHookFlags			;jobs
	bit.w #$0010					;scroll job?
	beq .1xxxxxxxxxxxxx				;no
	sep #$20
	lda.b introBG1H					;x low
	sta.w BG1HOFS					;BG1 x
	lda.b introBG1H+1				;x high
	sta.w BG1HOFS
	lda.b introBG1V					;y low
	sta.w BG1VOFS					;BG1 y
	lda.b introBG1V+1				;y high
	sta.w BG1VOFS
	rep #$20
	lda.w #$0010					;done
	trb.b introHookFlags
.1xxxxxxxxxxxxx:					; job $40: set the Mode 7 matrix A and D
	lda.b introHookFlags			;jobs
	bit.w #$0040					;matrix job?
	beq .rtl						;no
	sep #$20
	lda.b introM7A					;A low
	sta.w M7A						;scale x
	lda.b introM7A+1				;A high
	sta.w M7A
	lda.b introM7D					;D low
	sta.w M7D						;scale y
	lda.b introM7D+1				;D high
	sta.w M7D
	rep #$20
	lda.w #$0040					;done
	trb.b introHookFlags
.rtl:								; return
	rtl
.33:								; set the video registers from the table at p0 (BGMODE, M7SEL, TM, TS,
									; BG1-4SC, BG12NBA, BG34NBA)
	sep #$20
	lda.b #$03						;sprite chars at $6000, 8x8/16x16
	sta.w OBSEL						;OBSEL
	lda.b #$80						;increment after the high byte
	sta.w VMAIN
	ldy.w #$0000					;table start
	lda.b [p0],y					;mode
	sta.w BGMODE
	iny
	lda.b [p0],y					;Mode 7 settings
	sta.w M7SEL
	iny
	lda.b [p0],y					;main screen
	sta.w TM
	iny
	lda.b [p0],y					;sub screen
	sta.w TS
	iny
	iny
	lda.b [p0],y					;BG1 map address
	iny
	ora.b [p0],y					;plus its size bits
	sta.w BG1SC
	iny
	iny
	lda.b [p0],y					;BG2 map
	iny
	ora.b [p0],y					;plus its size bits
	sta.w BG2SC
	iny
	iny
	lda.b [p0],y					;BG3 map
	iny
	ora.b [p0],y					;plus its size bits
	sta.w BG3SC
	iny
	iny
	lda.b [p0],y					;BG4 map
	iny
	ora.b [p0],y					;plus its size bits
	sta.w BG4SC
	iny
	iny
	lda.b [p0],y					;BG1 character base
	lsr a
	lsr a
	lsr a
	lsr a							;high nibble down
	iny
	iny
	ora.b [p0],y					;plus BG2
	sta.w BG12NBA
	iny
	iny
	lda.b [p0],y					;BG3 character base
	lsr a
	lsr a
	lsr a
	lsr a							;high nibble down
	iny
	iny
	ora.b [p0],y					;plus BG4
	sta.w BG34NBA
	rep #$20
	rtl
	db $00
	padbyte $FF
	pad $A08000
