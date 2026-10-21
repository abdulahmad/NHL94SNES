; Track X: count down its wait, or play its events until the next wait
; Takes X = track number (0-16), stores it in CurTrack and its word offset in CurTrackOfs. If TrackWait is
; nonzero it is counted down. Otherwise events are read with ReadTrackEvent until one gives a wait: below $D9
; is a note (starts a voice), $D9 and up are commands. Returns with 8-bit registers and X = track.
;
; Called from SequencerTick.
StepTrack:							; step one sequencer track
	txa
	sta.b CurTrack
	asl a
	tax
	stx.w CurTrackOfs
.1:									; main loop: is the track waiting?
	rep #$20
	lda.w TrackWait,x
	beq .t1
	jmp.w .13

.t1:								; wait over: load the track pointer
	lda.w TrackPtr,x
	sta.b CurTrackPtr
.2:									; read the next event
	jsr.w ReadTrackEvent
	lda.b EventPtr
	sta.b CurTrackPtr
	ldx.w CurTrackOfs
	ldy.b EventCode
	cpy.b #$D9
	bcs .t1x
	jmp.w .11

.t1x:								; $D9 and up are commands
	cpy.b #$D9
	beq .1x
	cpy.b #$DA
	bne .t3
.1x:								; $D9 / $DA: stop the music
	jsl.l MusicStop					; stop the song: release its voices and clear its tracks
	jmp.w .14

.t3:								; $E2: loop start
	cpy.b #$E2
	bne .t1xx
	lda.w TrackPtr,x
	sta.w TrackLoop,x
	jmp.w .12

.t1xx:								; $DB: loop end, jump back to the loop start
	cpy.b #$DB
	bne .t2
	lda.w TrackLoop,x
	sta.w TrackPtr,x
	bra .1

.t2:								; $DD: set the tempo
	cpy.b #$DD
	bne .t1xxx
.1xx:								; TempoTick = event data
	ldy.b EventData1
	sty.w TempoTick
	jmp.w .12

.t1xxx:								; $DE: track volume
	cpy.b #$DE
	beq .3
	jmp.w .10
.3:									; set the track volume from the event data and the instrument
	lda.w TrackInst,x
	sta.b InstPtr
	sep #$20
	lda.w SoundMono
	bne .t1xxxx
	ldy.b #$12
	lda.b (InstPtr),y
	sta.w InstVolL
	iny
	lda.b (InstPtr),y
	bra .2x

.t1xxxx:							; mono sound: other volume byte of the instrument
	ldy.b #$17
	lda.b (InstPtr),y
	sta.w InstVolL
.2x:								; both channels start from the instrument volume
	sta.w InstVolR
	ldx.b CurTrack
	lda.w InstVolL
	xba
	lda.b EventData1
	jsr.w MulFrac8					; A * B / 128 into A
	sta.w TrackVolL,x
	lda.w InstVolR
	xba
	lda.b EventData1
	jsr.w MulFrac8					; A * B / 128 into A
	sta.w TrackVolR,x
	ldy.b #$07
.loop:								; rescale each voice of this track, Y = voice 7 down to 0
	lda.w VoiceTrack,y
	cmp.b CurTrack
	bne .1xxx
	ldx.b CurTrack
	lda.w TrackVolL,x
	xba
	lda.w VoiceVelocity,y
	jsr.w MulFrac8					; A * B / 128 into A
	sta.w VoiceVolL
	lda.w TrackVolR,x
	xba
	lda.w VoiceVelocity,y
	jsr.w MulFrac8					; A * B / 128 into A
	sta.w VoiceVolR
.loop2:								; wait for the SPC port to be free
	lda.w APUIO0
	bne .loop2
	lda.w VoiceVolR
	sta.w APUIO3
	lda.w VoiceVolL
	sta.w APUIO2
	sty.w APUIO1
	lda.b #$0E
	sta.w APUIO0
.loop3:								; wait for the SPC to acknowledge the command
	cmp.w APUIO0
	bne .loop3
	stz.w APUIO0
