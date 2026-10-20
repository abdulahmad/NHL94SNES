; Stop every voice that plays sound A
; A = sound number. Looks up its instrument entry through SoundTable and calls StopVoice for each of the 8
; voices whose VoiceInst is that entry. The sound code is locked meanwhile.
;
; Called from StreamSfx.
StopSound:							; stop all voices playing sound A
	phx
	phy
	phb
	php
	sep #$30
	dec.w SoundLock
	pha
	lda.b SoundBank
	pha
	plb
	pla
	asl a
	tay
	rep #$20
	lda.b [SoundTable],y
	clc
	adc.b SoundTable
	sta.b InstPtr
	ldx.b #$00
	txy
.loop:								; each voice, X = 2*voice, Y = voice
	lda.w VoiceInst,x
	cmp.b InstPtr
	bne .1							; not this sound
	jsr.w StopVoice
.1:									; next voice
	inx
	inx
	iny
	cpy.b #$08
	bne .loop
	sep #$20
	inc.w SoundLock
	plp
	plb
	ply
	plx
	rtl
