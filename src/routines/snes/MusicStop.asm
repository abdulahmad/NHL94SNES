; stop the song: release its voices and clear its tracks
MusicStop:							; stop the song: release its voices and clear its tracks
	php
	sep #$30
	lda.b #$FF
	sta.w SoundLock
	stz.w MusicOn
	stz.w TrackCount
	ldy.b #$07
	ldx.b #$0E
.loop:
	lda.w VoiceTrack,y
	cmp.b #$10
	bcs .1
	lda.w VoiceState,y
	beq .1
	jsr.w StopVoice
.1:
	dex
	dex
	dey
	bpl .loop
	ldy.b #$00
	ldx.b #$10
	jsr.w ClearTracks
	stz.w SoundLock
	plp
	rtl
