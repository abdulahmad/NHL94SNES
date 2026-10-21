; The power-on sequence before the title: its own sample set (SPCIntroUpload) and song, a mode 7 picture with
; its frame hook, until it ends or a button
; Called from Opening; returns with the screen forced black.
;
; The animation is a state machine: .4 runs once per frame, d4 is the current state (index into the table
; .5), d4+2 the next state and d5 the state to go to after a zoom or fade. State routines work through
; jobs that .framehook performs in the next frame (the bits of introHookFlags).
IntroSequence:						; power-on animation, returns when it ends or a button is pressed
	stz.w brightness				; screen black, check the TV system, upload the intro sample set and song
	jsl.l forceblack
	jsl.l CheckPAL
	jsl.l SPCIntroUpload
	sep #$20
	lda.b #$FF						; Mode 7 in use; sprites at $6000
	sta.w Mode7InUse
	rep #$30
	ldy.w #$01A0
	lda.w #$6000
	ldx.w #$0000
	jsl.l InitSprites				; reset the DMA queue
	stz.b DMAQueueHead
	stz.b DMAQueueTail
	lda.w #.1						; p0 = the video register table (.1), set the registers with .33
	sta.b p0
	lda.w #$009F
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
	jsl.l SetFrameHook
	jsl.l ScreenOn					; install the frame hook, screen on
	lda.w #$7000
	sta.b SfxVelocity
	ldx.w #$003C
.loop:								; wait 60 frames
	jsl.l WaitFrame
	dex
	bpl .loop
	ldx.w #.framehook>>16
	lda.w #.framehook
	jsl.l SetFrameHook
.loop2:								; run the state machine once per frame until it returns nonzero (the dead
									; DMA queue test below changes nothing)
	jsl.l RandomWord
	jsr.w .4
	bne .t1
	lda.b DMAQueueTail
	cmp.b DMAQueueHead
	beq .loop2
	bra .loop2

.t1:								; finished: screen black
	jsl.l forceblack
	rtl
.1:									; video register table read by .33: BGMODE 7, M7SEL $C0, TM $11, TS 0 and
									; the BG map and character bases
	db $07,$C0,$11,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
.2:									; load palettes, clear the work buffer and unpack the logo graphics
	sep #$20
	stz.w CGADD						; backdrop colour white
	lda.b #$FF
	sta.w CGDATA
	sta.w CGDATA
	rep #$20
	lda.w #EALogoEPalette			; E logo palette to colours $30 and $B0, A logo palette to $40 and $C0
	sta.b p0
	lda.w #EALogoEPalette>>16
	sta.b p0+2
	ldy.w #$0030
	ldx.w #$0010
	jsl.l DMAToCGRAM
	ldy.w #$00B0
	ldx.w #$0010
	jsl.l DMAToCGRAM
	lda.w #EALogoAPalette
	sta.b p0
	lda.w #EALogoAPalette>>16
	sta.b p0+2
	ldy.w #$0040
	ldx.w #$0010
	jsl.l DMAToCGRAM
	ldy.w #$00C0					; colours $20 and $10 filled with white (16 entries each)
	ldx.w #$0010
	jsl.l DMAToCGRAM
	lda.w #$FFFF
	ldx.w #$000F
	ldy.w #$0020
	jsl.l .31						; clear the work buffer (introbuf, $4000 bytes)
	lda.w #$FFFF
	ldx.w #$000F
	ldy.w #$0010
	jsl.l .31
	ldx.w #$0000
	lda.w #$0000