.1xxx:								; next voice
	dey
	bpl .loop
	rep #$20
	jmp.w .12
.4:									; controller $07: use the second data byte
	lda.b EventData2
	sta.b EventData1
	jmp.w .3
.10:								; $DF: controller change?
	cpy.b #$DF
	beq .t1xxxxx
	jmp.w .t5

.t1xxxxx:							; $DF: controller number in EventData1
	ldy.b EventData1
	cpy.b #$07
	beq .4
.1xxxx:								; controller $40: sustain pedal
	cpy.b #$40
	bne .t2x
	sep #$20
	ldx.b CurTrack
	lda.b EventData2
	sta.w TrackSustain,x
	bne .3x
	ldx.b #$07
.loopx:								; pedal released: release this track's voices
	lda.w VoiceTrack,x
	cmp.b CurTrack
	bne .2xx
	lda.w VoiceState,x
	beq .2xx
	phx
	txy
	txa
	asl a
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
	lda.b EventData2
	sta.w TrackVolL,x
	rep #$20
	jmp.w .12

.t1xxxxxx:							; controller $0C: right volume
	cpy.b #$0C
	bne .t4
	sep #$20
	ldx.b CurTrack
	lda.b EventData2
	sta.w TrackVolR,x
	rep #$20
	jmp.w .12

.t4:								; controller $32: echo voices
	cpy.b #$32
	bne .t1x2
	sep #$20
	lda.b EventData2
	sta.w EchoVoices
	jsr.w SeqCmd08
	rep #$20
	jmp.w .12

.t1x2:								; controller $33: echo delay
	cpy.b #$33
	bne .t2xx
	sep #$20
	lda.b EventData2
	sta.w EchoDelay
	jsr.w SeqCmd08
	rep #$20
	jmp.w .12

.t2xx:								; controller $34: echo volume
	cpy.b #$34
	bne .t1xxxxxxx
	sep #$20
	lda.b EventData2
	sta.w EchoVolume
	jsr.w SeqCmd08
	rep #$20
	jmp.w .12

.t1xxxxxxx:							; controller $35: echo feedback
	cpy.b #$35
	bne .t3x
	sep #$20
	lda.b EventData2
	sta.w EchoFeedback
	jsr.w SeqCmd08
	rep #$20
	jmp.w .12

.t3x:								; controller $37: master volume high byte
	cpy.b #$37
	bne .t1x2x
	sep #$20
	lda.b EventData2
	sta.w SoundVolume+1
	jsr.w SeqCmd08Init_send
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
	lda.b EventData2
	sta.w NoiseVoices
	jsr.w SeqCmd08Init_send
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
	lda.b EventData2
	sep #$20
	asl a
	rep #$20
	sec
	sbc.w #$4000
	asl a
	sep #$20
	xba
	ldx.b CurTrack
	sta.w TrackBend,x
	sta.b BendAmount
	lda.w TrackBendRange,x
	bne .t1x3
.1x2:								; no bend range: nothing to do
	jmp.w .8

.t1x3:								; bend range of the track in EventCode
	sta.b EventCode
	ldy.b #$07
.4x:								; each voice of this track, Y = 7 down to 0
	lda.w VoiceTrack,y
	cmp.b CurTrack
	beq .t3xx
	jmp.w .7

.t3xx:								; this voice belongs to the track
	phy
	tya
	asl a
	tax
	phx
	lda.b BendAmount
	beq .t1xxxxxxxxx
	bmi .t2xxxx
	lda.w VoiceNote,y
	clc
	adc.b EventCode
	asl a
	tax
	rep #$20
	lda.l PitchTable,x
	plx
	sec
	sbc.w VoiceBasePitch,x
	sta.b EventData2
	sep #$20
	lda.b BendAmount
	tay
	rep #$20
	lda.b EventData2
	jsr.w MulFrac16
	clc
	adc.w VoiceBasePitch,x
	sta.b EventData1
	bra .6

.t1xxxxxxxxx:						; no bend: back to the base pitch
	rep #$20
	plx
	lda.w VoiceBasePitch,x
	sta.b EventData1
	bra .6

