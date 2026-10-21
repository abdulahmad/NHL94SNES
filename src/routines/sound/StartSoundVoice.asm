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
	cmp.w #$DFB0					;the other one?
	bne .2							;no
.1:									; these two need a positive length
	lda.b EventData2				;length
	bmi .3							;negative: skip
	beq .3							;none: skip
.2:									; find a voice
	sep #$30
	jsr.w FindFreeVoice				; find a free voice, else take the best voice of lower priority
	stx.b CurVoice					;voice
	txa								;CurVoice
	bpl .t1							;found?
.3:									; no voice: leave
	plp
	rts

.t1:								; voice found: it plays this track
	asl a							;x2
	sta.w VoiceOfs					;word index
	lda.b CurTrack					;track
	sta.w VoiceTrack,x				;voice plays it
	ldy.b #$2A						;priority byte
	lda.b (InstPtr),y				;instrument priority
	sta.w VoicePriority,x			;voice priority
	ldy.b #$15						;flags byte
	lda.b (InstPtr),y				;instrument flags
	bpl .t2							; bit 7 of instrument byte $15 selects the voice state
	lda.b #$02						;state 2
	bra .4

.t2:								; bit 7 clear: state 1
	lda.b #$01
.4:									; state 1 or 2
	sta.w VoiceState,x
	ldx.w VoiceOfs					;voice word index
	rep #$20
	lda.b InstPtr					;instrument
	cmp.w #$E130					;the long one?
	bne .t1x						;no
	lda.w #$002D					;fixed length 45
	bra .5

.t1x:								; length from EventData2
	lda.b EventData2
.5:									; length - 1
	dec a							;minus 1
	sta.w VoiceLength,x				;note length
	stz.w VoiceAge,x				;age 0
	stz.w VoiceVibCount,x			;vibrato counter 0
	stz.w VoiceVibOfs,x				;vibrato offset 0
	ldy.b #$1C						;vibrato rate byte
	lda.b (InstPtr),y
	sta.w VoiceVibRate,x			;rate
	stz.w VoiceVibRateFrac,x		;fraction 0
	ldy.b #$20						;vibrato depth byte
	lda.b (InstPtr),y
	sta.w VoiceVibDepth,x			;depth
	stz.w VoiceVibDepthFrac,x		;fraction 0
	ldy.b #$1E						;vibrato speed byte
	lda.b (InstPtr),y
	sta.w VoiceVibSpeed,x			;speed
	stz.w VoiceVibSpeedFrac,x		;fraction 0
	ldy.b #$2D						;vibrato direction byte
	lda.b (InstPtr),y
	bmi .t1xx						;set: up
	lda.w #$FFFF					;down
	bra .6

.t1xx:								; vibrato direction word
	lda.w #$0000
.6:									; set the vibrato direction
	sta.w VoiceVibDir,x
	ldy.b #$0A						;gain byte
	lda.b (InstPtr),y
	sta.w VoiceGain,x				;voice gain
	sta.b StartGain					;keep it
	lda.b CurTrack					;track
	and.w #$00FF
	cmp.w #$0010					;sound effect track $10?
	bne .1x							;no
	lda.w sflags					;flags
	bit.w #$0800					;replay?
	bne .1x							;yes: don't record
	lda.b StartGain					;gain
	sta.w recsfxvol					;record the volume
.1x:								; remember the instrument
	lda.b InstPtr
	sta.w VoiceInst,x
	sep #$20
	ldx.b EventData1				;velocity
	lda.l VolumeCurve,x				;volume for it
	and.b #$FF
	cmp.b #$40						;$40: full?
	bne .t1xxx						;no: scale
	ldx.b CurTrack					;track
	lda.w TrackVolL,x				;track left volume
	sta.w VoiceVolL					;as is
	iny
	lda.w TrackVolR,x				;track right volume
	sta.w VoiceVolR					;as is
	jmp.w .7						;done