.loopx:								; next word
	sta.l introbuf,x
	inx
	inx
	cpx.w #$4000					; unpack EALogoTiles to introchars (introchars) and EALogoMap to introbuf
	bcc .loopx
	lda.w #EALogoTiles
	sta.b p0
	lda.w #$0094
	sta.b p0+2
	lda.w #introchars
	sta.b p1
	lda.w #introchars>>16
	sta.b p1+2
	jsl.l Decompress
	lda.w #EALogoMap
	sta.b p0
	lda.w #EALogoMap>>16
	sta.b p0+2
	lda.w #introbuf
	sta.b p1
	lda.w #introbuf>>16				; send the map bytes (low) and tile bytes (high) to VRAM interleaved: the
									; Mode 7 layout
	sta.b p1+2
	jsl.l Decompress
	stz.w VMADDL
	sep #$20
	lda.b #$80
	sta.w VMAIN
	ldy.w #$4000
	ldx.w #$0000
.loop2x:							; one map byte and one tile byte
	lda.l introbuf+6,x
	sta.w VMDATAL
	lda.l introchars,x
	sta.w VMDATAH
	inx
	dey
	bne .loop2x
	rep #$20
	ldx.w #$1C00
	ldy.w #$0000
	sep #$20
.loop3:								; interleave the map and tile bytes at offset $1C00 into introbuf+$40 (the
									; copy .28 later sends to VRAM)
	lda.l introbuf,x
	phx
	tyx
	sta.l introbuf+$40,x
	plx
	iny
	lda.l introchars,x
	phx
	tyx
	sta.l introbuf+$40,x
	plx
	inx
	iny
	cpy.w #$0A00
	bmi .loop3
	rep #$20
	lda.w #EALogoSprites			; unpack EALogoSprites to introbuf+$A40 for DrawSprite
	sta.b p0
	lda.w #EALogoSprites>>16
	sta.b p0+2
	lda.w #introbuf+$A40
	sta.b p1
	lda.w #(introbuf+$A40)>>16
	sta.b p1+2
	jsl.l Decompress
	rts
.3:									; set up the start state
	lda.w #$0180					; BG1 scroll $180/$190, frame hook job $10 (send the scroll)
	sta.b introBG1H
	sta.w BG1HScroll
	lda.w #$0190
	sta.b introBG1V
	sta.w BG1VScroll
	lda.w #$0010
	tsb.b introHookFlags
	lda.w #$0003					; d4+2 = start state 3, d5+2 = 0, d6 = timeout (vcount + $2D0), d7 =
									; earliest end (vcount + $F0)
	sta.b d4+2
	stz.b d5+2
	lda.b vcount
	tax
	clc
	adc.w #$02D0
	sta.b d6
	txa
	clc
	adc.w #$00F0
	sta.b d7
	jsr.w .22						; Mode 7 registers
	rts
.4:									; state machine step: A = 1 to end the sequence, 0 to continue
	lda.b d4+2						; current state = next state
	sta.b d4
	lda.b d4
	cmp.w #$000D
	beq .1x
	lda.w JoyPad
	beq .1x
.1x:								; pending hook jobs: wait
	lda.b introHookFlags
	beq .t1x
	jmp.w .20

.t1x:								; jump to the state routine
	lda.b d4
	asl a
	tax
	jmp (.5,x)
.5:									; jump table for jmp (.5,x)
	dw .6,.7,.8,.9,.10,.11,.12
	dw .13,.14,.15,.16,.17,.18,.19
.6:									; state 0: zoom in, matrix A and D grow by $C per frame until $100
	ldx.b d5+2
	bne .t1xx
	lda.b introM7A
	clc
	adc.w #$000C
	sta.b introM7A
	sta.b introM7D
	cmp.w #$0100
	bpl .t1xx
	lda.w #$0040
	tsb.b introHookFlags
	bra .1xx

.t1xx:								; zoom done (or skipped): matrix back to $100, continue at state d5
	jsr.w .23
	lda.w #$0040
	tsb.b introHookFlags
	lda.b d5
	sta.b d4+2
.1xx:								; end of the step
	jmp.w .20
