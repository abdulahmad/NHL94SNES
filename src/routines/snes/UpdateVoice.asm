; Update voice Y: release it when its sound has ended
; Takes Y = voice, X = 2*voice. While VoiceLength is positive it is counted down. When it reaches 0 and the
; voice is not already releasing (state 4) and its track has no sustain pedal, the voice is released.
;
; Called from UpdateVoices and UpdateSfxVoices.
UpdateVoice:						; update voice Y
	rep #$20
	lda.w VoiceLength,x
	bmi .1							; negative: no length limit
	bne .t1							; still counting
	sep #$20
	lda.w VoiceState,y
	cmp.b #$04						; already releasing?
	beq .rts
	lda.w VoiceTrack,y
	phx
	tax
	lda.w TrackSustain,x
	plx
	cmp.b #$00
	bne .rts						; sustained by its track: keep it
	rep #$20
	jsr.w ReleaseVoice				; release the voice
	sep #$20
.rts:								; leave
	rts

.t1:								; count the length down
	dec.w VoiceLength,x
.1:									; finished
	sep #$20
	rts
