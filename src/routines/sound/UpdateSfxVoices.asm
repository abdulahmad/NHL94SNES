; Each frame: step the sound effect voices (owner $08FA $10 and up): their time and envelope counters, the
; voice commands, and StopVoice when one ends
UpdateSfxVoices:
	ldx.b #$00
	txy
.3:
	sty.b CurVoice
	stx.w VoiceOfs
	lda.w VoiceState,y
	bne .t1
	jmp.w .6

.t1:
	pha
	lda.w VoiceTrack,y
	cmp.b #$10
	bcc .1
	jsr.w UpdateVoice
.1:
	rep #$20
	lda.w VoiceInst,x
	sta.b InstPtr
	lda.w VoicePitch,x
	sta.b SendPitch
	lda.w VoiceGain,x
	sta.b GainWord
	lda.w VoiceAge,x
	inc a
	sta.w VoiceAge,x
	ldy.b #$1A
	cmp.b (InstPtr),y
	bcs .2
	ldy.b #$18
	cmp.b (InstPtr),y
	bcc .2
	dec.w VoiceVibCount,x
	bmi .t3
.2:
	jmp.w .5

.t3:
	ldy.b #$2A
	lda.b (InstPtr),y
	clc
	adc.w VoiceVibRateFrac,x
	sta.w VoiceVibRateFrac,x
	iny
	iny
	lda.b (InstPtr),y
	adc.w VoiceVibRate,x
	sta.w VoiceVibRate,x
	sta.w VoiceVibCount,x
	ldy.b #$26
	lda.b (InstPtr),y
	clc
	adc.w VoiceVibDepthFrac,x
	sta.w VoiceVibDepthFrac,x
	iny
	iny
	lda.b (InstPtr),y
	adc.w VoiceVibDepth,x
	sta.w VoiceVibDepth,x
	ldy.b #$22
	lda.b (InstPtr),y
	clc
	adc.w VoiceVibSpeedFrac,x
	sta.w VoiceVibSpeedFrac,x
	iny
	iny
	lda.b (InstPtr),y
	adc.w VoiceVibSpeed,x
	sta.w VoiceVibSpeed,x
	bit.w VoiceVibDir,x
	bmi .t2
	clc
	adc.w VoiceVibOfs,x
	sta.w VoiceVibOfs,x
	bmi .4
	cmp.w VoiceVibDepth,x
	bcc .4
	ldy.b #$2D
	lda.b (InstPtr),y
	and.w #$4000
	bne .t1x
.1x:
	stz.w VoiceVibOfs,x
	bra .4

.t1x:
	dec.w VoiceVibDir,x
	bra .4

.t2:
	lda.w VoiceVibOfs,x
	sec
	sbc.w VoiceVibSpeed,x
	sta.w VoiceVibOfs,x
	bpl .4
	eor.w #$FFFF
	inc a
	cmp.w VoiceVibDepth,x
	bcc .4
	ldy.b #$2D
	lda.b (InstPtr),y
	bmi .t1xx
	stz.w VoiceVibOfs,x
	bra .4

.t1xx:
	inc.w VoiceVibDir,x
.4:
	lda.w VoiceVibOfs,x
	clc
	adc.b SendPitch
	sta.b SendPitch
.5:
	ply
	cpy.b #$02
	bne .7
	sep #$20
	ldy.b CurVoice
	jsr.w SeqCmd0B
.6:
	jmp.w .8
.7:
	cpy.b #$04
	bne .t2x
	rep #$20
	ldy.b #$10
	lda.w VoiceGain,x
	sec
	sbc.b (InstPtr),y
	sta.w VoiceGain,x
	bcs .t1xxx
	sep #$20
	ldy.b CurVoice
	jsr.w StopVoice
	bra .8

.t1xxx:
	sep #$20
	ldy.b CurVoice
	jsr.w SeqCmd0B
	bra .8

.t2x:
	sep #$20
	ldy.b CurVoice
	jsr.w SeqCmd0C0B
.8:
	sep #$20
	inx
	inx
	iny
	cpy.b #$08
	bcs .t1xxxx
	jmp.w .3

.t1xxxx:
	rts
