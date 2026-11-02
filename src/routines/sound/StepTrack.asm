; Track X: count down its wait, or play its events until the next wait
; Takes X = track number (0-16), stores it in CurTrack and its word offset in CurTrackOfs. If TrackWait is
; nonzero it is counted down. Otherwise events are read with ReadTrackEvent until one gives a wait: below $D9
; is a note (starts a voice), $D9 and up are commands. Returns with 8-bit registers and X = track.
;
; Called from SequencerTick.
StepTrack:							; step one sequencer track
	txa
	sta.b CurTrack					;track number
	asl a							;x2
	tax
	stx.w CurTrackOfs				;word offset
.1:									; main loop: is the track waiting?
	rep #$20
	lda.w TrackWait,x				;frames left to wait
	beq .t1							;none: read events
	jmp.w .13						;count down

.t1:								; wait over: load the track pointer
	lda.w TrackPtr,x
	sta.b CurTrackPtr				;read from here
.2:									; read the next event
	jsr.w ReadTrackEvent			;code and data at CurTrackPtr
	lda.b EventPtr					;past the event
	sta.b CurTrackPtr				;advance
	ldx.w CurTrackOfs				;track word offset
	ldy.b EventCode					;event code
	cpy.b #$D9						;command?
	bcs .t1x
	jmp.w .11						;no: a note

.t1x:								; $D9 and up are commands
	cpy.b #$D9						;$D9?
	beq .1x
	cpy.b #$DA						;$DA?
	bne .t3
.1x:								; $D9 / $DA: stop the music
	jsl.l MusicStop					; stop the song: release its voices and clear its tracks
	jmp.w .14

.t3:								; $E2: loop start
	cpy.b #$E2
	bne .t1xx
	lda.w TrackPtr,x				;position after it
	sta.w TrackLoop,x				;loop start
	jmp.w .12

.t1xx:								; $DB: loop end, jump back to the loop start
	cpy.b #$DB
	bne .t2
	lda.w TrackLoop,x				;loop start
	sta.w TrackPtr,x				;jump back
	bra .1

.t2:								; $DD: set the tempo
	cpy.b #$DD
	bne .t1xxx
.1xx:								; TempoTick = event data
	ldy.b EventData1				;tempo
	sty.w TempoTick
	jmp.w .12

.t1xxx:								; $DE: track volume
	cpy.b #$DE
	beq .3
	jmp.w .10
.3:									; set the track volume from the event data and the instrument
	lda.w TrackInst,x				;instrument entry
	sta.b InstPtr
	sep #$20
	lda.w SoundMono					;mono?
	bne .t1xxxx						;yes
	ldy.b #$12						;stereo volume bytes
	lda.b (InstPtr),y				;left
	sta.w InstVolL
	iny
	lda.b (InstPtr),y				;right
	bra .2x

.t1xxxx:							; mono sound: other volume byte of the instrument
	ldy.b #$17
	lda.b (InstPtr),y				;mono volume
	sta.w InstVolL
.2x:								; both channels start from the instrument volume
	sta.w InstVolR
	ldx.b CurTrack					;track
	lda.w InstVolL					;instrument left
	xba								;into B
	lda.b EventData1				;times the event volume
	jsr.w MulFrac8					; A * B / 128 into A
	sta.w TrackVolL,x				;track left
	lda.w InstVolR					;instrument right
	xba								;into B
	lda.b EventData1				;times the event volume
	jsr.w MulFrac8					; A * B / 128 into A
	sta.w TrackVolR,x				;track right
	ldy.b #$07
.loop:								; rescale each voice of this track, Y = voice 7 down to 0
	lda.w VoiceTrack,y				;voice track
	cmp.b CurTrack					;this track?
	bne .1xxx						;no
	ldx.b CurTrack
	lda.w TrackVolL,x				;track left
	xba								;into B
	lda.w VoiceVelocity,y			;times the voice velocity
	jsr.w MulFrac8					; A * B / 128 into A
	sta.w VoiceVolL					;left
	lda.w TrackVolR,x				;track right
	xba								;into B
	lda.w VoiceVelocity,y			;times the voice velocity
	jsr.w MulFrac8					; A * B / 128 into A
	sta.w VoiceVolR					;right
