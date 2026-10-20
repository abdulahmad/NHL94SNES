; Start sound A (an entry of SoundTable) on a free sound effect voice, and return the voice number in A (this
; sound's voice when it already plays). During a replay nothing is recorded; otherwise the sound is kept in
; recsfx for the replay record (the previous one moves to recsfx2). The sound itself starts in PlaySoundEntry
; Called from PuckSfx, UpdateStreamSfx, puckfaceoff2, Pausemode and others.
QueueSound:							; queue sound A
	phx								;keep the registers
	phy
	phb
	php
	pha								;keep the sound number
	sep #$30						;8-bit A, X and Y
	dec.w SoundLock					;sound update off
	lda.b SoundBank					;data bank = the bank of the sound entries
	pha
	plb
	rep #$30
	lda.b r0+1,s					;the sound number back
	sep #$10
	asl a
	tay								;Y = the sound's word in the table
	lda.b [SoundTable],y			;offset of its entry
	clc
	adc.b SoundTable
	sta.b InstPtr					;InstPtr = its entry
	ldx.b #$00						;X = voice * 2
	txy								;Y = voice
.1:									;look at each of the 8 voices
	lda.w VoiceInst,x				;the entry the voice plays
	cmp.b InstPtr
	beq .3							;this sound: is it still playing?
.2:									;next voice
	inx
	inx
	iny
	cpy.b #$08
	bne .1
	ldx.b #$10						;the sound effect track (track $10)
	stx.b CurTrack
	ldx.b #$20						;its offset (track * 2)
	stx.w CurTrackOfs
	lda.b InstPtr
	sta.w TrackInst,x				;the track plays this entry
	lda.w sflags
	bit.w #sf2replay
	bne .t1							;a replay is running: do not record the sound
	pla								;the sound number
	phx
	rep #$10
	ldx.w recsfx
	bmi .1x							;no sound recorded this frame yet
	ldx.w recsfx
	stx.w recsfx2
	ldx.w recsfxpitch
	stx.w recsfxpitch2
	ldx.w recsfxvol
	stx.w recsfxvol2
.1x:								; store this sound as the recorded one
	sta.w recsfx					;record this sound
	sep #$10
	plx
	jmp.w PlaySoundEntry			;start it

.t1:								;no record
	pla
	jmp.w PlaySoundEntry
.3:									;a voice has this sound: is it busy?
	lda.w VoiceState,y
	and.w #$00FF
	beq .2							;free: keep looking
	pla								;drop the sound number
	tya								;return the voice number
	and.w #$00FF
	sep #$20
	inc.w SoundLock					;sound update on
	plp
	plb
	ply
	plx
	rtl
