; Switch the sound driver to the intro sample set (IntroSampleList: the one sample of the power-on sequence,
; sound table IntroSfxTable), called from IntroSequence. It marks the same bank value as the game
; set, so a following SPCGameUpload or SPCTitleUpload skips its upload. Nothing happens when that value is
; already set
SPCIntroUpload:
	stz.w cursong
	lda.w sndbank					;the sample set loaded in the SPC
	cmp.w #SoundBankGame
	beq .rtl						;value 1 is already set
	jsl.l forceblack				;black screen: the SPC is silent and busy during the upload
	lda.w #SoundBankGame
	sta.w sndbank					;mark the set as loaded
	sep #$20						;8-bit A
	dec.w SoundLock					;sound update off
	rep #$20						;16-bit A
	jsl.l SPCCmd01					;driver command 1: empty the sample area
	sep #$20
	inc.w SoundLock					;sound update on
	rep #$20
	lda.w #IntroSfxTable>>16
	sta.b SoundTable+2
	lda.w #IntroSfxTable
	sta.b SoundTable
	jsl.l SoundInit					;reset the player on that table
	ldx.w #$0000					;sample list offset
.loop:
	lda.l IntroSampleList,x
	sta.b p0						;long pointer to the sample
	lda.l IntroSampleList+2,x
	sta.b p0+2
	phx								;keep the offset
	jsl.l SPCUploadBlock			;send the sample
	plx
	inx								;next entry (4 bytes)
	inx
	inx
	inx
	cpx.w #$0004					;one entry
	bne .loop
.rtl:
	rtl