.loop2:								; wait for the SPC port to be free
	lda.w APUIO0					;busy?
	bne .loop2
	lda.w VoiceVolR
	sta.w APUIO3					;right
	lda.w VoiceVolL
	sta.w APUIO2					;left
	sty.w APUIO1					;voice
	lda.b #$0E						;command $0E: voice volume
	sta.w APUIO0					;send
.loop3:								; wait for the SPC to acknowledge the command
	cmp.w APUIO0					;echoed?
	bne .loop3
	stz.w APUIO0					;clear the port
.1xxx:								; next voice
	dey
	bpl .loop
	rep #$20
	jmp.w .12
.4:									; controller $07: use the second data byte
	lda.b EventData2				;value
	sta.b EventData1				;as the volume
	jmp.w .3
.10:								; $DF: controller change?
	cpy.b #$DF
	beq .t1xxxxx
	jmp.w .t5

.t1xxxxx:							; $DF: controller number in EventData1
	ldy.b EventData1				;controller
	cpy.b #$07						;$07 volume?
	beq .4
.1xxxx:								; controller $40: sustain pedal
	cpy.b #$40
	bne .t2x
	sep #$20
	ldx.b CurTrack					;track
	lda.b EventData2				;pedal value
	sta.w TrackSustain,x			;track sustain
	bne .3x							;down: keep the voices
	ldx.b #$07
.loopx:								; pedal released: release this track's voices
	lda.w VoiceTrack,x				;voice track
	cmp.b CurTrack					;this track?
	bne .2xx
	lda.w VoiceState,x				;state
	beq .2xx						;silent
	phx								;save the counter
	txy								;voice in Y
	txa
	asl a							;word offset in X
	tax
	rep #$20
	jsr.w ReleaseVoice				; put voice Y into its release
	sep #$20
	plx
.2xx:								; next voice
	dex
	bpl .loopx
.3x:								; done with the controller
	rep #$20
	jmp.w .12

.t2x:								; controller $0B: left volume
	cpy.b #$0B
	bne .t1xxxxxx
	sep #$20
	ldx.b CurTrack
	lda.b EventData2				;value
	sta.w TrackVolL,x				;track left
	rep #$20
	jmp.w .12

.t1xxxxxx:							; controller $0C: right volume
	cpy.b #$0C
	bne .t4
	sep #$20
	ldx.b CurTrack
	lda.b EventData2				;value
	sta.w TrackVolR,x				;track right
	rep #$20
	jmp.w .12

.t4:								; controller $32: echo voices
	cpy.b #$32
	bne .t1x2
	sep #$20
	lda.b EventData2				;value
	sta.w EchoVoices				;echo voices
	jsr.w SeqCmd08					;send the echo settings
	rep #$20
	jmp.w .12

.t1x2:								; controller $33: echo delay
	cpy.b #$33
	bne .t2xx
	sep #$20
	lda.b EventData2				;value
	sta.w EchoDelay					;delay
	jsr.w SeqCmd08					;send the echo settings
	rep #$20
	jmp.w .12

.t2xx:								; controller $34: echo volume
	cpy.b #$34
	bne .t1xxxxxxx
	sep #$20
	lda.b EventData2				;value
	sta.w EchoVolume				;volume
	jsr.w SeqCmd08					;send the echo settings
	rep #$20
	jmp.w .12

.t1xxxxxxx:							; controller $35: echo feedback
	cpy.b #$35
	bne .t3x
	sep #$20
	lda.b EventData2				;value
	sta.w EchoFeedback				;feedback
	jsr.w SeqCmd08					;send the echo settings
	rep #$20
	jmp.w .12

