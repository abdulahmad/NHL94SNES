; Put sound entry $4E on a free voice (FindFreeVoice) with its pitch, volume and envelope (SeqCmd07)
; Takes X = 2*track, CurTrack, TrackInst,x = instrument entry (InstPtr), EventCode = note, EventData1 =
; velocity, EventData2 = length. Finds a free voice with FindFreeVoice (nothing happens when none is
; free, the track has no instrument or a length-less note of two special instruments is asked) and fills in
; its track, priority, state, length, vibrato, gain, volumes and pitch (with the pitch bend) from the entry,
; then SeqCmd07 sends them to the sound CPU. Returns with the voice in Y.
;
; Called from PlaySound and StepTrack.
StartSoundVoice:					; start the note on a voice
	php
	rep #$20
	lda.w TrackInst,x				; instrument entry of the track
	beq .3							; none: nothing to start
	sta.b InstPtr
	cmp.w #$DF80					; two special instruments need a length
	beq .1
	cmp.w #$DFB0
	bne .2
.1:									; these two need a positive length
	lda.b EventData2
	bmi .3
	beq .3
.2:									; find a voice
	sep #$30
	jsr.w FindFreeVoice				; find a free voice, else take the best voice of lower priority
	stx.b CurVoice
	txa
	bpl .t1
.3:									; no voice: leave
	plp
	rts

.t1:								; voice found: it plays this track
	asl a
	sta.w VoiceOfs
	lda.b CurTrack
	sta.w VoiceTrack,x
	ldy.b #$2A
	lda.b (InstPtr),y
	sta.w VoicePriority,x
	ldy.b #$15
	lda.b (InstPtr),y
	bpl .t2							; bit 7 of instrument byte $15 selects the voice state
	lda.b #$02
	bra .4

.t2:								; bit 7 clear: state 1
	lda.b #$01
.4:									; state 1 or 2
	sta.w VoiceState,x
	ldx.w VoiceOfs
	rep #$20
	lda.b InstPtr
	cmp.w #$E130
	bne .t1x
	lda.w #$002D
	bra .5

.t1x:								; length from EventData2
	lda.b EventData2
.5:									; length - 1
	dec a
	sta.w VoiceLength,x
	stz.w VoiceAge,x
	stz.w VoiceVibCount,x
	stz.w VoiceVibOfs,x
	ldy.b #$1C
	lda.b (InstPtr),y
	sta.w VoiceVibRate,x
	stz.w VoiceVibRateFrac,x
	ldy.b #$20
	lda.b (InstPtr),y
	sta.w VoiceVibDepth,x
	stz.w VoiceVibDepthFrac,x
	ldy.b #$1E
	lda.b (InstPtr),y
	sta.w VoiceVibSpeed,x
	stz.w VoiceVibSpeedFrac,x
	ldy.b #$2D
	lda.b (InstPtr),y
	bmi .t1xx
	lda.w #$FFFF
	bra .6

.t1xx:								; vibrato direction word
	lda.w #$0000
.6:									; set the vibrato direction
	sta.w VoiceVibDir,x
	ldy.b #$0A
	lda.b (InstPtr),y
	sta.w VoiceGain,x
	sta.b StartGain
	lda.b CurTrack
	and.w #$00FF
	cmp.w #$0010
	bne .1x
	lda.w sflags
	bit.w #$0800
	bne .1x
	lda.b StartGain
	sta.w recsfxvol
.1x:								; remember the instrument
	lda.b InstPtr
	sta.w VoiceInst,x
	sep #$20
	ldx.b EventData1
	lda.l VolumeCurve,x
	and.b #$FF
	cmp.b #$40
	bne .t1xxx
	ldx.b CurTrack
	lda.w TrackVolL,x
	sta.w VoiceVolL
	iny
	lda.w TrackVolR,x
	sta.w VoiceVolR
	jmp.w .7

.t1xxx:								; scaled velocity
	asl a
	sta.b EventData1
	ldx.b CurVoice
	sta.w VoiceVelocity,x
	ldx.b CurTrack
	xba
	lda.w TrackVolL,x
	jsr.w MulFrac8					; A * B / 128 into A
	sta.w VoiceVolL
	lda.b EventData1
	xba
	lda.w TrackVolR,x
	jsr.w MulFrac8					; A * B / 128 into A
	sta.w VoiceVolR
.7:									; music ducking
	lda.w MusicDuck
	beq .1xx
	lda.b CurTrack
	cmp.b #$10
	beq .1xx
	lsr.w VoiceVolR
	lsr.w VoiceVolL
	lda.w MusicDuck
	bpl .1xx
	lsr.w VoiceVolR
	lsr.w VoiceVolL
.1xx:								; note = event code + instrument transpose
	ldy.b #$04
	lda.b EventCode
	clc
	adc.b (InstPtr),y
	sta.b EventCode
	ldx.b CurVoice
	sta.w VoiceNote,x
	ldx.b CurTrack
	cpx.b #$09
	bne .2x
	lda.b #$3F
	clc
	adc.b (InstPtr),y
.2x:								; table index
	asl a
	tax
	rep #$20
	lda.l PitchTable,x
	ldx.w VoiceOfs
	sta.w VoiceBasePitch,x
	sta.b EventData1
	sep #$20
	ldy.b CurTrack
	lda.w TrackBendRange,y
	beq .9
	lda.w TrackBend,y
	beq .9
	bmi .t2x
	lda.b EventCode
	clc
	adc.w TrackBendRange,y
	asl a
	tax
	rep #$20
	lda.l PitchTable,x
	sec
	sbc.b EventData1
	sta.b EventData2
	sep #$20
	lda.w TrackBend,y
	tay
	rep #$20
	lda.b EventData2
	jsr.w MulFrac16
	clc
	adc.b EventData1
	sta.b EventData1
	bra .9

.t2x:								; bend down
	lda.b EventCode
	sec
	sbc.w TrackBendRange,y
	asl a
	tax
	rep #$20
	lda.b EventData1
	sec
	sbc.l PitchTable,x
	sta.b EventData2
	sep #$20
	lda.b #$00
	sec
	sbc.w TrackBend,y
	bpl .t1xxxx
	rep #$20
	lda.b EventData2
	sta.b MulFracResult
	bra .8

.t1xxxx:							; scale the pitch difference
	tay
	rep #$20
	lda.b EventData2
	jsr.w MulFrac16
.8:									; base pitch - scaled difference
	lda.b EventData1
	sec
	sbc.b MulFracResult
	sta.b EventData1
.9:									; add the instrument tuning to get the voice pitch
	rep #$20
	ldy.b #$02
	lda.b (InstPtr),y
	ldx.w VoiceOfs
	clc
	adc.b EventData1
	sta.w VoicePitch,x
	lda.b CurTrack
	and.w #$00FF
	cmp.w #$0010
	bne .1xxx
	lda.w sflags
	bit.w #$0800
	bne .1xxx
	lda.w VoicePitch,x
	sta.w recsfxpitch
.1xxx:								; send the voice to the sound CPU
	sep #$20
	jsr.w SeqCmd07
	tya
	plp
	rts
