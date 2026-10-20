; Each frame: stream the sample block of streamsfx (.7) to the sound CPU (SPCStreamStart / SPCStreamNext),
; then play it (QueueSound from StreamSfxSounds)
; Takes nothing. Does nothing while sound is locked, while the menu set is loaded or when streamsfx is 0
; (when no game clock runs and no music plays the cursong is cleared). By streamstate: 0 loads the sample
; block of streamsfx into the sound CPU, 1 continues streaming and starts the sound, 3 means done.
;
; Called from NMI_FrameHookReturn.
UpdateStreamSfx:					; stream the sound effect asked for
	rep #$30
	lda.w SoundLock
	and.w #$00FF
	bne .3
	lda.w sndbank					;the sample set loaded in the SPC
	cmp.w #SoundBankMenu
	beq .3							;skip while the menu set is loaded
	lda.w gmclock
	bne .2
	lda.w MusicOn
	beq .t1
	bra .2

.t1:								; no team song playing
	stz.w cursong
.2:									; is a stream asked for?
	lda.l streamsfx
	beq .3
	lda.l streamstate
	beq .t2
	jmp.w .6

.t2:								; state 0: is its block loaded?
	lda.l streamsfx
	cmp.l streamloaded
	beq .t1x
.loop:								; SPCCmd02 result below $15?
	jsl.l SPCCmd02
	cmp.w #$0015
	bcc .4
.1:									; SPCCmd04, then retry SPCCmd02
	jsl.l SPCCmd04
	bra .loop

.t1x:								; block loaded: queue the sound
	lda.l streamsfx
	asl a
	tax
	lda.w #$7000
	sta.b SfxVelocity
	lda.l StreamSfxSounds-2,x
	jsl.l QueueSound
	lda.w #$0003
	sta.l streamstate
.3:									; leave
	rtl
.4:									; load the block: remember it
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
.5:									; leave
	rtl
.6:									; state 1, 2 or 3
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

.t1xx:								; streaming finished
	lda.w #$0003
	sta.l streamstate
.1x:								; leave
	rtl
.7:									;long pointers to the blocks for the sound CPU that the code above streams
									;in
	dd StreamSamplePeriodEnd,StreamSampleGoal,StreamSampleBigHit
	dd StreamSampleSave,StreamSamplePuckBody,StreamSampleOverGlass