.t3x:								; controller $37: master volume high byte
	cpy.b #$37
	bne .t1x2x
	sep #$20
	lda.b EventData2				;value
	sta.w SoundVolume+1				;master volume
	jsr.w SeqCmd08Init_send			;send the settings
	rep #$20
	jmp.w .12

.t1x2x:								; controller $38: ignored
	cpy.b #$38
	bne .t2xxx
	jmp.w .12

.t2xxx:								; controller $39: noise voices
	cpy.b #$39
	bne .t1xxxxxxxx
	sep #$20
	lda.b EventData2				;value
	sta.w NoiseVoices				;noise voices
	jsr.w SeqCmd08Init_send			;send the settings
	rep #$20
	jmp.w .12

.t1xxxxxxxx:						; controller $3A: ignored
	cpy.b #$3A
	bne .1xxxxx
.1xxxxx:							; unknown controller: ignored
	jmp.w .12

.t5:								; $E5: pitch bend?
	cpy.b #$E5
	beq .t2x2
	jmp.w .9

.t2x2:								; $E5: pitch bend, scale the bend byte to a signed value
	lda.b EventData2				;14-bit bend, high byte bits
	sep #$20
	asl a							;align
	rep #$20
	sec
	sbc.w #$4000					;centre $4000 -> 0
	asl a							;scale
	sep #$20
	xba								;signed high byte
	ldx.b CurTrack					;track
	sta.w TrackBend,x				;track bend
	sta.b BendAmount				;bend amount
	lda.w TrackBendRange,x			;bend range
	bne .t1x3
.1x2:								; no bend range: nothing to do
	jmp.w .8

.t1x3:								; bend range of the track in EventCode
	sta.b EventCode
	ldy.b #$07
.4x:								; each voice of this track, Y = 7 down to 0
	lda.w VoiceTrack,y				;voice track
	cmp.b CurTrack					;this track?
	beq .t3xx
	jmp.w .7

.t3xx:								; this voice belongs to the track
	phy								;voice
	tya
	asl a							;x2
	tax								;word offset
	phx								;saved
	lda.b BendAmount				;bend amount
	beq .t1xxxxxxxxx				;none
	bmi .t2xxxx						;down
	lda.w VoiceNote,y				;note
	clc
	adc.b EventCode					;plus the range
	asl a							;word index
	tax
	rep #$20
	lda.l PitchTable,x				;pitch at the top
	plx								;voice word offset
	sec
	sbc.w VoiceBasePitch,x			;minus the base
	sta.b EventData2				;range in pitch
	sep #$20
	lda.b BendAmount				;amount
	tay
	rep #$20
	lda.b EventData2				;range
	jsr.w MulFrac16					;times the amount
	clc
	adc.w VoiceBasePitch,x			;plus the base
	sta.b EventData1				;bent pitch
	bra .6

.t1xxxxxxxxx:						; no bend: back to the base pitch
	rep #$20
	plx
	lda.w VoiceBasePitch,x			;base pitch
	sta.b EventData1
	bra .6

.t2xxxx:							; bend down: pitch of the note below
	lda.w VoiceNote,y				;note
	sec
	sbc.b EventCode					;minus the range
	asl a							;word index
	tax
	rep #$20
	lda.l PitchTable,x				;pitch at the bottom
	sta.b EventData1
	plx
	lda.w VoiceBasePitch,x			;base
	sec
	sbc.b EventData1				;minus the bottom
	sta.b EventData2				;range in pitch
	sep #$20
	lda.b #$00						;0
	sec
	sbc.b BendAmount				;minus the amount
	bpl .t1xxxxxxxxxx				;positive amount
	rep #$20
	lda.b EventData2				;full range
	sta.b MulFracResult				;result
	bra .5

.t1xxxxxxxxxx:						; scale the pitch difference
	tay								;amount
	rep #$20
	lda.b EventData2				;range
	jsr.w MulFrac16					;times the amount
.5:									; pitch = base pitch - scaled difference
	lda.w VoiceBasePitch,x
	sec
	sbc.b MulFracResult				;minus the bend
	sta.b EventData1
