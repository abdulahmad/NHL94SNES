; Play sound A with half the puck velocity in $0C / $0E, then sfx
; Takes A = sound number. p0 = puckvx/2 and p0+2 = puckvy/2 (arithmetic shift) are set up, then the flow
; continues in sfx. The "sfx" entry takes A = sound number and the velocity words in p0 / p0+2: the loudness
; is (vx^2 + vy^2) / 8 of their high bytes, limited to $70, and the pitch is the instrument pitch scaled by a
; random factor $C0-$FF. The sound is queued with QueueSound and a voice just started gets that pitch.
;
; Called from dopass, doshot, puckgoalie, puckglue, checkgoal and puckstick.
PuckSfx:							; play sound A with half the puck velocity
	pha
	lda.w puckvx
	cmp.w #$8000
	ror a
	sta.b p0
	lda.w puckvy
	cmp.w #$8000
	ror a
	sta.b p0+2
	pla
sfx:								; play sound A with the velocity in p0 / p0+2
	phx
	sta.b p1+2
	asl a
	tay
	lda.b [SoundTable],y
	clc
	adc.b SoundTable
	sta.b InstPtr
	lda.b p0+1
	and.w #$00FF
	cmp.w #$0080
	bcc .1
	ora.w #$FF00
.1:									; sign extend the X velocity byte
	tax
	jsl.l Mul8S
	sta.b SfxVelocity
	lda.b p0+3
	and.w #$00FF
	cmp.w #$0080
	bcc .2
	ora.w #$FF00
.2:									; sign extend the Y velocity byte
	tax
	jsl.l Mul8S
	clc
	adc.b SfxVelocity
	lsr a
	lsr a
	lsr a
	sta.b SfxVelocity
	cmp.w #$0070
	bcs .t1
	xba
	sta.b SfxVelocity
	bra .3

.t1:								; loudness limit
	lda.w #$7000
	sta.b SfxVelocity
.3:									; pitch: instrument pitch times a random factor
	ldy.w #$0002
	lda.b [InstPtr],y
	tax
	lda.w seed
	and.w #$003F
	clc
	adc.w #$00C0
	jsl.l Mul16x8U
	lda.b r2+1
	sta.b p0
	lda.b p1+2
	jsl.l QueueSound
	tay
	sep #$20
	dec.w SoundLock
	lda.w VoiceState,y
	cmp.b #$02
	bne .1x
	lda.b #$03
	sta.w VoiceState,y
	rep #$20
	tya
	asl a
	tay
	lda.b p0
	sta.w VoicePitch,y
	sta.w recsfxpitch
.1x:								; voice started: take the pitch from p0
	sep #$20
	inc.w SoundLock
	rep #$20
	plx
	rtl