.t2xxxx:							; bend down: pitch of the note below
	lda.w VoiceNote,y
	sec
	sbc.b EventCode
	asl a
	tax
	rep #$20
	lda.l PitchTable,x
	sta.b EventData1
	plx
	lda.w VoiceBasePitch,x
	sec
	sbc.b EventData1
	sta.b EventData2
	sep #$20
	lda.b #$00
	sec
	sbc.b BendAmount
	bpl .t1xxxxxxxxxx
	rep #$20
	lda.b EventData2
	sta.b MulFracResult
	bra .5

.t1xxxxxxxxxx:						; scale the pitch difference
	tay
	rep #$20
	lda.b EventData2
	jsr.w MulFrac16
.5:									; pitch = base pitch - scaled difference
	lda.w VoiceBasePitch,x
	sec
	sbc.b MulFracResult
	sta.b EventData1
.6:									; add the instrument tuning and set the voice pitch
	ldy.b #$02
	lda.b (InstPtr),y
	clc
	adc.b EventData1
	sta.w VoicePitch,x
	ply
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
	lda.b EventData1
	and.w #$00FF
	cmp.w #$006A
	bne .2xxx
.1xxxxxx:							; instrument $6A is replaced by $14
	lda.w #$0014
.2xxx:								; instrument entry from SoundTable
	asl a
	tay
	lda.b [SoundTable],y
	clc
	adc.b SoundTable
	sta.w TrackInst,x
	sta.b InstPtr
	sep #$20
	ldx.b CurTrack
	ldy.b #$2F
	lda.b (InstPtr),y
	sta.w TrackBendRange,x
	stz.w TrackBend,x
	lda.w SoundMono
	bne .t1xxxxxxxxxxx
	ldy.b #$12
	lda.b (InstPtr),y
	sta.w TrackVolL,x
	iny
	lda.b (InstPtr),y
	bra .3xx

.t1xxxxxxxxxxx:						; mono sound: other volume byte of the instrument
	ldy.b #$17
	lda.b (InstPtr),y
	sta.w TrackVolL,x
.3xx:								; right volume of the track
	sta.w TrackVolR,x
.4xx:								; $EA?
	rep #$20
	cpy.b #$EA
	bne .2xxxx
.1xxxxxxx:							; $EA: store the data, never read
	lda.b EventData1
	and.w #$00FF
	sta.b EventEAUnused
.2xxxx:								; command done
	rep #$20
	jmp.w .12
.11:								; note: on track 9 pick the instrument from the note
	sep #$20
	lda.b CurTrack
	cmp.b #$09
	bne .1xxxxxxxx
	asl a
	tax
	tya
	sec
	sbc.b #$2F
	asl a
	tay
	rep #$20
	lda.b [SoundTable],y
	clc
	adc.b SoundTable
	sta.b InstPtr
	lda.b InstPtr
	sta.w TrackInst,x
	sep #$20
	ldx.b CurTrack
	ldy.b #$12
	lda.b [InstPtr],y
	sta.w TrackVolL,x
	iny
	lda.b [InstPtr],y
	sta.w TrackVolR,x
	ldy.b #$2F
	lda.b [InstPtr],y
	sta.w TrackBendRange,x
	stz.w TrackBend,x
.1xxxxxxxx:							; start the voice
	lda.b CurTrack
	asl a
	tax
	rep #$20
	jsr.w StartSoundVoice			; start the note on a voice
.12:								; read the delta time to the next event
	jsr.w ReadVarLen
	ldx.w CurTrackOfs
	cmp.w #$0000
	bne .t2xxxxx
	jmp.w .2

.t1xxxxxxxxxxxx:					; unused: read the delta again
	rep #$20
	bra .12

.t2xxxxx:							; nonzero: the track waits
	sta.w TrackWait,x
	lda.b CurTrackPtr
	sta.w TrackPtr,x
.13:								; count the wait down
	dec.w TrackWait,x
.14:								; return with the track in X
	sep #$30
	ldx.b CurTrack
	rts
