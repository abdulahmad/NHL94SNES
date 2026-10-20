; Find a free voice, starting after the last one used
;
; Picks a sound voice for a new sound. Takes: InstPtr = instrument entry (byte 0 = mask of the voices it
; may use, byte $2A = priority). Returns X = voice number, or $FF if no voice could be taken. The search
; starts after the voice used last (VoiceRotor). Called by StartSoundVoice.
FindFreeVoice:						; find a free voice, else take the best voice of lower priority
	lda.b VoiceRotor				; VoiceRotor = next voice, 0-7
	inc a
	and.b #$07
	sta.b VoiceRotor
	ldy.b #$07						; test 8 voices
	tax
.1:									; voice free (VoiceState 0)?
	lda.w VoiceState,x
	beq .5
.2:									; not usable: next voice, wrapping at 8
	inx
	txa
	and.b #$07
	tax
	dey
	bpl .1							; all tested and none free: look for one to steal
	lda.b #$FF						; no voice found yet ($FF)
	sta.b CurVoice
	stz.w InstVolL					; best state and best age so far = 0
	stz.w VoiceVolL
	stz.w InstVolR
	ldy.b #$2A						; new sound priority (instrument byte $2A)
	lda.b (InstPtr),y
	sta.w VoiceVolR
	lda.b #$08						; scan 8 voices
	sta.b StealCount
	ldx.b VoiceRotor
	ldy.b #$0E
.3:									; the voice must be in the instrument's voice mask
	lda.b (InstPtr)
	and.l ByteBitMasks,x
	beq .4
	lda.w VoiceVolR					; and the new priority must be at least the priority of the voice
	cmp.w VoicePriority,x
	bcc .4
	lda.w VoiceState,x				; prefer the voice with the highest state, then the highest age
	cmp.w InstVolR
	bcc .4
	bne .t1
	rep #$20
	lda.w VoiceAge,y
	cmp.w InstVolL
	bcc .4
	stx.b CurVoice
	sta.w InstVolL
	bra .4

.t1:								; higher state than the best so far: take it
	stx.b CurVoice
	sta.w InstVolR
	rep #$20
	lda.w VoiceAge,y
	sta.w InstVolL
.4:									; next voice (Y counts the ages down by words)
	sep #$20
	inx
	txa
	and.b #$07
	tax
	dey
	dey
	dec.b StealCount
	bne .3
	ldx.b CurVoice					; X = voice taken ($FF if none)
	txy
	jmp.w SeqCmd0C					; cut that voice (command $0C, Y = voice) and return
.5:									; free voice found: usable only if the instrument's voice mask has its bit
	lda.b (InstPtr)
	and.l ByteBitMasks,x
	beq .2
	rts								; take it, X = voice
