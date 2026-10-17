; Each frame: stream the sample block of streamsfx (.7) to the sound CPU (SPCStreamStart / SPCStreamNext),
; then play it (QueueSound from StreamSfxSounds)
UpdateStreamSfx:
	rep #$30
	lda.w SoundLock
	and.w #$00FF
	bne .3
	lda.w sndbank
	cmp.w #$0002
	beq .3
	lda.w gmclock
	bne .2
	lda.w MusicOn
	beq .t1
	bra .2

.t1:
	stz.w cursong
.2:
	lda.l streamsfx
	beq .3
	lda.l streamstate
	beq .t2
	jmp.w .6

.t2:
	lda.l streamsfx
	cmp.l streamloaded
	beq .t1x
.loop:
	jsl.l SPCCmd02
	cmp.w #$0015
	bcc .4
.1:
	jsl.l SPCCmd04
	bra .loop

.t1x:
	lda.l streamsfx
	asl a
	tax
	lda.w #$7000
	sta.b SfxVelocity
	lda.l StreamSfxSounds-2,x
	jsl.l QueueSound
	lda.w #$0003
	sta.l streamstate
.3:
	rtl
.4:
	lda.l streamsfx
	sta.l streamloaded
	asl a
	asl a
	tax
	lda.l .7-4,x
	sta.b StreamSrc
	lda.l .7-2,x
	sta.b StreamSrc+2
	ldy.w #$0000
	lda.b [StreamSrc],y
	xba
	sta.b StreamLoop
	ldy.w #$0002
	lda.b [StreamSrc],y
	xba
	tax
	ldy.b StreamLoop
	lda.b StreamSrc
	clc
	adc.w #$0004
	sta.b StreamSrc
	jsl.l SPCStreamStart
	lda.w #$0001
	sta.l streamstate
.5:
	rtl
.6:
	cmp.w #$0003
	beq .1x
	jsl.l SPCStreamNext
	cmp.w #$0000
	beq .t1xx
	lda.l streamstate
	cmp.w #$0001
	bne .5
	lda.w #$0002
	sta.l streamstate
	lda.l streamsfx
	asl a
	tax
	lda.w #$7000
	sta.b SfxVelocity
	lda.l StreamSfxSounds-2,x
	jsl.l QueueSound
	rtl

.t1xx:
	lda.w #$0003
	sta.l streamstate
.1x:
	rtl
.7:									;long pointers to the blocks for the sound CPU that the code above streams
									;in
	dd StreamSamplePeriodEnd,StreamSampleGoal,StreamSampleBigHit
	dd StreamSampleSave,StreamSamplePuckBody,StreamSampleOverGlass