.7:									; state 1: fade the logo palette toward white, up to 3 steps per frame
	ldx.b d5+2
	bne .t1xxx
	jsr.w .30
	bne .t1xxx
	jsr.w .30
	bne .t1xxx
	jsr.w .30
	bne .t1xxx
	lda.w #$0008
	tsb.b introHookFlags
	bra .1xxx

.t1xxx:								; all white (or skipped): reload the 16 colours from [p0], send them,
									; continue at d5
	lda.w #introbuf
	sta.b p1
	lda.w #introbuf>>16
	sta.b p1+2
	jsr.w .32
	lda.w #$0008
	tsb.b introHookFlags
	lda.b d5
	sta.b d4+2
.1xxx:								; end of the step
	jmp.w .20
.8:									; state 2: wait until vcount reaches d6+2
	ldx.b d5+2
	bne .1xxxx
	lda.b vcount
	cmp.b d6+2
	bmi .2x
.1xxxx:								; continue at state d5
	lda.b d5
	sta.b d4+2
.2x:								; end of the step
	jmp.w .20
.9:									; state 3: play sound 0 and start the E logo at matrix scale 1
	lda.b d5+2
	bne .t1xxxx
	lda.w #$0000
	jsl.l PlaySound
	jsr.w .24
	bra .2xx

.t1xxxx:							; matrix scale $100
	jsr.w .23
.2xx:								; block of the E logo map into the buffer (copy), send it, matrix update
	lda.w #EALogoEMap
	sta.b p0
	lda.w #EALogoEMap>>16
	sta.b p0+2
	jsl.l .26
	lda.w #$00C0
	tsb.b introHookFlags
	lda.w #$0004
	ldx.b d5+2
	bne .1xxxxx
	sta.b d5
	lda.w #$0000
.1xxxxx:							; next state 0 (zoom) with d5 = 4, else state 4
	sta.b d4+2
	jmp.w .20
.10:								; state 4: draw sprite 0 at (x $38, y $2F), next state 9
	jsl.l SpriteFrameStart
	lda.w #introbuf+$A40
	sta.b p1
	lda.w #(introbuf+$A40)>>16
	sta.b p1+2
	lda.w #$0000
	sta.b r0
	lda.w #$0000
	ldx.w #$0038
	ldy.w #$002F
	jsl.l DrawSprite
	jsl.l SpriteFrameEnd
	lda.w #$0009
	sta.b d4+2
	jmp.w .20
.11:								; state 5: A logo, as state 3 with EALogoAMap
	lda.b d5+2
	bne .t1xxxxx
	jsr.w .24
	bra .2xxx

.t1xxxxx:							; matrix scale $100
	jsr.w .23
.2xxx:								; A logo map block into the buffer, send it, matrix update
	lda.w #EALogoAMap
	sta.b p0
	lda.w #EALogoAMap>>16
	sta.b p0+2
	jsl.l .26
	lda.w #$00C0
	tsb.b introHookFlags
	lda.w #$0006
	ldx.b d5+2
	bne .1xxxxxx
	sta.b d5
	lda.w #$0000
.1xxxxxx:							; next state 0 (zoom) with d5 = 6, else state 6
	sta.b d4+2
	jmp.w .20
.12:								; state 6: draw sprites 0 and 1, next state 10
	jsl.l SpriteFrameStart
	lda.w #introbuf+$A40
	sta.b p1
	lda.w #(introbuf+$A40)>>16
	sta.b p1+2
	lda.w #$0000
	sta.b r0
	lda.w #$0000
	ldx.w #$0038
	ldy.w #$002F
	jsl.l DrawSprite
	lda.w #$0001
	sta.b r0
	lda.w #$0000
	ldx.w #$0038
	ldy.w #$002F
	jsl.l DrawSprite
	jsl.l SpriteFrameEnd
	lda.w #$000A
	sta.b d4+2
	jmp.w .20
.13:								; state 7: clear the map block, then set up the sports palette job
	lda.b d5+2
	bne .t1xxxxxx
	jsr.w .24
	bra .2xxxx

