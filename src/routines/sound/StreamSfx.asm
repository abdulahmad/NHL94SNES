; Ask for streamed sound effect A (1-6): stop the one playing if it differs (StopSound), then streamsfx = A,
; streamstate = 0
; Takes A = stream sound number (1-6). If another stream is playing, its sound is stopped with StopSound;
; streamstate is set back to 0 and streamsfx to A.
;
; Called from Goal, clockcont_0, ReplayMode, puckgoalie and FallDown.
StreamSfx:							; request streamed sound A
	sep #$20
	dec.w SoundLock
	rep #$20
	sta.b r3
	phx
	lda.l streamsfx
	beq .1
	cmp.b r3
	beq .2
	lda.l streamsfx
	cmp.w #$0003
	bcc .2
	asl a
	tax
	lda.l StreamSfxSounds-2,x
	jsl.l StopSound
.1:									; start the new stream
	lda.w #$0000
	sta.l streamstate
	lda.b r3
	sta.l streamsfx
.2:									; done
	sep #$20
	inc.w SoundLock
	rep #$20
	plx
	rtl
