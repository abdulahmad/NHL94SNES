; Update each active voice
; Walks the 8 voices (Y = voice, X = 2*voice), updating each in use that belongs to a music track (VoiceTrack
; below $10). Stores the voice in CurVoice and VoiceOfs.
;
; Called from SequencerTick.
UpdateVoices:						; update the music voices
	ldx.b #$00
	txy
.loop:								; each voice
	sty.b CurVoice
	stx.w VoiceOfs
	lda.w VoiceState,y
	beq .1							; unused voice
	lda.w VoiceTrack,y
	cmp.b #$10
	bcs .1							; not a music track
	jsr.w UpdateVoice				; update voice Y
.1:									; next voice
	inx
	inx
	iny
	cpy.b #$08
	bcc .loop
	rts