.t1xxxxxx:							; matrix scale $100
	jsr.w .23
.2xxxx:								; clear the map block (.25), palette job: EALogoSportsPalette, 16 colours
									; from colour $20
	jsl.l .25
	lda.w #EALogoSportsPalette
	sta.b tmp2
	lda.w #$009A
	sta.b tmp3
	lda.w #$0020
	sta.b tmp0
	lda.w #$0010
	sta.b tmp1
	lda.w #$00C8
	tsb.b introHookFlags
	lda.w #$000B
	ldx.b d5+2
	bne .1xxxxxxx
	sta.b d5
	lda.w #$0000
.1xxxxxxx:							; next state 0 (zoom) with d5 = $B, else state $B
	sta.b d4+2
	jmp.w .20
.14:								; state 8: text palette job (EALogoTextPalette, 16 colours from colour
									; $10), next state $D
	lda.w #EALogoTextPalette
	sta.b tmp2
	lda.w #$009A
	sta.b tmp3
	lda.w #$0010
	sta.b tmp0
	lda.w #$0010
	sta.b tmp1
	lda.w #$0008
	tsb.b introHookFlags
	lda.w #$000D
	sta.b d4+2
	jmp.w .20
.15:								; state 9: skipped: state 5; else prepare the E palette ($30) fade and go
									; to state 1 with d5 = 5
	lda.b d5+2
	beq .t1xxxxxxx
.1xxxxxxxx:							; go to state 5
	lda.w #$0005
	sta.b d4+2
	jmp.w .20

.t1xxxxxxx:							; E palette to colours from $30, d5 = 5, fade in state 1
	lda.w #EALogoEPalette
	sta.b p0
	lda.w #EALogoEPalette>>16
	sta.b p0+2
	lda.w #$0030
	sta.b tmp0
	jsr.w .29
	lda.w #$0005
	sta.b d5
	lda.w #$0001
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
	lda.w #$0040
	sta.b tmp0
	jsr.w .29
	lda.w #$0007
	sta.b d5
	lda.w #$0001
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
	lda.w #$0020
	sta.b tmp0
	jsr.w .29
	lda.w #$000C
	sta.b d5
	lda.w #$0001
	sta.b d4+2
	jmp.w .20
.18:								; state 12: wait 30 frames in state 2, then go to state 8
	lda.b vcount
	clc
	adc.w #$001E
	sta.b d6+2
	lda.w #$0002
	sta.b d4+2
	lda.w #$0008
	sta.b d5
	jmp.w .20
.19:								; state 13: end test: full brightness and d7 reached, then a button or the
									; d6 timeout ends
	lda.w brightness
	cmp.w #$000F
	bne .20
	lda.b vcount
	cmp.b d7
	bmi .20
	lda.w JoyPad
	bne .t1xxxxxxxxxx
	lda.b vcount
	cmp.b d6
	bmi .20
	bra .t1xxxxxxxxxx

.t1xxxxxxxxxx:						; A = 1: end
	lda.w #$0001
	bra .21
.20:								; A = 0: go on
	lda.w #$0000
.21:								; return
	rts
.22:								; set the Mode 7 centre (X $200, Y $200) and the matrix to $100 0 0 $100
	sep #$20
	lda.b #$00
	sta.w M7X
	lda.b #$02
	sta.w M7X
	lda.b #$00
	sta.w M7Y
	lda.b #$02
	sta.w M7Y
	stz.w M7A
	lda.b #$01
	sta.w M7A
	stz.w M7B
	stz.w M7B
	stz.w M7C
	stz.w M7C
	stz.w M7D
	lda.b #$01
	sta.w M7D
	rep #$20
	jsr.w .23
	rts
.23:								; matrix A and D = $100 (normal size)
	lda.w #$0100
	sta.b introM7A
	sta.b introM7D
	rts
