; silence everything and reset the player; SoundVolume = $5000
; Takes nothing. Locks the sound code, releases all voices, clears the sound RAM from SongUnused on, sets
; SoundVolume to $5000 and TempoTick to $12, clears the tracks and sends the initial command to the SPC.
;
; Called from SPCMenuUpload, SPCIntroUpload, SPCTitleUpload, SPCGameUpload, Pausemode and SoundUpdate.
SoundInit:							; reset the sound player
	php								; save flags
	sep #$20						; 8-bit A, 16-bit index
	rep #$10						; lock value
	lda.b #$FF						; SoundUpdate does nothing while locked
	sta.w SoundLock					; release every voice
	jsl.l SoundVoicesOff			; bank of the sound table
	ldx.b SoundTable+2				; remember it as the sound bank
	stx.b SoundBank					; clear $021B bytes of sound RAM
	ldx.w #$021A
.loop:								; clear the sound RAM, one byte per pass
	stz.w SongUnused,x
	dex
	bpl .loop
	ldx.w #$5000					; full volume start value
	stx.w SoundVolume				; set SoundVolume
	sep #$10						; 8-bit index
	ldy.b #$00						; first track
	ldx.b #$11						; number of tracks to clear
	jsr.w ClearTracks				; clear the tracks
	ldy.b #$F6						; delay loop, about 246 x 256 passes
.loop2:								; inner delay loop
	dex
	bne .loop2
	dey
	bne .loop2
	jsr.w SeqCmd08Init				; send the setup command to the SPC
	lda.b #$12						; initial tempo tick
	sta.w TempoTick
	stz.w SoundLock					; unlock the sound code
	stz.b VoiceRotor				; restart the voice search at voice 0
	plp
	rtl
