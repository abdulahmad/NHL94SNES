; release every voice
; Takes nothing. Stops all 8 voices (Y = voice, X = 2*voice) with StopVoice while the sound is locked.
;
; Called from SoundInit and ReplayMode.
SoundVoicesOff:						; release every voice
	php								; save flags
	sep #$30						; 8-bit registers
	dec.w SoundLock					; lock the sound code
	ldy.b #$07						; voice 7
	ldx.b #$0E						; voice offset 14
.loop:								; every voice from 7 down to 0
	jsr.w StopVoice					; stop it
	dex								; next voice offset
	dex
	dey								; next voice
	bpl .loop						; until voice 0 is done
	inc.w SoundLock					; unlock
	plp
	rtl