.24:								; matrix A and D = 1 (smallest)
	lda.w #$0001
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
	ldy.w #$0006
	stz.b d0+2
.loopxx:							; next row, x = buffer offset of its start
	lda.b d0+2
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$0037
	asl a
	tax
	stz.b d0
	sep #$20
.loop2xx:							; one byte, copied or zero
	lda.b d1
	beq .1xxxxxxxxxx
	lda.b [p0],y
.1xxxxxxxxxx:						; store it in the buffer
	sta.l introbuf+$40,x
	iny
	inx
	inx
	inc.b d0
	lda.b d0
	cmp.b #$12
	bmi .loop2xx
	rep #$20
	inc.b d0+2
	lda.b d0+2
	cmp.w #$000A
	bmi .loopxx
	rts

.t1xxxxxxxxxxx:						; unreferenced entry: 16-bit registers, fall into .28
	rep #$30
.28:								; send the buffer to VRAM word $1C00 ($A00 bytes), keeping p0
	lda.b p0
	pha
	lda.b p0+2
	pha
	lda.w #introbuf+$40
	sta.b p0
	lda.w #(introbuf+$40)>>16
	sta.b p0+2
	ldx.w #$1C00
	lda.w #$0A00
	jsl.l .t1xxxxxxxxxxxx
	pla
	sta.b p0+2
	pla
	sta.b p0
	rtl

.t1xxxxxxxxxxxx:					; DMA channel 0, A = byte count, x = VRAM address, source p0
	php
	sta.w DAS0L
	lda.b p0
	sta.w A1T0L
	stx.w VMADDL
	sep #$20
	lda.b p0+2
	sta.w A1B0
	lda.b #$01
	sta.w DMAP0
	lda.b #$18
	sta.w BBAD0
	lda.b #$01
	sta.w MDMAEN
	rep #$30
	plp
	rtl
.29:								; palette job: copy 16 words from [p0] to the buffer, source tmp2/3 =
									; buffer, tmp1 = $10
	lda.w #introbuf
	sta.b p1
	lda.w #introbuf>>16
	sta.b p1+2
	jsr.w .32
	lda.w #$0010
	sta.b tmp1
	lda.w #introbuf
	sta.b tmp2
	lda.w #introbuf>>16
	sta.b tmp3
	rts
.30:								; one fade step on the 16 palette words in the buffer: every colour
									; component +1 up to 31, returns A = 1 if all are white
	ldx.w #$0000
	ldy.w #$0001
.loopxxx:							; next colour
	lda.l introbuf,x
	pha
	and.w #$001F
	cmp.w #$001F
	beq .1xxxxxxxxxxx
	clc
	adc.w #$0001
	and.w #$001F
.1xxxxxxxxxxx:						; red done
	sta.l introbuf,x
	pla
	pha
	and.w #$03E0
	cmp.w #$03E0
	beq .2xxxxx
	clc
	adc.w #$0020
	and.w #$03E0
.2xxxxx:							; green done
	ora.l introbuf,x
	sta.l introbuf,x
	pla
	and.w #$7C00
	cmp.w #$7C00
	beq .3x
	clc
	adc.w #$0400
	and.w #$7C00
.3x:								; blue done
	ora.l introbuf,x
	sta.l introbuf,x
	and.w #$7FFF
	cmp.w #$7FFF
	beq .4x
	ldy.w #$0000
.4x:								; not white yet: result 0
	inx
	inx
	cpx.w #$0020
	bmi .loopxxx
	tya
	rts
.31:								; fill CGRAM from colour y with colour A, x + 1 entries
	sep #$30
	sty.w CGADD
.loopxxxx:							; write one colour
	sta.w CGDATA
	xba
	sta.w CGDATA
	xba
	dex
	bpl .loopxxxx
	rep #$30
	rtl
.32:								; copy $20 bytes from [p0] to [p1]
	ldy.w #$0000