.t1xxx:								; scaled velocity
	asl a							;x2
	sta.b EventData1				;scaled velocity
	ldx.b CurVoice
	sta.w VoiceVelocity,x			;voice velocity
	ldx.b CurTrack
	xba								;velocity into B
	lda.w TrackVolL,x				;track left volume
	jsr.w MulFrac8					;times the velocity
	sta.w VoiceVolL					;left
	lda.b EventData1
	xba
	lda.w TrackVolR,x				;velocity into B
	jsr.w MulFrac8					;track right volume
	sta.w VoiceVolR					;times the velocity
.7:									;right
	lda.w MusicDuck					;duck the music?
	beq .1xx						;no
	lda.b CurTrack					;track
	cmp.b #$10						;sound effects track?
	beq .1xx						;yes: no ducking
	lsr.w VoiceVolR					;half
	lsr.w VoiceVolL
	lda.w MusicDuck					;ducking more?
	bpl .1xx						;no
	lsr.w VoiceVolR					;quarter
	lsr.w VoiceVolL
.1xx:								; note = event code + instrument transpose
	ldy.b #$04
	lda.b EventCode					;note
	clc
	adc.b (InstPtr),y				;plus the transpose
	sta.b EventCode					;note
	ldx.b CurVoice
	sta.w VoiceNote,x				;voice note
	ldx.b CurTrack					;track
	cpx.b #$09						;track 9 (drums)?
	bne .2x							;no
	lda.b #$3F						;fixed note $3F
	clc
	adc.b (InstPtr),y				;plus the transpose
.2x:								; table index
	asl a							;word index
	tax
	rep #$20
	lda.l PitchTable,x				;pitch of the note
	ldx.w VoiceOfs					;voice word index
	sta.w VoiceBasePitch,x			;base pitch
	sta.b EventData1				;EventData1
	sep #$20
	ldy.b CurTrack					;track
	lda.w TrackBendRange,y			;bend range
	beq .9							;none
	lda.w TrackBend,y				;bend
	beq .9							;none
	bmi .t2x						;down
	lda.b EventCode					;note
	clc
	adc.w TrackBendRange,y			;plus the range
	asl a							;word index
	tax
	rep #$20
	lda.l PitchTable,x				;pitch at the top
	sec
	sbc.b EventData1				;minus the base
	sta.b EventData2				;range in pitch
	sep #$20
	lda.w TrackBend,y				;bend amount
	tay
	rep #$20						;scaled
	lda.b EventData2
	jsr.w MulFrac16					;times the range
	clc
	adc.b EventData1				;plus the base
	sta.b EventData1				;bent pitch
	bra .9

.t2x:								; bend down
	lda.b EventCode					;note
	sec
	sbc.w TrackBendRange,y			;minus the range
	asl a							;word index
	tax
	rep #$20
	lda.b EventData1				;base
	sec
	sbc.l PitchTable,x				;minus the pitch at the bottom
	sta.b EventData2				;range in pitch
	sep #$20
	lda.b #$00						;0
	sec
	sbc.w TrackBend,y				;minus the bend
	bpl .t1xxxx						;positive amount
	rep #$20
	lda.b EventData2				;full range
	sta.b MulFracResult				;result
	bra .8

.t1xxxx:							; scale the pitch difference
	tay								;amount
	rep #$20
	lda.b EventData2
	jsr.w MulFrac16					;times the range
.8:									; base pitch - scaled difference
	lda.b EventData1
	sec
	sbc.b MulFracResult
	sta.b EventData1				;minus the bend
.9:									;bent pitch
	rep #$20
	ldy.b #$02						;tuning byte
	lda.b (InstPtr),y
	ldx.w VoiceOfs					;voice word index
	clc
	adc.b EventData1				;plus the bent pitch
	sta.w VoicePitch,x				;voice pitch
	lda.b CurTrack					;track
	and.w #$00FF
	cmp.w #$0010					;sound effects?
	bne .1xxx						;no
	lda.w sflags					;flags
	bit.w #$0800					;replay?
	bne .1xxx						;yes: don't record
	lda.w VoicePitch,x				;pitch
	sta.w recsfxpitch				;record it
.1xxx:								; send the voice to the sound CPU
	sep #$20
	jsr.w SeqCmd07					;send it
	tya								;voice in A
	plp
	rts
