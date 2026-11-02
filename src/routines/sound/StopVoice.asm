; Stop voice Y
; Takes Y = voice, X = 2*voice. If the voice plays a streamed effect (its instrument is in the stream range)
; the stream state is cleared. Then VoiceState = 0, VoiceTrack = $FF and a gain command is sent to the SPC.
;
; Called from UpdateSfxVoices, MusicStop, SoundVoicesOff, ReleaseVoice and StopSound.
StopVoice:							; stop voice Y
	rep #$20
	lda.w VoiceInst,x
	cmp.w #$E1C0
	bcc .1
	cmp.w #$E2B1
	bcs .1
	lda.w #$0000
	sta.l streamstate
	lda.w #$0000
	sta.l streamsfx
.1:									; not a stream sound
	sep #$30
	lda.b #$00
	sta.w VoiceState,y
	lda.b #$FF
	sta.w VoiceTrack,y
	lda.b #$9F
	sta.b DSPGain
	jmp.w SeqCmd0C