.loopxxxxx:							; copy a word
	lda.b [p0],y
	sta.b [p1],y
	iny
	iny
	cpy.w #$0020
	bmi .loopxxxxx
	rts
.framehook:							; the frame hook of this sequence
	rep #$30
	lda.b introHookFlags
	bit.w #$0080
	beq .t1xxxxxxxxxxxxx
	jsl.l .28
	lda.w #$0080
	trb.b introHookFlags
	jmp.w .3xx

.t1xxxxxxxxxxxxx:					; job $08: send the palette in tmp2/3 (colour tmp0, count tmp1), and with
									; $200 the second one
	lda.b introHookFlags
	bit.w #$0008
	beq .3xx
	lda.b p0
	pha
	lda.b p0+2
	pha
	lda.b tmp2
	sta.b p0
	lda.b tmp3
	sta.b p0+2
	ldy.b tmp0
	ldx.b tmp1
	jsl.l DMAToCGRAM
	lda.b introHookFlags
	bit.w #$0200
	beq .2xxxxxx
.1xxxxxxxxxxxx:						; second palette from introPal2Src
	lda.b introPal2Src
	sta.b p0
	lda.b introPal2Src+2
	sta.b p0+2
	ldy.b tmp4
	ldx.b tmp5
	jsl.l DMAToCGRAM
.2xxxxxx:							; restore p0, clear the jobs
	pla
	sta.b p0+2
	pla
	sta.b p0
	lda.w #$0208
	trb.b introHookFlags
.3xx:								; job $10: set the BG1 scroll registers
	lda.b introHookFlags
	bit.w #$0010
	beq .1xxxxxxxxxxxxx
	sep #$20
	lda.b introBG1H
	sta.w BG1HOFS
	lda.b introBG1H+1
	sta.w BG1HOFS
	lda.b introBG1V
	sta.w BG1VOFS
	lda.b introBG1V+1
	sta.w BG1VOFS
	rep #$20
	lda.w #$0010
	trb.b introHookFlags
.1xxxxxxxxxxxxx:					; job $40: set the Mode 7 matrix A and D
	lda.b introHookFlags
	bit.w #$0040
	beq .rtl
	sep #$20
	lda.b introM7A
	sta.w M7A
	lda.b introM7A+1
	sta.w M7A
	lda.b introM7D
	sta.w M7D
	lda.b introM7D+1
	sta.w M7D
	rep #$20
	lda.w #$0040
	trb.b introHookFlags
.rtl:								; return
	rtl
.33:								; set the video registers from the table at p0 (BGMODE, M7SEL, TM, TS,
									; BG1-4SC, BG12NBA, BG34NBA)
	sep #$20
	lda.b #$03
	sta.w OBSEL
	lda.b #$80
	sta.w VMAIN
	ldy.w #$0000
	lda.b [p0],y
	sta.w BGMODE
	iny
	lda.b [p0],y
	sta.w M7SEL
	iny
	lda.b [p0],y
	sta.w TM
	iny
	lda.b [p0],y
	sta.w TS
	iny
	iny
	lda.b [p0],y
	iny
	ora.b [p0],y
	sta.w BG1SC
	iny
	iny
	lda.b [p0],y
	iny
	ora.b [p0],y
	sta.w BG2SC
	iny
	iny
	lda.b [p0],y
	iny
	ora.b [p0],y
	sta.w BG3SC
	iny
	iny
	lda.b [p0],y
	iny
	ora.b [p0],y
	sta.w BG4SC
	iny
	iny
	lda.b [p0],y
	lsr a
	lsr a
	lsr a
	lsr a
	iny
	iny
	ora.b [p0],y
	sta.w BG12NBA
	iny
	iny
	lda.b [p0],y
	lsr a
	lsr a
	lsr a
	lsr a
	iny
	iny
	ora.b [p0],y
	sta.w BG34NBA
	rep #$20
	rtl
	db $00
	padbyte $FF
	pad $A08000