.6:									; add the instrument tuning and set the voice pitch
	ldy.b #$02						;tuning byte
	lda.b (InstPtr),y
	clc
	adc.b EventData1				;plus the pitch
	sta.w VoicePitch,x				;voice pitch
	ply								;restore the voice
.7:									; next voice
	sep #$20
	dey
	bmi .8
	jmp.w .4x
.8:									; pitch bend done
	rep #$20
	jmp.w .12
.9:									; $DC: program change?
	cpy.b #$DC
	bne .4xx
	lda.b EventData1				;program number
	and.w #$00FF
	cmp.w #$006A					;$6A?
	bne .2xxx
.1xxxxxx:							; instrument $6A is replaced by $14
	lda.w #$0014
.2xxx:								; instrument entry from SoundTable
	asl a							;word index
	tay
	lda.b [SoundTable],y			;offset of the entry
	clc
	adc.b SoundTable				;plus the table base
	sta.w TrackInst,x				;track instrument
	sta.b InstPtr					;pointer
	sep #$20
	ldx.b CurTrack					;track
	ldy.b #$2F						;bend range byte
	lda.b (InstPtr),y
	sta.w TrackBendRange,x			;bend range
	stz.w TrackBend,x				;no bend
	lda.w SoundMono					;mono?
	bne .t1xxxxxxxxxxx
	ldy.b #$12						;stereo volume bytes
	lda.b (InstPtr),y
	sta.w TrackVolL,x				;left
	iny
	lda.b (InstPtr),y				;right
	bra .3xx

.t1xxxxxxxxxxx:						; mono sound: other volume byte of the instrument
	ldy.b #$17						;mono volume
	lda.b (InstPtr),y
	sta.w TrackVolL,x				;left
.3xx:								; right volume of the track
	sta.w TrackVolR,x
.4xx:								; $EA?
	rep #$20
	cpy.b #$EA
	bne .2xxxx
.1xxxxxxx:							; $EA: store the data, never read
	lda.b EventData1				;data
	and.w #$00FF
	sta.b EventEAUnused
.2xxxx:								; command done
	rep #$20
	jmp.w .12
.11:								; note: on track 9 pick the instrument from the note
	sep #$20
	lda.b CurTrack					;track
	cmp.b #$09						;drums track 9?
	bne .1xxxxxxxx
	asl a							;x2
	tax								;word offset
	tya								;note
	sec
	sbc.b #$2F						;minus $2F
	asl a							;word index
	tay
	rep #$20
	lda.b [SoundTable],y			;drum instrument offset
	clc
	adc.b SoundTable				;plus the base
	sta.b InstPtr
	lda.b InstPtr
	sta.w TrackInst,x				;track instrument
	sep #$20
	ldx.b CurTrack					;track
	ldy.b #$12						;stereo volume bytes
	lda.b [InstPtr],y
	sta.w TrackVolL,x				;left
	iny
	lda.b [InstPtr],y				;right
	sta.w TrackVolR,x
	ldy.b #$2F						;bend range byte
	lda.b [InstPtr],y
	sta.w TrackBendRange,x			;bend range
	stz.w TrackBend,x				;no bend
.1xxxxxxxx:							; start the voice
	lda.b CurTrack					;track
	asl a							;x2
	tax								;in X
	rep #$20
	jsr.w StartSoundVoice			; start the note on a voice
.12:								; read the delta time to the next event
	jsr.w ReadVarLen				;delta in A
	ldx.w CurTrackOfs				;track word offset
	cmp.w #$0000					;zero?
	bne .t2xxxxx
	jmp.w .2						;yes: next event now

.t1xxxxxxxxxxxx:					; unused: read the delta again
	rep #$20
	bra .12

.t2xxxxx:							; nonzero: the track waits
	sta.w TrackWait,x				;wait
	lda.b CurTrackPtr				;position
	sta.w TrackPtr,x				;saved
.13:								; count the wait down
	dec.w TrackWait,x
.14:								; return with the track in X
	sep #$30
	ldx.b CurTrack
	rts
