; Each frame: step the sound effect voices (owner VoiceTrack $10 and up): their time and envelope counters,
; the voice commands, and StopVoice when one ends
; Takes nothing. For each of the 8 voices in use (Y = voice, X = 2*voice): voices of tracks $10 and up are
; updated with UpdateVoice, VoiceAge counts up, and between the instrument's vibrato start and end ages the
; vibrato offset VoiceVibOfs is stepped. Then by voice state: state 2 sends the pitch (SeqCmd0B), state 4
; (releasing) lowers the gain by instrument byte $10 and stops the voice at 0, others send gain and pitch.
;
; Called from SoundUpdate.
UpdateSfxVoices:					; step the sound effect voices
	ldx.b #$00
	txy
.3:									; each voice
	sty.b CurVoice
	stx.w VoiceOfs
	lda.w VoiceState,y
	bne .t1
	jmp.w .6

.t1:								; voice in use: keep its state
	pha
	lda.w VoiceTrack,y
	cmp.b #$10
	bcc .1
	jsr.w UpdateVoice				; update voice Y
.1:									; copy the instrument, pitch and gain of the voice
	rep #$20
	lda.w VoiceInst,x
	sta.b InstPtr
	lda.w VoicePitch,x
	sta.b SendPitch
	lda.w VoiceGain,x
	sta.b GainWord
	lda.w VoiceAge,x
	inc a
	sta.w VoiceAge,x
	ldy.b #$1A
	cmp.b (InstPtr),y
	bcs .2
	ldy.b #$18
	cmp.b (InstPtr),y
	bcc .2
	dec.w VoiceVibCount,x
	bmi .t3
.2:									; outside the vibrato ages
	jmp.w .5

.t3:								; vibrato counter ran out: advance rate, depth and speed
	ldy.b #$2A
	lda.b (InstPtr),y
	clc
	adc.w VoiceVibRateFrac,x
	sta.w VoiceVibRateFrac,x
	iny
	iny
	lda.b (InstPtr),y
	adc.w VoiceVibRate,x
	sta.w VoiceVibRate,x
	sta.w VoiceVibCount,x
	ldy.b #$26
	lda.b (InstPtr),y
	clc
	adc.w VoiceVibDepthFrac,x
	sta.w VoiceVibDepthFrac,x
	iny
	iny
	lda.b (InstPtr),y
	adc.w VoiceVibDepth,x
	sta.w VoiceVibDepth,x
	ldy.b #$22
	lda.b (InstPtr),y
	clc
	adc.w VoiceVibSpeedFrac,x
	sta.w VoiceVibSpeedFrac,x
	iny
	iny
	lda.b (InstPtr),y
	adc.w VoiceVibSpeed,x
	sta.w VoiceVibSpeed,x
	bit.w VoiceVibDir,x
	bmi .t2
	clc
	adc.w VoiceVibOfs,x
	sta.w VoiceVibOfs,x
	bmi .4
	cmp.w VoiceVibDepth,x
	bcc .4
	ldy.b #$2D
	lda.b (InstPtr),y
	and.w #$4000
	bne .t1x
.1x:								; restart the vibrato offset
	stz.w VoiceVibOfs,x
	bra .4

.t1x:								; vibrato goes back down
	dec.w VoiceVibDir,x
	bra .4

.t2:								; vibrato offset going down
	lda.w VoiceVibOfs,x
	sec
	sbc.w VoiceVibSpeed,x
	sta.w VoiceVibOfs,x
	bpl .4
	eor.w #$FFFF
	inc a
	cmp.w VoiceVibDepth,x
	bcc .4
	ldy.b #$2D
	lda.b (InstPtr),y
	bmi .t1xx
	stz.w VoiceVibOfs,x
	bra .4

.t1xx:								; vibrato goes up again
	inc.w VoiceVibDir,x
.4:									; add the vibrato offset to the pitch
	lda.w VoiceVibOfs,x
	clc
	adc.b SendPitch
	sta.b SendPitch
.5:									; act on the voice state
	ply
	cpy.b #$02
	bne .7
	sep #$20
	ldy.b CurVoice
	jsr.w SeqCmd0B
.6:									; unused voice
	jmp.w .8
.7:									; state 4 (releasing)?
	cpy.b #$04
	bne .t2x
	rep #$20
	ldy.b #$10
	lda.w VoiceGain,x
	sec
	sbc.b (InstPtr),y
	sta.w VoiceGain,x
	bcs .t1xxx
	sep #$20
	ldy.b CurVoice
	jsr.w StopVoice					; stop voice Y
	bra .8

.t1xxx:								; gain still above 0: send it
	sep #$20
	ldy.b CurVoice
	jsr.w SeqCmd0B
	bra .8

.t2x:								; other states: send gain and pitch
	sep #$20
	ldy.b CurVoice
	jsr.w SeqCmd0C0B
.8:									; next voice
	sep #$20
	inx
	inx
	iny
	cpy.b #$08
	bcs .t1xxxx
	jmp.w .3

.t1xxxx:							; all voices done
	rts
